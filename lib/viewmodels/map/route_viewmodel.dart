import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'gradient_calculator.dart';

class RouteViewModel extends ChangeNotifier {
  final String apiKey;

  final int maxRoutes;

  RouteViewModel({required this.apiKey, this.maxRoutes = 20});

  Future<List<Map<String, dynamic>>> fetchMultipleRoutes(
    String origin,
    String destination,
    String apiKey, {
    int maxRoutes = 20,
  }) async {
    final originalRoute = await _fetchOriginalRoute(origin, destination);
    final originalPolyline =
        decodePolyline(originalRoute['overview_polyline']['points']);

    List<Map<String, dynamic>> multipleRoutes = [originalRoute];

    List<double> fractions = [
      0.5,
      0.25,
      0.75,
      0.125,
      0.375,
      0.675,
      0.875,
      0.1875,
      0.3125,
      0.4375,
      0.5875,
      0.7125,
      0.8125,
      0.9375,
    ];

    while (multipleRoutes.length < maxRoutes) {
      bool newRouteAdded = false;

      for (double fraction in fractions) {
        // 1. `fraction` 地点までの元ポリラインを取得
        final intermediatePath =
            _getIntermediatePath(originalPolyline, fraction);
        final intermediatePoint = intermediatePath.last; // 中間地点を取得

        // 2. `fraction` 地点から目的地までの代替ルートを取得
        final alternativeRoutes =
            await _fetchAlternativeRoutes(intermediatePoint, destination);

        for (final route in alternativeRoutes) {
          final alternativePolyline =
              decodePolyline(route['overview_polyline']['points']);

          // 3. 元ポリラインの始点から `fraction` まで + 代替ポリラインを結合
          final combinedPolyline = [
            ...intermediatePath,
            ...alternativePolyline
          ];

          // 4. 重複チェック
          if (!multipleRoutes.any((r) =>
              r['overview_polyline']['points'] ==
              route['overview_polyline']['points'])) {
            // 5. 結合したポリラインを格納
            multipleRoutes.add({
              'overview_polyline': {
                'points': _encodePolyline(combinedPolyline), // エンコード済みポリラインを格納
              },
              'legs': route['legs'], // 元のルート情報を利用
            });
            newRouteAdded = true;
          }
        }
      }

      if (!newRouteAdded) {
        print('新しいルートが追加されませんでした。ループを終了します。');
        break;
      }

      print('現在のルート数: ${multipleRoutes.length}');
    }

    return multipleRoutes;
  }

  Future<Map<String, dynamic>> fetchLeastGradientRoute(
    String origin,
    String destination,
    String apiKey,
    String currentMethod,
    String currentStatus,
  ) async {
    try {
      print('=== fetchLeastGradientRoute 開始 ===');
      print('選択されたステータス: $currentStatus');
      print('出発地: $origin, 目的地: $destination');

      // 1. 複数ルートを取得
      print('複数ルートを取得中...');
      final multipleRoutes =
          await fetchMultipleRoutes(origin, destination, apiKey);
      print('複数ルート取得完了。ルート数: ${multipleRoutes.length}');

      final List<List<double>> elevationsList = [];

      // オリジナルルートを取得
      final originalRoute = multipleRoutes[0];
      final originalDistance = _calculateTotalDistance(
          decodePolyline(originalRoute['overview_polyline']['points']));
      final originalDuration = originalRoute['legs']
          .fold<double>(0.0, (sum, leg) => sum + leg['duration']['value']);

      print('オリジナルルートの情報: 距離=$originalDistance, 時間=$originalDuration 秒');

      for (final route in multipleRoutes) {
        try {
          final polyline = decodePolyline(route['overview_polyline']['points']);
          print('ルートのポリラインをデコードしました: $polyline');
          final elevations = await fetchElevationsForPolyline(polyline);
          elevationsList.add(elevations);
          print('高度データを取得しました: $elevations');
        } catch (e) {
          print('高度データ取得エラー: $e');
        }
      }

      // 2. 条件に応じたルートフィルタリング
      print('条件に基づきルートをフィルタリング中...');
      List<Map<String, dynamic>> filteredRoutes = _filterRoutesByUserType(
        currentStatus,
        multipleRoutes,
        originalDistance,
        originalDuration,
      );
      print('フィルタリング後のルート数: ${filteredRoutes.length}');

      // 3. 勾配計算またはルート選定
      print('ステータスに応じたルート選定を実行中...');
      switch (currentStatus) {
        case 'runner':
          print('ランナー: 最も勾配が強いルートを選定中');
          final selectedRoute = _selectRouteWithHighestGradient(filteredRoutes);
          print('選定されたルート: $selectedRoute');
          return selectedRoute;

        case 'traveler':
          print('トラベラー: 最短距離のルートを選定中');
          final selectedRoute = _selectShortestRoute(filteredRoutes);
          print('選定されたルート: $selectedRoute');
          return selectedRoute;

        case 'bike':
          print('自転車: APIから新しいルートを取得中');
          final bikerRoute =
              await _fetchBikerRoute(origin, destination, apiKey);
          print('バイカー用ルート取得完了: $bikerRoute');
          return bikerRoute;

        default:
          print('デフォルト処理: 勾配が最も緩やかなルートを選定中');
          final List<List<double>> elevationsList = await Future.wait(
            filteredRoutes.map((route) async {
              final polyline =
                  decodePolyline(route['overview_polyline']['points']);
              return await fetchElevationsForPolyline(polyline);
            }),
          );

          final gradientCalculator = GradientCalculator();
          final leastGradientRoute = gradientCalculator.findLeastGradientRoute(
            filteredRoutes,
            elevationsList,
            currentStatus,
          );
          print('選定された最も緩やかなルート: $leastGradientRoute');
          return leastGradientRoute;
      }
    } catch (e, stackTrace) {
      print('エラー発生: $e');
      print('スタックトレース: $stackTrace');
      throw Exception('ルート計算中にエラーが発生しました: $e');
    }
  }

