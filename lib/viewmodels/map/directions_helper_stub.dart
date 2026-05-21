import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchDirections(
  String origin,
  String destination,
  bool alternatives,
  String apiKey,
) async {
  Map<String, dynamic> parseLocation(String loc) {
    final m = RegExp(r'^(-?\d+\.?\d*),(-?\d+\.?\d*)$').firstMatch(loc.trim());
    if (m != null) {
      return {
        'location': {
          'latLng': {
            'latitude': double.parse(m.group(1)!),
            'longitude': double.parse(m.group(2)!),
          }
        }
      };
    }
    return {'address': loc};
  }

  final response = await http.post(
    Uri.parse('https://routes.googleapis.com/directions/v2:computeRoutes'),
    headers: {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask':
          'routes.polyline.encodedPolyline,routes.legs.duration,routes.legs.distanceMeters',
    },
    body: jsonEncode({
      'origin': parseLocation(origin),
      'destination': parseLocation(destination),
      'travelMode': 'WALK',
      'computeAlternativeRoutes': alternatives,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception(
        'Routes API error: ${response.statusCode} ${response.body}');
  }

  final data = jsonDecode(response.body) as Map<String, dynamic>;
  final routes = data['routes'] as List?;
  if (routes == null || routes.isEmpty) {
    throw Exception('Routes API returned no results');
  }

  return routes.map<Map<String, dynamic>>((route) {
    final legs = (route['legs'] as List? ?? []).map<Map<String, dynamic>>((leg) {
      final durationSec = int.tryParse(
            ((leg['duration'] as String?) ?? '0s').replaceAll('s', ''),
          ) ??
          0;
      final distanceM = (leg['distanceMeters'] as num?)?.toInt() ?? 0;
      return {
        'distance': {
          'value': distanceM,
          'text': '${(distanceM / 1000).toStringAsFixed(1)} km',
        },
        'duration': {
          'value': durationSec,
          'text': '${(durationSec / 60).round()} 分',
        },
      };
    }).toList();

    return {
      'overview_polyline': {
        'points': route['polyline']['encodedPolyline'] as String,
      },
      'legs': legs,
    };
  }).toList();
}
