import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../../models/route_model.dart';

class RouteService {
  final String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  Future<RouteModel> getRoute(String origin, String destination) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return RouteModel.fromJson(json);
    } else {
      throw Exception('Failed to load route');
    }
  }
}
