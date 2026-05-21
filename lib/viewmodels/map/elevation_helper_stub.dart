import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

Future<List<double>> getElevationAlongPath(
    List<LatLng> points, int samples, String apiKey) async {
  if (points.isEmpty) return [];
  final locations =
      points.map((p) => '${p.latitude},${p.longitude}').join('|');
  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/elevation/json'
    '?locations=${Uri.encodeComponent(locations)}&key=$apiKey',
  );
  try {
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (data['status'] == 'OK') {
        return List<double>.from(
            (data['results'] as List).map((r) => r['elevation'] as double));
      }
    }
  } catch (_) {}
  return [];
}

/// 任意の点群に対して高度を取得する（locations 指定）。
/// パス補間方式の getElevationAlongPath とは別に、与えた点そのものの高度が欲しい用途。
Future<List<double>> getElevationAtPoints(
    List<LatLng> points, String apiKey) async {
  if (points.isEmpty) return [];
  final locations =
      points.map((p) => '${p.latitude},${p.longitude}').join('|');
  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/elevation/json'
    '?locations=${Uri.encodeComponent(locations)}&key=$apiKey',
  );
  try {
    final res =
        await http.get(url).timeout(const Duration(seconds: 10));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (data['status'] == 'OK') {
        return List<double>.from(
            (data['results'] as List).map((r) => r['elevation'] as double));
      }
    }
  } catch (_) {}
  return [];
}
