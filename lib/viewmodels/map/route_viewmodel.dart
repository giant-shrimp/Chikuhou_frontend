import 'package:flutter/material.dart';
import '../../core/services/route_service.dart';
import '../../models/route_model.dart';

class RouteViewModel extends ChangeNotifier {
  final RouteService _routeService;

  RouteViewModel({required RouteService routeService})
      : _routeService = routeService;

  RouteModel? _route;
  RouteModel? get route => _route;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRoute(String origin, String destination) async {
    try {
      _errorMessage = null;
      final routeData = await _routeService.getRoute(origin, destination);
      _route = RouteModel.fromJson(routeData);
    } catch (e) {
      _errorMessage = '経路情報の取得に失敗しました。$e';
    } finally {
      notifyListeners();
    }
  }
}
