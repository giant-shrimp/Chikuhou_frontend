import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

class GradientCalculator {
  /// 勾配を計算し、最も緩いルートを返す
  Map<String, dynamic> findLeastGradientRoute(
      List<Map<String, dynamic>> routes, List<List<double>> elevationsList) {
    if (routes.isEmpty || elevationsList.isEmpty) {
      throw Exception("ルートまたは高度データがありません。");
    }

    double minGradientSum = double.infinity;
    Map<String, dynamic>? leastGradientRoute;

    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      final elevations = elevationsList[i];
      final polyline = decodePolyline(route['overview_polyline']['points']);

      if (polyline.length != elevations.length) {
        throw Exception("ポリラインと高度データの長さが一致しません。");
      }

      double totalGradient = 0.0;

      for (int j = 0; j < polyline.length - 1; j++) {
        final start = polyline[j];
        final end = polyline[j + 1];

        // 2点間の直線距離を計算
        final a = _calculateDistance(start, end);

        // 高度差を計算
        final b = elevations[j + 1] - elevations[j];

        // 勾配を計算 (b が 0 に近い場合は無視)
        if (b != 0) {
          totalGradient += (a * 100 / b).abs();
        }
      }

      // 勾配の総和が最小のルートを更新
      if (totalGradient < minGradientSum) {
        minGradientSum = totalGradient;
        leastGradientRoute = route;
      }
    }

    return leastGradientRoute!;
  }

  /// Polyline をデコード (Google Maps API Polyline)
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

  /// 2点間の直線距離を計算
  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000; // メートル
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
}
