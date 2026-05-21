import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'gradient_calculator.dart';
import 'directions_helper_stub.dart'
    if (dart.library.html) 'directions_helper_web.dart';
import 'geocoding_helper_stub.dart'
    if (dart.library.html) 'geocoding_helper_web.dart';
import 'elevation_helper_stub.dart'
    if (dart.library.html) 'elevation_helper_web.dart';

class RouteViewModel extends ChangeNotifier {
  final String apiKey;

  final int maxRoutes;

  RouteViewModel({required this.apiKey, this.maxRoutes = 20});

  static const double maxWalkingDistanceMeters = 10000; // 10km上限

  Future<List<Map<String, dynamic>>> fetchMultipleRoutes(
    String origin,
    String destination,
    String apiKey, {
    int maxRoutes = 20,
  }) async {
    final originalRoute = await _fetchOriginalRoute(origin, destination);

    // 徒歩距離が長すぎる場合は中止
    final legs = originalRoute['legs'] as List;
    final totalDistance =
        legs.fold<int>(0, (int sum, dynamic leg) => sum + (leg['distance']['value'] as int));
    if (totalDistance > maxWalkingDistanceMeters) {
      throw Exception('distance_too_long:${(totalDistance / 1000).toStringAsFixed(1)}km');
    }

    // 代替ルート取得（失敗しても継続）
    List<Map<String, dynamic>> alternatives = [];
    try {
      alternatives = await fetchDirections(origin, destination, true, apiKey);
    } catch (_) {}

    // ポリライン文字列で重複除去しながら結合
    final seen = <String>{};
    final allRoutes = <Map<String, dynamic>>[];
    for (final r in [originalRoute, ...alternatives]) {
      final key = r['overview_polyline']['points'] as String;
      if (seen.add(key)) allRoutes.add(r);
      if (allRoutes.length >= maxRoutes) break;
    }

    return allRoutes;
  }

  /// home.dart で取得済みのルート・高度データを受け取り最適ルートを返す
  /// （ユーザーステータスでフィルタ → 分割点高度でスコアリング → 必要なら method で二段階選択）
  ///
  /// [elevationsList] は getElevationAlongPath で取得済みの高度配列。
  /// 分割点高度がすべて取得失敗した場合のフォールバックとして使用する。
  Future<Map<String, dynamic>> fetchLeastGradientRoute({
    required List<Map<String, dynamic>> multipleRoutes,
    required List<List<double>> elevationsList,
    required String currentMethod,
    required String currentStatus,
    required String origin,
    required String destination,
  }) async {
    if (multipleRoutes.isEmpty) throw Exception('ルートがありません');

    if (currentStatus == 'bike') {
      return _fetchBikerRoute(origin, destination, apiKey);
    }

    final originalRoute = multipleRoutes[0];
    final originalDistance = _calculateTotalDistance(
        decodePolyline(originalRoute['overview_polyline']['points']));
    final originalDuration = (originalRoute['legs'] as List).fold<double>(
        0.0,
        (double sum, dynamic leg) =>
            sum + (leg['duration']['value'] as int));

    final filteredRoutes = _filterRoutesByUserType(
      currentStatus,
      multipleRoutes,
      originalDistance,
      originalDuration,
    );
    final effectiveRoutes =
        filteredRoutes.isEmpty ? multipleRoutes : filteredRoutes;
    final effectiveElevations = filteredRoutes.isEmpty
        ? elevationsList
        : elevationsList.sublist(
            0, effectiveRoutes.length.clamp(0, elevationsList.length));

    final calc = GradientCalculator();

    // 各ルートの分割点・距離を先に計算（同期処理）
    final routeMeta = effectiveRoutes.map((route) {
      final polylinePoints =
          decodePolyline(route['overview_polyline']['points']);
      final splitPoints =
          extractSplitPoints(polylinePoints, segmentCount: 10);
      final totalDistance = _calculateTotalDistance(polylinePoints);
      return (splitPoints: splitPoints, totalDistance: totalDistance);
    }).toList();

    // 高度取得を並列実行（逐次待機による遅延を防ぐ）
    final elevationResults = await Future.wait(
      routeMeta.map((m) => fetchElevationsAtPoints(m.splitPoints)),
    );

    // スコアリング
    final List<double?> scores = [];
    for (int i = 0; i < effectiveRoutes.length; i++) {
      final pointElevations = elevationResults[i];
      if (pointElevations.isEmpty) {
        scores.add(null);
        continue;
      }
      final gradients = calc.calcSegmentGradients(
          routeMeta[i].splitPoints, pointElevations);
      scores.add(
          calc.scoreByStatus(currentStatus, gradients, routeMeta[i].totalDistance));
    }

    // 分割点高度がすべて空のときは elevationsList をフォールバックとして使う
    if (!scores.any((s) => s != null)) {
      return _fallbackByElevationsList(
        effectiveRoutes,
        effectiveElevations,
        currentMethod,
        currentStatus,
        calc,
      );
    }

    // Phase 1: スコアで最良ルートを選ぶ（scoreByStatus は「低い=良い」で統一済み）
    int bestIdx = 0;
    double bestScore = double.infinity;
    for (int i = 0; i < scores.length; i++) {
      final s = scores[i];
      if (s == null) continue;
      if (s < bestScore) {
        bestScore = s;
        bestIdx = i;
      }
    }

    // Phase 2: 二段階選択（runner 以外で currentMethod が明示されている場合のみ）
    if (currentStatus != 'runner' && _isExplicitMethod(currentMethod)) {
      final ranked = <int>[];
      for (int i = 0; i < scores.length; i++) {
        if (scores[i] != null &&
            i < effectiveElevations.length &&
            effectiveElevations[i].isNotEmpty) {
          ranked.add(i);
        }
      }
      ranked.sort((a, b) => scores[a]!.compareTo(scores[b]!));
      if (ranked.isNotEmpty) {
        final keepCount = (ranked.length / 2).ceil().clamp(1, ranked.length);
        final phase2Indices = ranked.take(keepCount).toList();
        final phase2Routes =
            phase2Indices.map((i) => effectiveRoutes[i]).toList();
        final phase2Elevations =
            phase2Indices.map((i) => effectiveElevations[i]).toList();
        return calc.findLeastGradientRoute(
            phase2Routes, phase2Elevations, currentMethod);
      }
    }

    return effectiveRoutes[bestIdx];
  }

