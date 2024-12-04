import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../viewmodels/map/route_viewmodel.dart';
import '../../viewmodels/map/gradient_calculator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../widgets/common/custom_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../settings/settings_calculation_method.dart';

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

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 状態の初期化
    final mapController = useState<GoogleMapController?>(null);
    final polylines = useState<Set<Polyline>>({});
    final isLoading = useState(false);
    final loadingRoutesCount = useState(0);
    final originController = TextEditingController();
    final destinationController = TextEditingController();
    final currentMethod = ref.watch(methodProvider);

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
            onMapCreated: (controller) => mapController.value = controller,
            polylines: polylines.value,
          ),
          if (isLoading.value)
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
                      value: loadingRoutesCount.value / 20, // 最大20ルートを基準
                      backgroundColor: Colors.grey[200],
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${AppLocalizations.of(context)!.number_of_routes_being_acquired}: ${loadingRoutesCount.value}',
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
            _showRouteSearchModal(
              context,
              ref,
              mapController,
              polylines,
              originController,
              destinationController,
              isLoading,
              loadingRoutesCount,
              currentMethod,
            );
          },
          backgroundColor: Colors.white.withOpacity(0.8),
          child: const Icon(Icons.south),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Future<void> _showRouteSearchModal(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<GoogleMapController?> mapController,
    ValueNotifier<Set<Polyline>> polylines,
    TextEditingController originController,
    TextEditingController destinationController,
    ValueNotifier<bool> isLoading,
    ValueNotifier<int> loadingRoutesCount,
    String currentMethod,
  ) async {
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
                          controller: originController,
                          decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context)!.departure_point,
                            suffixIcon: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: destinationController,
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
                            isLoading.value = true;
                            loadingRoutesCount.value = 0; // 初期化

                            try {
                              // 始点・終点の入力チェック
                              if (originController.text.isNotEmpty &&
                                  destinationController.text.isNotEmpty) {
                                final originLocation = await routeViewModel
                                    .fetchCoordinatesFromAddress(
                                  originController.text,
                                );
                                final destinationLocation = await routeViewModel
                                    .fetchCoordinatesFromAddress(
                                  destinationController.text,
                                );

                                // カメラ移動
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
                                mapController.value?.animateCamera(
                                  CameraUpdate.newLatLngBounds(bounds, 50),
                                );
                              }

                              // 複数ルートの取得
                              final multipleRoutes =
                                  await routeViewModel.fetchMultipleRoutes(
                                originController.text,
                                destinationController.text,
                                apiKey,
                              );

                              final List<List<double>> elevationsList = [];
                              final Set<Polyline> allPolylines = {};

                              // ルートを描画
                              for (int i = 0; i < multipleRoutes.length; i++) {
                                final route = multipleRoutes[i];
                                final points = routeViewModel.decodePolyline(
                                    route['overview_polyline']['points']);

                                final elevations = await routeViewModel
                                    .fetchElevationsForPolyline(points);

                                elevationsList.add(elevations);

                                final routeColor = Color.lerp(
                                  Colors.lightBlue,
                                  const Color.fromARGB(255, 8, 29, 149),
                                  i / (multipleRoutes.length - 1),
                                )!;

                                allPolylines.add(
                                  Polyline(
                                    polylineId: PolylineId('route_$i'),
                                    points: points,
                                    color: routeColor,
                                    width: 6,
                                  ),
                                );

                                loadingRoutesCount.value = i + 1;
                                polylines.value = allPolylines;
                              }

                              // 最も緩やかなルートを描画
                              final gradientCalculator = GradientCalculator();
                              final leastGradientRoute =
                                  gradientCalculator.findLeastGradientRoute(
                                multipleRoutes,
                                elevationsList,
                                currentMethod,
                              );

                              final leastGradientPoints =
                                  routeViewModel.decodePolyline(
                                leastGradientRoute['overview_polyline']
                                    ['points'],
                              );

                              polylines.value = {
                                Polyline(
                                  polylineId:
                                      const PolylineId('least_gradient_route'),
                                  points: leastGradientPoints,
                                  color: Colors.green.withOpacity(0.7),
                                  width: 12,
                                ),
                              };

                              final leastGradientBounds =
                                  _calculateBounds(leastGradientPoints);
                              mapController.value?.animateCamera(
                                CameraUpdate.newLatLngBounds(
                                    leastGradientBounds, 50),
                              );
                            } catch (error) {
                              print('ルート取得エラー: $error');
                            } finally {
                              isLoading.value = false;
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
}
