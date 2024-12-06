import 'package:http/http.dart' as http;
import 'dart:convert';

class RouteService {
  final String apiKey;

  RouteService({required this.apiKey});

  Future<Map<String, dynamic>> getRoute(
      String origin, String destination) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=walking&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load route');
    }
  }
}
