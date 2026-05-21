import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:challecara/models/rain_cloud_time_model.dart';

class RainCloudService {
  static const _targetTimesUrl =
      'https://www.jma.go.jp/bosai/jmatile/data/nowc/targetTimes_N1.json';

  Future<List<RainCloudTime>> fetchTimes() async {
    final res = await http.get(Uri.parse(_targetTimesUrl));
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch rain cloud times: ${res.statusCode}');
    }
    final list = json.decode(res.body) as List<dynamic>;
    return list
        .map((e) => RainCloudTime.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  String tileUrlTemplate(RainCloudTime t) =>
      'https://www.jma.go.jp/bosai/jmatile/data/nowc/${t.basetime}/none/${t.validtime}/surf/hrpns/{z}/{x}/{y}.png';
}
