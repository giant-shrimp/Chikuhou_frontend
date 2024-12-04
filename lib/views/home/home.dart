import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../viewmodels/map/route_viewmodel.dart';
import '../../viewmodels/map/gradient_calculator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../widgets/common/custom_button.dart';
import '../settings/settings_calculation_method.dart';

void main() async {
  await dotenv.load(fileName: ".env"); // dotenvファイルをロード
  runApp(const ProviderScope(child: MyApp())); // ProviderScopeでラップ
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
    // methodProviderの値を監視してログを出力
    ref.listen<String>(
      methodProvider,
      (previous, next) {
        print('methodProviderが変更されました: $previous -> $next');
      },
    );

    final currentMethod = ref.watch(methodProvider); // 現在のmethodを取得
    final isLoading = useState(false);
    final loadingRoutesCount = useState(0);
    final polylines = useState<Set<Polyline>>({});
    final originController = useTextEditingController();
    final destinationController = useTextEditingController();

    GoogleMapController? _mapController;

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
        padding: const EdgeInsets.only(bottom: 15.0),
        child: FloatingActionButton(
          onPressed: () {
            _showRouteSearchModal(
              context,
              ref,
              currentMethod,
              isLoading,
              loadingRoutesCount,
              polylines,
              _mapController,
              originController,
              destinationController,
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
    String currentMethod,
    ValueNotifier<bool> isLoading,
    ValueNotifier<int> loadingRoutesCount,
    ValueNotifier<Set<Polyline>> polylines,
    GoogleMapController? mapController,
    TextEditingController originController,
    TextEditingController destinationController,
  ) async {
    print('現在のmethodProviderの値: $currentMethod'); // ログ出力

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
                            Navigator.pop(context);
                            isLoading.value = true;
                            loadingRoutesCount.value = 0;

                            try {
                              final multipleRoutes =
                                  await routeViewModel.fetchMultipleRoutes(
                                originController.text,
                                destinationController.text,
                                apiKey,
                              );

                              final List<List<double>> elevationsList = [];
                              final Set<Polyline> allPolylines = {};

                              for (int i = 0; i < multipleRoutes.length; i++) {
                                final route = multipleRoutes[i];
                                final points = routeViewModel.decodePolyline(
                                    route['overview_polyline']['points']);

                                allPolylines.add(
                                  Polyline(
                                    polylineId: PolylineId('route_$i'),
                                    points: points,
                                    color: Colors.blue,
                                    width: 3,
                                  ),
                                );

                                loadingRoutesCount.value = i + 1;
                                polylines.value = allPolylines;
                              }

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
                                          ['points']);

                              polylines.value = {
                                Polyline(
                                  polylineId:
                                      const PolylineId('least_gradient_route'),
                                  points: leastGradientPoints,
                                  color: Colors.green.withOpacity(0.7),
                                  width: 12,
                                ),
                              };

                              if (mapController != null) {
                                final bounds = LatLngBounds(
                                  southwest: leastGradientPoints.first,
                                  northeast: leastGradientPoints.last,
                                );
                                mapController.animateCamera(
                                  CameraUpdate.newLatLngBounds(bounds, 50),
                                );
                              }
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
