import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarathonCourse {
  final String id;
  final String name;
  final String description;
  final double distanceKm;
  final int estimatedMinutes;
  final double elevationGainM;
  final List<LatLng> points;

  const MarathonCourse({
    required this.id,
    required this.name,
    required this.description,
    required this.distanceKm,
    required this.estimatedMinutes,
    required this.elevationGainM,
    required this.points,
  });

  LatLng get start => points.first;
  LatLng get goal => points.last;
}
