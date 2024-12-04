import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

class GradientCalculator {
  /// 勾配を計算し、最も緩いルートを返す
  Map<String, dynamic> findLeastGradientRoute(List<Map<String, dynamic>> routes,
      List<List<double>> elevationsList, method) {
    if (routes.isEmpty || elevationsList.isEmpty) {
      throw Exception("ルートまたは高度データがありません。");
    }

    switch (method) {
      case "method_1":
        return _gradientCalcMethod_1(routes, elevationsList);
      case "method_2":
        return _gradientCalcMethod_2(routes, elevationsList);
      case "method_3":
        return _gradientCalcMethod_3(routes, elevationsList);
      case "method_4":
        // 未実装
        return _gradientCalcMethod_4(routes, elevationsList);
      case "method_5":
        // 未実装
        return _gradientCalcMethod_5(routes, elevationsList);
      case "method_6":
        // 未実装
        return _gradientCalcMethod_6(routes, elevationsList);
      case "method_7":
        // 未実装
        return _gradientCalcMethod_7(routes, elevationsList);
      case "method_8":
        // 未実装
        return _gradientCalcMethod_8(routes, elevationsList);
      case "method_9":
        // 未実装
        return _gradientCalcMethod_9(routes, elevationsList);
      default:
        throw Exception("未知の計算方法: $method");
    }
  }

  // 計算方法1:単純勾配計算
  Map<String, dynamic> _gradientCalcMethod_1(
      List<Map<String, dynamic>> routes, List<List<double>> elevationsList) {
    double minGradientSum = double.infinity;
    Map<String, dynamic>? leastGradientRoute;

    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      final elevations = elevationsList[i];
      final polyline = decodePolyline(route['overview_polyline']['points']);

      double totalGradient = 0.0;
      const double distance = 50.0; // 50m間隔

      for (int j = 0;
          j < polyline.length - 1 && j < elevations.length - 1;
          j++) {
        final elevationDiff = elevations[j + 1] - elevations[j];
        if (elevationDiff != 0) {
          totalGradient += (elevationDiff / distance * 100).abs();
        }
      }

      if (totalGradient < minGradientSum) {
        minGradientSum = totalGradient;
        leastGradientRoute = route;
      }
    }

    if (leastGradientRoute == null) {
      throw Exception("最適なルートが見つかりませんでした。");
    }

    return leastGradientRoute;
  }

  /// 計算方法2: 区分求積法
  Map<String, dynamic> _gradientCalcMethod_2(
    List<Map<String, dynamic>> routes,
    List<List<double>> elevationsList,
  ) {
    Map<String, dynamic>? leastGradientRoute;

    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      final elevations = elevationsList[i];
      final polyline = decodePolyline(route['overview_polyline']['points']);
    }

    // null チェックをループ外で行う
    if (leastGradientRoute == null) {
      throw Exception("最適なルートが見つかりませんでした。");
    }

    return leastGradientRoute;
  }

  /// 計算方法3: 線形計算
  Map<String, dynamic> _gradientCalcMethod_3(
    List<Map<String, dynamic>> routes,
    List<List<double>> elevationsList,
  ) {
    Map<String, dynamic>? leastGradientRoute;

    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      final elevations = elevationsList[i];
      final polyline = decodePolyline(route['overview_polyline']['points']);
    }

    // null チェックをループ外で行う
    if (leastGradientRoute == null) {
      throw Exception("最適なルートが見つかりませんでした。");
    }

    return leastGradientRoute;
  }

  /// 計算方法4: ベクトル積
  Map<String, dynamic> _gradientCalcMethod_4(
    List<Map<String, dynamic>> routes,
    List<List<double>> elevationsList,
  ) {
    Map<String, dynamic>? leastGradientRoute;

    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      final elevations = elevationsList[i];
      final polyline = decodePolyline(route['overview_polyline']['points']);
    }

    // null チェックをループ外で行う
    if (leastGradientRoute == null) {
      throw Exception("最適なルートが見つかりませんでした。");
    }

    return leastGradientRoute;
  }

  /// 計算方法5: テイラー展開
  Map<String, dynamic> _gradientCalcMethod_5(
    List<Map<String, dynamic>> routes,
    List<List<double>> elevationsList,
  ) {
    Map<String, dynamic>? leastGradientRoute;

    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      final elevations = elevationsList[i];
      final polyline = decodePolyline(route['overview_polyline']['points']);
    }

    // null チェックをループ外で行う
    if (leastGradientRoute == null) {
      throw Exception("最適なルートが見つかりませんでした。");
    }

    return leastGradientRoute;
  }

  /// 計算方法6: シンプソン法
  Map<String, dynamic> _gradientCalcMethod_6(
    List<Map<String, dynamic>> routes,
    List<List<double>> elevationsList,
  ) {
    Map<String, dynamic>? leastGradientRoute;

    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      final elevations = elevationsList[i];
      final polyline = decodePolyline(route['overview_polyline']['points']);
    }

    // null チェックをループ外で行う
    if (leastGradientRoute == null) {
      throw Exception("最適なルートが見つかりませんでした。");
    }

    return leastGradientRoute;
  }

  /// 計算方法7: フーリエ変換
  Map<String, dynamic> _gradientCalcMethod_7(
    List<Map<String, dynamic>> routes,
    List<List<double>> elevationsList,
  ) {
    Map<String, dynamic>? leastGradientRoute;

    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      final elevations = elevationsList[i];
      final polyline = decodePolyline(route['overview_polyline']['points']);
    }

    // null チェックをループ外で行う
    if (leastGradientRoute == null) {
      throw Exception("最適なルートが見つかりませんでした。");
    }

    return leastGradientRoute;
  }

  ///  計算方法8: ヘルツホルム分解
  Map<String, dynamic> _gradientCalcMethod_8(
    List<Map<String, dynamic>> routes,
    List<List<double>> elevationsList,
  ) {
    Map<String, dynamic>? leastGradientRoute;

    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      final elevations = elevationsList[i];
      final polyline = decodePolyline(route['overview_polyline']['points']);
    }

    // null チェックをループ外で行う
    if (leastGradientRoute == null) {
      throw Exception("最適なルートが見つかりませんでした。");
    }

    return leastGradientRoute;
  }

  ///  計算方法9: リーマン計量
  Map<String, dynamic> _gradientCalcMethod_9(
    List<Map<String, dynamic>> routes,
    List<List<double>> elevationsList,
  ) {
    Map<String, dynamic>? leastGradientRoute;

    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      final elevations = elevationsList[i];
      final polyline = decodePolyline(route['overview_polyline']['points']);
    }

    // null チェックをループ外で行う
    if (leastGradientRoute == null) {
      throw Exception("最適なルートが見つかりませませんでした。");
    }

    return leastGradientRoute;
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
