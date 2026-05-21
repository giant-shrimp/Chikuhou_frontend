import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'dart:math';

Future<List<Map<String, dynamic>>> fetchDirections(
  String origin,
  String destination,
  bool alternatives,
  String apiKey,
) async {
  final completer = Completer<List<Map<String, dynamic>>>();
  final cbName =
      '_dir_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(99999)}';

  js.context[cbName] = js.allowInterop((String jsonStr) {
    try {
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      if (data['status'] == 'OK') {
        completer
            .complete(List<Map<String, dynamic>>.from(data['routes'] as List));
      } else {
        completer.completeError(
            Exception('DirectionsService failed: ${data['status']}'));
      }
    } catch (e) {
      completer.completeError(e);
    }
  });

  js.context.callMethod('getWalkingDirections',
      [origin, destination, alternatives, cbName]);

  return completer.future;
}
