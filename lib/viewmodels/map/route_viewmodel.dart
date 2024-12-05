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

    final double originalDistance = _calculateTotalDistance(originalPolyline);

    // 許容距離範囲の設定 (±50%の範囲)
    final double distanceToleranceMin = originalDistance * 0.5;

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

    //0.0625,
    //0.1875,
    //0.3125,
    //0.4375,
    //0.5636,
    //0.6875,
    //0.8125,
    //0.9375

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

          // 4. 距離範囲や重複チェック
          final combinedDistance = _calculateTotalDistance(combinedPolyline);
          if (combinedDistance >= distanceToleranceMin &&
              !multipleRoutes.any((r) =>
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
  ) async {
    // 複数ルートを取得
    final multipleRoutes =
        await fetchMultipleRoutes(origin, destination, apiKey);
    final List<List<double>> elevationsList = [];

    for (final route in multipleRoutes) {
      final polyline = decodePolyline(route['overview_polyline']['points']);
      final elevations = await fetchElevationsForPolyline(polyline);
      elevationsList.add(elevations);
    }

    // 勾配計算
    final gradientCalculator = GradientCalculator();
    final leastGradientRoute = gradientCalculator.findLeastGradientRoute(
        multipleRoutes, elevationsList, currentMethod);

    print("最も勾配が緩やかなルートを選択しました。");
    return leastGradientRoute;
  }

  Future<LatLng> fetchCoordinatesFromAddress(String address) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey';
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
        'https://maps.googleapis.com/maps/api/elevation/json?locations=$locations&key=$apiKey';
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
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey&alternatives=false';
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
        'https://maps.googleapis.com/maps/api/directions/json?origin=${point.latitude},${point.longitude}&destination=$destination&key=$apiKey&alternatives=true';
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