  Future<LatLng> fetchCoordinatesFromAddress(String address) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&mode=walking&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      } else {
        throw Exception('住所の座標が見つかりませんでした');
      }
    } else {
      throw Exception('住所の座標取得エラー: ${response.statusCode}');
    }
  }

  Future<List<double>> fetchElevationsForPolyline(
      List<LatLng> polylinePoints) async {
    const double segmentDistance = 50.0;
    final List<LatLng> interpolatedPoints =
        _interpolatePolyline(polylinePoints, segmentDistance);
    final List<double> elevations = [];

    for (int i = 0; i < interpolatedPoints.length; i += 500) {
      final chunk = interpolatedPoints.sublist(
        i,
        (i + 500 > interpolatedPoints.length)
            ? interpolatedPoints.length
            : i + 500,
      );

      try {
        final elevationResults = await _fetchElevations(chunk);
        elevations.addAll(elevationResults);
      } catch (e) {
        print('高度データ取得エラー: $e');
      }
    }

    return elevations;
  }

  Future<List<double>> _fetchElevations(List<LatLng> points) async {
    final locations =
        points.map((p) => '${p.latitude},${p.longitude}').join('|');
    final url =
        'https://maps.googleapis.com/maps/api/elevation/json?locations=$locations&mode=walking&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null) {
        return List<double>.from(
            data['results'].map((result) => result['elevation']));
      } else {
        throw Exception('Elevation data not found');
      }
    } else {
      throw Exception('HTTP error: ${response.statusCode}');
    }
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
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey&mode=walking&alternatives=false';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['routes'] != null && data['routes'].isNotEmpty) {
        return data['routes'][0];
      } else {
        throw Exception('ルートが見つかりませんでした');
      }
    } else {
      throw Exception('HTTPエラー: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> _fetchAlternativeRoutes(
      LatLng point, String destination) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${point.latitude},${point.longitude}&destination=$destination&key=$apiKey&mode=walking&alternatives=true';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['routes'] != null && data['routes'].isNotEmpty) {
        return List<Map<String, dynamic>>.from(data['routes']);
      } else {
        throw Exception('代替ルートが見つかりませんでした');
      }
    } else {
      throw Exception('HTTPエラー: ${response.statusCode}');
    }
  }

  LatLng _getIntermediatePoint(List<LatLng> points, double fraction) {
    final index = (points.length * fraction).toInt();
    return points[index.clamp(0, points.length - 1)];
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

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
              .fold<double>(0.0, (sum, leg) => sum + leg['duration']['value']);
          return distance <= originalDistance * 1.3 &&
              duration <= originalDuration * 1.3;
        }).toList();

      case 'stroller':
        return routes.where((route) {
          final distance = _calculateTotalDistance(
              decodePolyline(route['overview_polyline']['points']));
          final duration = route['legs']
              .fold<double>(0.0, (sum, leg) => sum + leg['duration']['value']);
          return distance <= originalDistance * 1.7 &&
              duration <= originalDuration * 1.7;
        }).toList();

      case 'Wheelchair':
        // 車イスは条件なし、全ルート対象
        return routes;

      case 'senior':
        return routes.where((route) {
          final duration = route['legs']
              .fold<double>(0.0, (sum, leg) => sum + leg['duration']['value']);
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
