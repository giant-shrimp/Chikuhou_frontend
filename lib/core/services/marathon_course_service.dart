import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:challecara/models/marathon_course_model.dart';

class MarathonCourseService {
  Future<List<MarathonCourse>> loadAll() async {
    final raw = await rootBundle.loadString('assets/marathon_courses.json');
    final list = json.decode(raw) as List<dynamic>;
    return list.map((j) {
      final m = j as Map<String, dynamic>;
      final pts = (m['points'] as List<dynamic>)
          .map((p) => LatLng(
                (p['lat'] as num).toDouble(),
                (p['lng'] as num).toDouble(),
              ))
          .toList();
      return MarathonCourse(
        id: m['id'] as String,
        name: m['name'] as String,
        description: m['description'] as String,
        distanceKm: (m['distance_km'] as num).toDouble(),
        estimatedMinutes: (m['estimated_minutes'] as num).toInt(),
        elevationGainM: (m['elevation_gain_m'] as num).toDouble(),
        points: pts,
      );
    }).toList();
  }
}
