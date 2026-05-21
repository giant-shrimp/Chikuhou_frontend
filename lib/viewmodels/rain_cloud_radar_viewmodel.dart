import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:challecara/models/rain_cloud_time_model.dart';
import 'package:challecara/core/services/rain_cloud_service.dart';

class RainCloudRadarViewModel extends ChangeNotifier {
  final RainCloudService _service = RainCloudService();

  List<RainCloudTime> times = [];
  int currentIndex = 0;
  bool isLoading = true;
  String? error;

  Timer? _playTimer;
  bool get isPlaying => _playTimer != null;

  Future<void> load() async {
    try {
      isLoading = true;
      notifyListeners();
      times = await _service.fetchTimes();
      // 観測/予報の境界（最初の forecast）を初期位置にする
      final firstForecast = times.indexWhere((t) => t.isForecast);
      currentIndex = firstForecast > 0 ? firstForecast - 1 : 0;
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  RainCloudTime? get current =>
      times.isEmpty ? null : times[currentIndex];

  void setIndex(int i) {
    currentIndex = i.clamp(0, times.length - 1);
    notifyListeners();
  }

  void togglePlay() {
    if (_playTimer != null) {
      _playTimer!.cancel();
      _playTimer = null;
    } else {
      _playTimer = Timer.periodic(const Duration(milliseconds: 600), (_) {
        final next = currentIndex + 1;
        if (next >= times.length) {
          currentIndex = 0;
        } else {
          currentIndex = next;
        }
        notifyListeners();
      });
    }
    notifyListeners();
  }

  TileOverlay? buildOverlay() {
    final t = current;
    if (t == null) return null;
    return TileOverlay(
      tileOverlayId: TileOverlayId('rain-${t.basetime}-${t.validtime}'),
      tileProvider: _UrlTileProvider(
        urlTemplate: _service.tileUrlTemplate(t),
      ),
      transparency: 0.3,
    );
  }

  @override
  void dispose() {
    _playTimer?.cancel();
    super.dispose();
  }
}

class _UrlTileProvider implements TileProvider {
  final String urlTemplate;
  _UrlTileProvider({required this.urlTemplate});

  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    final url = urlTemplate
        .replaceAll('{z}', '${zoom ?? 0}')
        .replaceAll('{x}', '$x')
        .replaceAll('{y}', '$y');
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        return Tile(256, 256, res.bodyBytes);
      }
    } catch (_) {}
    return TileProvider.noTile;
  }
}