  Map<String, dynamic> _fallbackByElevationsList(
    List<Map<String, dynamic>> effectiveRoutes,
    List<List<double>> effectiveElevations,
    String currentMethod,
    String currentStatus,
    GradientCalculator calc,
  ) {
    final validIndices = List.generate(effectiveRoutes.length, (i) => i)
        .where((i) =>
            i < effectiveElevations.length &&
            effectiveElevations[i].isNotEmpty)
        .toList();
    final gradientRoutes =
        validIndices.map((i) => effectiveRoutes[i]).toList();
    final gradientElevations =
        validIndices.map((i) => effectiveElevations[i]).toList();

    if (gradientRoutes.isEmpty) return effectiveRoutes[0];

    if (currentStatus == 'runner') {
      return _selectRouteWithHighestGradient(gradientRoutes);
    }
    if (currentStatus == 'traveler') {
      return _selectShortestRoute(gradientRoutes);
    }
    if (_isExplicitMethod(currentMethod)) {
      return calc.findLeastGradientRoute(
          gradientRoutes, gradientElevations, currentMethod);
    }
    return gradientRoutes[0];
  }

  static final RegExp _methodPattern = RegExp(r'^method_\d+$');
  bool _isExplicitMethod(String currentMethod) =>
      _methodPattern.hasMatch(currentMethod);

  Future<LatLng> fetchCoordinatesFromAddress(String address) async {
    return geocodeAddress(address, apiKey);
  }

  // 1ルートにつき最大50サンプルでElevationを取得（リクエスト数を最小化）
  Future<List<double>> fetchElevationsForPolyline(
      List<LatLng> polylinePoints) async {
    if (polylinePoints.isEmpty) return [];
    // ポリラインから均等に最大50点を間引いてサンプリング
    const int maxSamples = 50;
    final List<LatLng> sampled = _samplePoints(polylinePoints, maxSamples);
    return getElevationAlongPath(sampled, sampled.length, apiKey);
  }

  /// 分割点ピンポイントで高度を取得する（locations 指定方式）。
  Future<List<double>> fetchElevationsAtPoints(
      List<LatLng> splitPoints) async {
    if (splitPoints.isEmpty) return [];
    return getElevationAtPoints(splitPoints, apiKey);
  }

