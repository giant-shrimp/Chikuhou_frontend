import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/map/route_viewmodel.dart';
import '../../views/map/route_screen.dart'; // 経路検索画面をインポート

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController; // Googleマップコントローラの定義
  Set<Polyline> _polylines = {}; // 経路情報を描画するためのPolylineのセット
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アルケール'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          // Googleマップのウィジェットを配置
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(33.5902, 130.4017), // 初期表示位置（福岡市に設定
              zoom: 14.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller; // コントローラを設定
            },
            polylines: _polylines, // マップ上に描画するポリライン
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.assistant_navigation, size: 50),
              onPressed: () {
                // 経路検索モーダルを表示して、ユーザーからの入力を受け取る
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showRouteSearchModal(BuildContext context) {
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
                          '経路',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // 出発地の入力フィールド
                        TextField(
                          controller: _originController,
                          decoration: const InputDecoration(
                            labelText: 'ここから',
                            suffixIcon: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // 目的地の入力フィールド
                        TextField(
                          controller: _destinationController,
                          decoration: const InputDecoration(
                            labelText: 'ここまで',
                            suffixIcon: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            // 経路を計算するボタン
                            await _calculateRoute();
                            Navigator.pop(context); // モーダルを閉じる
                          },
                          child: const Text('経路を計算'),
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

  Future<void> _calculateRoute() async {
    final viewModel = context.read<RouteViewModel>();

    // 経路検索
    await viewModel.fetchRoute(
      _originController.text,
      _destinationController.text,
    );

    // 経路検索が成功し、結果を取得した場合、マップに経路を描画
    if (viewModel.route != null) {
      final List<LatLng> points = _parsePoints(viewModel.route!.polylinePoints);
      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            points: points,
            color: Colors.blue,
            width: 5,
          ),
        };
      });

      // マップのカメラ位置を経路の中心に移動
      if (_mapController != null && points.isNotEmpty) {
        LatLngBounds bounds = _getLatLngBounds(points);
        _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      }
    }
  }

  // JSONなどで得た経路のポイントデータを解析するメソッド
  List<LatLng> _parsePoints(List<Map<String, double>> points) {
    return points
        .map((point) => LatLng(point['latitude']!, point['longitude']!))
        .toList();
  }

  // ポイントのリストからLatLngBoundsを取得
  LatLngBounds _getLatLngBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (LatLng point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}
