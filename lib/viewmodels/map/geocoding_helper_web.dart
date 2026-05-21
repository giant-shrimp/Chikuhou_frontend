import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<LatLng> geocodeAddress(String address, String apiKey) async {
  // まず元のクエリで試し、見つからなければ "福岡" を付けて再試行
  for (final query in [address, '$address 福岡', '$address 日本']) {
    final result = await _geocodeQuery(query);
    if (result != null) return result;
  }
  throw Exception('場所が見つかりませんでした: $address');
}

Future<LatLng?> _geocodeQuery(String query) async {
  final completer = Completer<LatLng?>();
  final cbName =
      '_geo_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(99999)}';

  js.context[cbName] = js.allowInterop((String jsonStr) {
    try {
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      if (data['ok'] == true) {
        completer.complete(
            LatLng(data['lat'] as double, data['lng'] as double));
      } else {
        completer.complete(null);
      }
    } catch (e) {
      completer.complete(null);
    }
  });

  js.context.callMethod('geocodeAddress', [query, cbName]);
  return completer.future;
}