  /// ポリライン全体の距離を segmentCount 等分した地点を返す。
  /// 始点・終点を含む segmentCount + 1 点のリスト。
  ///
  /// _interpolatePolyline で十分細かく補間してから、
  /// _getIntermediatePath（fraction 位置までの sub-path）の末尾を採用する。
  /// _getIntermediatePoint はフォールバックとして残す。
  List<LatLng> extractSplitPoints(List<LatLng> polyline,
      {int segmentCount = 10}) {
    if (polyline.isEmpty) return [];
    if (segmentCount < 1) return [polyline.first];
    if (polyline.length == 1) {
      return List.filled(segmentCount + 1, polyline.first);
    }

    final double totalDistance = _calculateTotalDistance(polyline);
    if (totalDistance == 0) {
      return List.filled(segmentCount + 1, polyline.first);
    }

    // index-based fraction が距離-based に近づくよう十分細かく補間する
    final double interpSegment = totalDistance / (segmentCount * 20);
    final List<LatLng> interpolated =
        _interpolatePolyline(polyline, interpSegment);
    // _interpolatePolyline は最終点を含まないケースがあるため明示的に追加する
    if (interpolated.isEmpty ||
        interpolated.last.latitude != polyline.last.latitude ||
        interpolated.last.longitude != polyline.last.longitude) {
      interpolated.add(polyline.last);
    }

    final List<LatLng> result = [];
    for (int k = 0; k <= segmentCount; k++) {
      if (k == 0) {
        result.add(interpolated.first);
        continue;
      }
      if (k == segmentCount) {
        result.add(interpolated.last);
        continue;
      }
      final double fraction = k / segmentCount;
      final subPath = _getIntermediatePath(interpolated, fraction);
      result.add(subPath.isNotEmpty
          ? subPath.last
          : _getIntermediatePoint(interpolated, fraction));
    }
    return result;
  }

  List<LatLng> _samplePoints(List<LatLng> points, int maxCount) {
    if (points.length <= maxCount) return points;
    final result = <LatLng>[];
    final step = (points.length - 1) / (maxCount - 1);
    for (int i = 0; i < maxCount; i++) {
      result.add(points[(i * step).round().clamp(0, points.length - 1)]);
    }
    return result;
  }

  List<LatLng> _interpolatePolyline(
      List<LatLng> points, double segmentDistance) {
    final List<LatLng> interpolatedPoints = [];
    for (int i = 0; i < points.length - 1; i++) {
      final LatLng start = points[i];
      final LatLng end = points[i + 1];
      final double distance = _calculateDistance(start, end);

      if (distance <= segmentDistance) {
        interpolatedPoints.add(start);
        continue;
      }

      final int segments = (distance / segmentDistance).ceil();
      for (int j = 0; j <= segments; j++) {
        final double t = j / segments;
        final double lat = start.latitude + t * (end.latitude - start.latitude);
        final double lng =
            start.longitude + t * (end.longitude - start.longitude);
        interpolatedPoints.add(LatLng(lat, lng));
      }
    }

    return interpolatedPoints;
  }

  /// originalPolylineの最初からfractionまでの全ての座標を返す
  List<LatLng> _getIntermediatePath(List<LatLng> points, double fraction) {
    final int targetIndex =
        (points.length * fraction).toInt().clamp(0, points.length - 1);
    return points.sublist(0, targetIndex + 1);
  }

