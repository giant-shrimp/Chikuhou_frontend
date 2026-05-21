import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<List<double>> getElevationAlongPath(
    List<LatLng> points, int samples, String apiKey) async {
  if (points.isEmpty) return [];

  // window.getElevationAlongPath が未定義なら空を返す
  try {
    final fn = js.context['getElevationAlongPath'];
    if (fn == null) return [];
  } catch (_) {
    return [];
  }

  final completer = Completer<List<double>>();
  final cbName =
      '_elev_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(99999)}';

  // [[lat, lng], ...] を JS ネイティブ配列に変換
  final latlngsData =
      points.map((p) => [p.latitude, p.longitude]).toList();
  final latlngs = js.JsObject.jsify(latlngsData);

  js.context[cbName] = js.allowInterop((dynamic jsonStr) {
    try {
      final data = jsonDecode(jsonStr.toString()) as Map<String, dynamic>;
      if (data['ok'] == true) {
        completer.complete(List<double>.from(
            (data['elevations'] as List).map((e) => (e as num).toDouble())));
      } else {
        completer.complete([]);
      }
    } catch (_) {
      completer.complete([]);
    }
  });

  try {
    js.context.callMethod('getElevationAlongPath', [latlngs, samples, cbName]);
  } catch (_) {
    js.context.deleteProperty(cbName);
    return [];
  }

  return completer.future.timeout(
    const Duration(seconds: 10),
    onTimeout: () {
      js.context.deleteProperty(cbName);
      return [];
    },
  );
}

/// 任意の点群に対して高度を取得する（JS bridge: getElevationForLocations）。
Future<List<double>> getElevationAtPoints(
    List<LatLng> points, String apiKey) async {
  if (points.isEmpty) return [];

  try {
    final fn = js.context['getElevationForLocations'];
    if (fn == null) return [];
  } catch (_) {
    return [];
  }

  final completer = Completer<List<double>>();
  final cbName =
      '_elev_pts_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(99999)}';

  final latlngsData =
      points.map((p) => [p.latitude, p.longitude]).toList();
  final latlngs = js.JsObject.jsify(latlngsData);

  js.context[cbName] = js.allowInterop((dynamic jsonStr) {
    try {
      final data = jsonDecode(jsonStr.toString()) as Map<String, dynamic>;
      if (data['ok'] == true) {
        completer.complete(List<double>.from(
            (data['elevations'] as List).map((e) => (e as num).toDouble())));
      } else {
        completer.complete([]);
      }
    } catch (_) {
      completer.complete([]);
    }
  });

  try {
    js.context.callMethod('getElevationForLocations', [latlngs, cbName]);
  } catch (_) {
    js.context.deleteProperty(cbName);
    return [];
  }

  return completer.future.timeout(
    const Duration(seconds: 10),
    onTimeout: () {
      js.context.deleteProperty(cbName);
      return [];
    },
  );
}
