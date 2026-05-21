import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:challecara/l10n/app_localizations.dart';
import 'package:challecara/viewmodels/rain_cloud_radar_viewmodel.dart';

class RainCloudRadarScreen extends StatelessWidget {
  const RainCloudRadarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RainCloudRadarViewModel()..load(),
      child: const _RainCloudRadarView(),
    );
  }
}

class _RainCloudRadarView extends StatefulWidget {
  const _RainCloudRadarView();

  @override
  State<_RainCloudRadarView> createState() => _RainCloudRadarViewState();
}

class _RainCloudRadarViewState extends State<_RainCloudRadarView> {
  GoogleMapController? _mapController;
  LatLng _initialPos = const LatLng(33.6450, 130.6920); // 飯塚市付近

  @override
  void initState() {
    super.initState();
    _resolveCurrentLocation();
  }

  Future<void> _resolveCurrentLocation() async {
    try {
      LocationPermission p = await Geolocator.checkPermission();
      if (p == LocationPermission.denied) {
        p = await Geolocator.requestPermission();
      }
      if (p == LocationPermission.denied ||
          p == LocationPermission.deniedForever) {
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      final loc = LatLng(pos.latitude, pos.longitude);
      setState(() => _initialPos = loc);
      _mapController?.animateCamera(CameraUpdate.newLatLng(loc));
    } catch (_) {}
  }

  String _formatTime(String t) {
    if (t.length != 14) return t;
    final dt = DateTime.utc(
      int.parse(t.substring(0, 4)),
      int.parse(t.substring(4, 6)),
      int.parse(t.substring(6, 8)),
      int.parse(t.substring(8, 10)),
      int.parse(t.substring(10, 12)),
      int.parse(t.substring(12, 14)),
    ).toLocal();
    return DateFormat('MM/dd HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RainCloudRadarViewModel>();
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.rain_cloud_radar),
        automaticallyImplyLeading: false,
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.error != null
              ? Center(child: Text('エラー: ${vm.error}'))
              : vm.times.isEmpty
              ? const Center(child: Text('雨雲データが取得できませんでした'))
              : Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _initialPos,
                        zoom: 10,
                      ),
                      onMapCreated: (c) => _mapController = c,
                      tileOverlays: {
                        if (vm.buildOverlay() != null) vm.buildOverlay()!,
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 24,
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatTime(vm.current!.validtime),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  if (vm.current!.isForecast)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        '予報',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  IconButton(
                                    icon: Icon(vm.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow),
                                    onPressed: vm.togglePlay,
                                  ),
                                ],
                              ),
                              Slider(
                                value: vm.currentIndex.toDouble(),
                                min: 0,
                                max: (vm.times.length - 1).toDouble(),
                                divisions: vm.times.length - 1,
                                onChanged: (v) => vm.setIndex(v.toInt()),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatTime(vm.times.first.validtime),
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  Text(
                                    _formatTime(vm.times.last.validtime),
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