  double _calculateTotalDistance(List<LatLng> points) {
    double totalDistance = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += _calculateDistance(points[i], points[i + 1]);
    }
    return totalDistance;
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000;
    final double dLat = _degreesToRadians(end.latitude - start.latitude);
    final double dLng = _degreesToRadians(end.longitude - start.longitude);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(start.latitude)) *
            cos(_degreesToRadians(end.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  Future<Map<String, dynamic>> _fetchOriginalRoute(
      String origin, String destination) async {
    final routes = await fetchDirections(origin, destination, false, apiKey);
    if (routes.isEmpty) throw Exception('ルートが見つかりませんでした');
    return routes[0];
  }

  Future<List<Map<String, dynamic>>> _fetchAlternativeRoutes(
      LatLng point, String destination) async {
    try {
      final origin = '${point.latitude},${point.longitude}';
      return await fetchDirections(origin, destination, true, apiKey);
    } catch (_) {
      return [];
    }
  }

  LatLng _getIntermediatePoint(List<LatLng> points, double fraction) {
    final index = (points.length * fraction).toInt();
    return points[index.clamp(0, points.length - 1)];
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    double lat = 0, lng = 0;

    while (index < len) {
      // ビット演算を避け double 算術のみで実装（dart2js の 32-bit 整数制約を回避）
      double result = 0, multiplier = 1;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result += (b % 32) * multiplier;
        multiplier *= 32;
      } while (b >= 32);
      lat += result % 2 != 0 ? -(result + 1) / 2 : result / 2;

      result = 0;
      multiplier = 1;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result += (b % 32) * multiplier;
        multiplier *= 32;
      } while (b >= 32);
      lng += result % 2 != 0 ? -(result + 1) / 2 : result / 2;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  List<Map<String, dynamic>> _filterRoutesByUserType(
    String userType,
    List<Map<String, dynamic>> routes,
    double originalDistance,
    double originalDuration,
  ) {
    switch (userType) {
      case 'walker':
        return routes.where((route) {
          final distance = _calculateTotalDistance(
              decodePolyline(route['overview_polyline']['points']));
          final duration = route['legs']
              .fold<double>(0.0, (double sum, dynamic leg) => sum + (leg['duration']['value'] as num).toDouble());
          return distance <= originalDistance * 1.3 &&
              duration <= originalDuration * 1.3;
        }).toList();

      case 'stroller':
        return routes.where((route) {
          final distance = _calculateTotalDistance(
              decodePolyline(route['overview_polyline']['points']));
          final duration = route['legs']
              .fold<double>(0.0, (double sum, dynamic leg) => sum + (leg['duration']['value'] as num).toDouble());
          return distance <= originalDistance * 1.7 &&
              duration <= originalDuration * 1.7;
        }).toList();

      case 'wheelchair':
        // 車イスは条件なし、全ルート対象
        return routes;

      case 'senior':
        return routes.where((route) {
          final duration = route['legs']
              .fold<double>(0.0, (double sum, dynamic leg) => sum + (leg['duration']['value'] as num).toDouble());
          return duration <= originalDuration * 1.5;
        }).toList();

      default:
        // その他の場合、全ルートを返す
        return routes;
    }
  }

  Map<String, dynamic> _selectShortestRoute(List<Map<String, dynamic>> routes) {
    if (routes.isEmpty) {
      throw Exception('ルートが見つかりませんでした');
    }

    // 最短距離のルートを見つける
    return routes.reduce((shortest, current) {
      final shortestDistance = _calculateTotalDistance(
          decodePolyline(shortest['overview_polyline']['points']));
      final currentDistance = _calculateTotalDistance(
          decodePolyline(current['overview_polyline']['points']));

      // 距離が短い方を選択
      return currentDistance < shortestDistance ? current : shortest;
    });
  }

  Map<String, dynamic> _selectRouteWithHighestGradient(
      List<Map<String, dynamic>> routes) {
    if (routes.isEmpty) {
      throw Exception('ルートが見つかりませんでした');
    }

    // 最も勾配が強いルートを見つける
    return routes.reduce((steepest, current) {
      final steepestGradient = _calculateRouteGradient(
          decodePolyline(steepest['overview_polyline']['points']));
      final currentGradient = _calculateRouteGradient(
          decodePolyline(current['overview_polyline']['points']));

      // 勾配が強い方を選択
      return currentGradient > steepestGradient ? current : steepest;
    });
  }

  double _calculateRouteGradient(List<LatLng> polylinePoints) {
    if (polylinePoints.length < 2) return 0.0;

    double totalGradient = 0.0;

    for (int i = 0; i < polylinePoints.length - 1; i++) {
      final LatLng start = polylinePoints[i];
      final LatLng end = polylinePoints[i + 1];

      // 高度差（仮に `fetchElevationsForPolyline` で取得した高度データが必要）
      final elevationDifference = _fetchElevationDifference(start, end);

      // 距離差
      final horizontalDistance = _calculateDistance(start, end);

      if (horizontalDistance > 0) {
        totalGradient += (elevationDifference / horizontalDistance);
      }
    }

    // 平均勾配を返す
    return totalGradient / (polylinePoints.length - 1);
  }

  double _fetchElevationDifference(LatLng start, LatLng end) {
    // 仮のデータまたは実際の高度データを使う
    final startElevation = _getElevationForPoint(start);
    final endElevation = _getElevationForPoint(end);
    return endElevation - startElevation;
  }

  double _getElevationForPoint(LatLng point) {
    // 高度データを取得する必要がある場合、適切なロジックで処理
    // 仮に 0.0 を返す
    return 0.0;
  }

  Future<Map<String, dynamic>> _fetchBikerRoute(
      String origin, String destination, String apiKey) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey&mode=walking&alternatives=false';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['routes'] != null && data['routes'].isNotEmpty) {
        return data['routes'][0]; // 最初のルートを返す
      } else {
        throw Exception('自転車向けのルートが見つかりませんでした');
      }
    } else {
      throw Exception('HTTPエラー: ${response.statusCode}');
    }
  }
}

String _encodePolyline(List<LatLng> points) {
  StringBuffer encoded = StringBuffer();
  int lastLat = 0;
  int lastLng = 0;

  for (final point in points) {
    int lat = (point.latitude * 1E5).round();
    int lng = (point.longitude * 1E5).round();

    int dLat = lat - lastLat;
    int dLng = lng - lastLng;

    encoded.write(_encodeValue(dLat));
    encoded.write(_encodeValue(dLng));

    lastLat = lat;
    lastLng = lng;
  }

  return encoded.toString();
}

String _encodeValue(int value) {
  value = value < 0 ? ~(value << 1) : (value << 1);
  StringBuffer encoded = StringBuffer();

  while (value >= 0x20) {
    encoded.writeCharCode((0x20 | (value & 0x1f)) + 63);
    value >>= 5;
  }

  encoded.writeCharCode(value + 63);
  return encoded.toString();
}
