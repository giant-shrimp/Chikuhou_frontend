import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../viewmodels/map/route_viewmodel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      '取得中のルート数: $_loadingRoutesCount / 20',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.assistant_navigation, size: 50),
              onPressed: () {
                _showRouteSearchModal(context);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showRouteSearchModal(context);
        },
        child: const Icon(Icons.south),
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
                        const Text(
                          'ルート検索',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _originController,
                          decoration: const InputDecoration(
                            labelText: '出発地',
                            suffixIcon: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _destinationController,
                          decoration: const InputDecoration(
                            labelText: '目的地',
                            suffixIcon: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            setState(() {
                              _isLoading = true;
                              _loadingRoutesCount = 0; // 初期化
                            });

                            try {
                              final multipleRoutes =
                                  await routeViewModel.fetchMultipleRoutes(
                                _originController.text,
                                _destinationController.text,
                                apiKey,
                                maxRoutes: 10,
                              );

                              final Set<Polyline> polylines = {};
                              for (int i = 0; i < multipleRoutes.length; i++) {
                                final route = multipleRoutes[i];
                                final points = routeViewModel.decodePolyline(
                                  route['overview_polyline']['points'],
                                );

                                polylines.add(
                                  Polyline(
                                    polylineId: PolylineId('route_$i'),
                                    points: points,
                                    color: Colors
                                        .primaries[i % Colors.primaries.length]
                                        .withOpacity(0.7),
                                    width: 5,
                                  ),
                                );

                                final elevations = await routeViewModel
                                    .fetchElevationsForPolyline(points);

                                print('--- Route $i ---');
                                print(
                                    'Distance: ${route['legs'][0]['distance']['text']}');
                                print(
                                    'Duration: ${route['legs'][0]['duration']['text']}');
                                print(
                                    'Polyline: ${route['overview_polyline']['points']}');
                                print('Elevations: $elevations');

                                // ローディング中のルート数を更新
                                setState(() {
                                  _loadingRoutesCount = i + 1;
                                });
                              }

                              _setPolylines(polylines);
                            } catch (error) {
                              print('ルート取得エラー: $error');
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          child: const Text('ルート検索'),
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
