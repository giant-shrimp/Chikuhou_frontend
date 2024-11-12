class RouteModel {
  final List<String> steps;

  RouteModel({required this.steps});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    // JSONのデータを解析してステップのリストを取得する
    List<String> steps = List<String>.from(json['routes'][0]['legs'][0]['steps']
        .map((step) => step['html_instructions'] as String));
    return RouteModel(steps: steps);
  }
}
