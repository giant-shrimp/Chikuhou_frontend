import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RouteViewModel extends ChangeNotifier {
  final String apiKey;

  RouteViewModel({required this.apiKey});

  Future<List<Map<String, dynamic>>> fetchMultipleRoutes(
    String origin,
    String destination,
    String apiKey, {
    int maxRoutes = 21,
  }) async {
    final originalRoute = await _fetchOriginalRoute(origin, destination);
    final originalPolyline =
        decodePolyline(originalRoute['overview_polyline']['points']);
    List<Map<String, dynamic>> multipleRoutes = [originalRoute];

    // 中間地点の割合リスト
    List<double> fractions = [
      0.5,
      0.25,
      0.75,
      0.125,
      0.375,
      0.625,
      0.875,
      0.1875,
      0.3125,
      0.4375,
      0.5625,
      0.6875,
      0.8125,
      0.9375,
    ];

    while (multipleRoutes.length < maxRoutes) {
      bool newRouteAdded = false;

      for (double fraction in fractions) {
        final intermediatePoint =
            _getIntermediatePoint(originalPolyline, fraction);
        final alternativeRoutes =
            await _fetchAlternativeRoutes(intermediatePoint, destination);

        for (final route in alternativeRoutes) {
          if (multipleRoutes.length >= maxRoutes) break;

          // original_polyline と一致する場合をスキップ
          if (route['overview_polyline']['points'] ==
              originalRoute['overview_polyline']['points']) {
            continue;
          }

          // 重複チェック
          if (!multipleRoutes.any((r) =>
              r['overview_polyline']['points'] ==
              route['overview_polyline']['points'])) {
            multipleRoutes.add(route);
            newRouteAdded = true;
          }
        }
      }

      if (!newRouteAdded) {
        // 新しいルートが追加されなかった場合はループを終了
        break;
      }
    }

    return multipleRoutes;
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
