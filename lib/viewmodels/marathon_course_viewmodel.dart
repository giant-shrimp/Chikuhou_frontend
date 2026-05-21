import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:challecara/models/marathon_course_model.dart';
import 'package:challecara/core/services/marathon_course_service.dart';

class MarathonCourseViewModel extends ChangeNotifier {
  final MarathonCourseService _service = MarathonCourseService();

  List<MarathonCourse> courses = [];
  MarathonCourse? selected;
  bool isLoading = true;
  String? error;

  Future<void> load() async {
    try {
      isLoading = true;
      notifyListeners();
      courses = await _service.loadAll();
      selected = courses.isNotEmpty ? courses.first : null;
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void select(String id) {
    selected = courses.firstWhere((c) => c.id == id);
    notifyListeners();
  }

  Set<Polyline> get polylines {
    if (selected == null) return {};
    return {
      Polyline(
        polylineId: PolylineId(selected!.id),
        points: selected!.points,
        color: Colors.deepOrange,
        width: 5,
      ),
    };
  }

  Set<Marker> get markers {
    if (selected == null) return {};
    return {
      Marker(
        markerId: MarkerId('${selected!.id}-start'),
        position: selected!.start,
        infoWindow: const InfoWindow(title: 'スタート'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: MarkerId('${selected!.id}-goal'),
        position: selected!.goal,
        infoWindow: const InfoWindow(title: 'ゴール'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };
  }
}
