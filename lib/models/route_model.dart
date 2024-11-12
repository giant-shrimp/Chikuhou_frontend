class RouteModel {
  final String duration;
  final String distance;
  final List<Map<String, double>> polylinePoints; // 座標データのリスト

  RouteModel({
    required this.duration,
    required this.distance,
    required this.polylinePoints,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    if (json['routes'] == null || json['routes'].isEmpty) {
      throw Exception('No routes found');
    }

    // 経路のポイントを取得
    List<Map<String, double>> points = [];
    try {
      List steps = json['routes'][0]['legs'][0]['steps'];
      for (var step in steps) {
        points.add({
          'latitude': step['end_location']['lat'],
          'longitude': step['end_location']['lng'],
        });
      }
    } catch (e) {
      throw Exception('Error parsing route points: $e');
    }

    return RouteModel(
      duration: json['routes'][0]['legs'][0]['duration']['text'],
      distance: json['routes'][0]['legs'][0]['distance']['text'],
      polylinePoints: points,
    );
  }
}
