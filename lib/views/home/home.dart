import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../viewmodels/map/route_viewmodel.dart';
import '../../viewmodels/map/gradient_calculator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../widgets/common/custom_button.dart';

void main() async {
  await dotenv.load(fileName: ".env"); // dotenvファイルをロード
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Route Display',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  bool _isLoading = false;
  int _loadingRoutesCount = 0; // ローディング中のルート数を追跡

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アルケール'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(33.5902, 130.4017), // 福岡市
              zoom: 14.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            onMapCreated: (controller) => _mapController = controller,
            polylines: _polylines,
          ),
          if (_isLoading)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8), // 半透明の白背景
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(
                      value: _loadingRoutesCount / 20, // 最大20ルートを基準
                      backgroundColor: Colors.grey[200],
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${AppLocalizations.of(context)!.number_of_routes_being_acquired}: $_loadingRoutesCount',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15.0), // 下からの余白を調整
        child: FloatingActionButton(
          onPressed: () {
            _showRouteSearchModal(context);
          },
          backgroundColor: Colors.white.withOpacity(0.8),
          child: const Icon(Icons.south),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  void _setPolylines(Set<Polyline> polylines) {
    setState(() {
      _polylines = polylines;
    });
  }

  Future<void> _showRouteSearchModal(BuildContext context) async {
    String apiKey = dotenv.env['API_KEY']!;
    final routeViewModel = RouteViewModel(apiKey: apiKey);

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.2,
          maxChildSize: 1.0,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              margin: const EdgeInsets.only(top: 64),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.multiple_route_search,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _originController,
                          decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context)!.departure_point,
                            suffixIcon: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _destinationController,
                          decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context)!.destination,
                            suffixIcon: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                        const SizedBox(height: 26),
                        CustomButton(
                          text: AppLocalizations.of(context)!.route_search,
                          onPressed: () async {
                            Navigator.pop(context); // モーダルを閉じる
                            setState(() {
                              _isLoading = true;
                              _loadingRoutesCount = 0; // 初期化
                            });

                            try {
                              // 最初に始点にカメラを移動
                              if (_originController.text.isNotEmpty &&
                                  _destinationController.text.isNotEmpty) {
                                final originLocation = await routeViewModel
                                    .fetchCoordinatesFromAddress(
                                  _originController.text,
                                );
                                final destinationLocation = await routeViewModel
                                    .fetchCoordinatesFromAddress(
                                  _destinationController.text,
                                );

                                // 始点と終点を含む LatLngBounds を計算
                                final bounds = LatLngBounds(
                                  southwest: LatLng(
                                    originLocation.latitude <
                                            destinationLocation.latitude
                                        ? originLocation.latitude
                                        : destinationLocation.latitude,
                                    originLocation.longitude <
                                            destinationLocation.longitude
                                        ? originLocation.longitude
                                        : destinationLocation.longitude,
                                  ),
                                  northeast: LatLng(
                                    originLocation.latitude >
                                            destinationLocation.latitude
                                        ? originLocation.latitude
                                        : destinationLocation.latitude,
                                    originLocation.longitude >
                                            destinationLocation.longitude
                                        ? originLocation.longitude
                                        : destinationLocation.longitude,
                                  ),
                                );

                                // カメラを範囲に移動
                                _mapController?.animateCamera(
                                  CameraUpdate.newLatLngBounds(
                                      bounds, 50), // 50はパディング（余白）
                                );
                              }

                              // ルートを取得
                              final multipleRoutes =
                                  await routeViewModel.fetchMultipleRoutes(
                                _originController.text,
                                _destinationController.text,
                                apiKey,
                              );

                              final List<List<double>> elevationsList = [];
                              final Set<Polyline> allPolylines = {};
                              LatLngBounds? bounds;

                              // ルートを描画
                              for (int i = 0; i < multipleRoutes.length; i++) {
                                final route = multipleRoutes[i];
                                final points = routeViewModel.decodePolyline(
                                    route['overview_polyline']['points']);

                                final elevations = await routeViewModel
                                    .fetchElevationsForPolyline(points);

                                elevationsList.add(elevations);

                                allPolylines.add(
                                  Polyline(
                                    polylineId: PolylineId('route_$i'),
                                    points: points,
                                    color: Colors.blue, // 任意の色
                                    width: 3,
                                  ),
                                );

                                setState(() {
                                  _loadingRoutesCount = i + 1;
                                  _polylines = allPolylines;
                                });
                              }

                              // 勾配が最も緩いルートを特定
                              final gradientCalculator = GradientCalculator();
                              final leastGradientRoute =
                                  gradientCalculator.findLeastGradientRoute(
                                      multipleRoutes, elevationsList);

                              final leastGradientPoints =
                                  routeViewModel.decodePolyline(
                                leastGradientRoute['overview_polyline']
                                    ['points'],
                              );

                              setState(() {
                                _polylines = {
                                  Polyline(
                                    polylineId: const PolylineId(
                                        'least_gradient_route'),
                                    points: leastGradientPoints,
                                    color: Colors.green.withOpacity(0.7),
                                    width: 12,
                                  ),
                                };
                              });

                              // 勾配が緩いルートにカメラを移動
                              final leastGradientBounds =
                                  _calculateBounds(leastGradientPoints);
                              _mapController?.animateCamera(
                                CameraUpdate.newLatLngBounds(
                                    leastGradientBounds, 50),
                              );
                            } catch (error) {
                              print('ルート取得エラー: $error');
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  LatLngBounds _calculateBounds(List<LatLng> points) {
    double? minLat, maxLat, minLng, maxLng;

    for (final point in points) {
      if (minLat == null || point.latitude < minLat) minLat = point.latitude;
      if (maxLat == null || point.latitude > maxLat) maxLat = point.latitude;
      if (minLng == null || point.longitude < minLng) minLng = point.longitude;
      if (maxLng == null || point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
  }

  LatLngBounds _expandBounds(LatLngBounds bounds, List<LatLng> points) {
    final additionalBounds = _calculateBounds(points);
    return LatLngBounds(
      southwest: LatLng(
        bounds.southwest.latitude < additionalBounds.southwest.latitude
            ? bounds.southwest.latitude
            : additionalBounds.southwest.latitude,
        bounds.southwest.longitude < additionalBounds.southwest.longitude
            ? bounds.southwest.longitude
            : additionalBounds.southwest.longitude,
      ),
      northeast: LatLng(
        bounds.northeast.latitude > additionalBounds.northeast.latitude
            ? bounds.northeast.latitude
            : additionalBounds.northeast.latitude,
        bounds.northeast.longitude > additionalBounds.northeast.longitude
            ? bounds.northeast.longitude
            : additionalBounds.northeast.longitude,
      ),
    );
  }
}
