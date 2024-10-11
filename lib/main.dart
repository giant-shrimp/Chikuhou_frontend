import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;
import 'package:http/http.dart' as http;
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late GoogleMapController _mapController;
  final Set<Polyline> _polylines = {};
  final Map<String, Marker> _markers = {};
  final LatLng _initialPosition = LatLng(33.5903, 130.4017); // 福岡

  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();

  final List<LatLng> _routePoints = [];

  double? _highestElevation;
  double? _lowestElevation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Google Maps Directions'),
            if (_highestElevation != null && _lowestElevation != null)
              Text(
                '最高標高: ${_highestElevation!.toStringAsFixed(2)} m, 最低標高: ${_lowestElevation!.toStringAsFixed(2)} m',
                style: const TextStyle(fontSize: 14),
              )
            else
              const Text(
                '最高標高と最低標高を取得中...',
                style: TextStyle(fontSize: 14),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: startController,
                    decoration: const InputDecoration(hintText: '出発地点'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: endController,
                    decoration: const InputDecoration(hintText: '目的地'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _onSearchPressed,
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 14.0,
              ),
              markers: _markers.values.toSet(),
              polylines: _polylines,
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }

  void _onSearchPressed() async {
    final start = startController.text;
    final end = endController.text;
    if (start.isEmpty || end.isEmpty) {
      return; // 空の入力を無視
    }
    await _getDirections(start, end);
  }

  Future<void> _getDirections(String origin, String destination) async {
    const apiKey = 'AIzaSyApsx2TXanoD2FbmzLcCfqajqlEPA__B50'; // 適切なAPIキーを設定
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=walking&alternatives=true&key=$apiKey';

    print('Requesting directions from: $url');

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Response: ${response.body}');

        if (data['routes'].isNotEmpty) {
          final points =
              _decodePolyline(data['routes'][0]['overview_polyline']['points']);

          setState(() {
            _routePoints.clear();
            _routePoints.addAll(points);
            _polylines.clear();
            _polylines.add(Polyline(
              polylineId: const PolylineId('directions'),
              points: points,
              color: Colors.blue,
              width: 5,
            ));
          });

          await _getElevationData(points);

          _mapController.animateCamera(
            CameraUpdate.newLatLngBounds(
              _getBounds(points),
              50,
            ),
          );
        }
      } else {
        print('Failed to load directions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching directions: $e');
    }
  }

// Google Elevation APIを使用して最高標高と最低標高を取得
  Future<void> _getElevationData(List<LatLng> points) async {
    const apiKey = 'AIzaSyApsx2TXanoD2FbmzLcCfqajqlEPA__B50'; // APIキーを適宜設定

    // 各緯度・経度のリストを「locations」パラメータに変換
    final locations =
        points.map((point) => '${point.latitude},${point.longitude}').join('|');
    final elevationUrl =
        'https://maps.googleapis.com/maps/api/elevation/json?locations=$locations&key=$apiKey';

    try {
      print('Requesting elevation data from: $elevationUrl'); // リクエストURLをログに出力

      final response = await http.get(Uri.parse(elevationUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Elevation API response: ${response.body}'); // レスポンスをログに出力

        if (data['results'].isNotEmpty) {
          // 標高データを取得してdoubleに変換する
          final elevations = data['results'].map<double>((result) {
            return (result['elevation'] as num).toDouble(); // double型にキャスト
          }).toList();

          // reduceメソッドを使用して最高標高と最低標高を取得
          setState(() {
            _highestElevation =
                elevations.reduce((a, b) => a > b ? a : b); // 最高標高
            _lowestElevation =
                elevations.reduce((a, b) => a < b ? a : b); // 最低標高
          });
        }
      } else {
        print('Failed to load elevation data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching elevation data: $e');
    }
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    const earthRadius = 6371;
    final dLat = _degreesToRadians(point2.latitude - point1.latitude);
    final dLng = _degreesToRadians(point2.longitude - point1.longitude);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(point1.latitude)) *
            cos(_degreesToRadians(point2.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  List<LatLng> _decodePolyline(String encoded) {
    var points = <LatLng>[];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      var dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      var dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  LatLngBounds _getBounds(List<LatLng> points) {
    final southWestLat =
        points.map((p) => p.latitude).reduce((a, b) => a < b ? a : b);
    final southWestLng =
        points.map((p) => p.longitude).reduce((a, b) => a < b ? a : b);
    final northEastLat =
        points.map((p) => p.latitude).reduce((a, b) => a > b ? a : b);
    final northEastLng =
        points.map((p) => p.longitude).reduce((a, b) => a > b ? a : b);

    return LatLngBounds(
      southwest: LatLng(southWestLat, southWestLng),
      northeast: LatLng(northEastLat, northEastLng),
    );
  }
}
