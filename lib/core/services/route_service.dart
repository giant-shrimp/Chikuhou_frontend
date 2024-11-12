import 'package:flutter/material.dart';
import '../../core/services/route_service.dart';
import '../../models/route_model.dart';

class RouteViewModel extends ChangeNotifier {
  final RouteService _routeService = RouteService();

  RouteModel? _route;
  RouteModel? get route => _route;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRoute(String origin, String destination) async {
    try {
      _errorMessage = null;
      _route = await _routeService.getRoute(origin, destination);
    } catch (e) {
      _errorMessage = 'Failed to load route: $e';
    } finally {
      notifyListeners();
    }
  }
}
