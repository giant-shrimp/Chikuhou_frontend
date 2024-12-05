import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

class GradientCalculator {
  /// 勾配を計算し、最も緩いルートを返す
  Map<String, dynamic> findLeastGradientRoute(List<Map<String, dynamic>> routes,
      List<List<double>> elevationsList, method) {
    if (routes.isEmpty || elevationsList.isEmpty) {
      throw Exception("ルートまたは高度データがありません。");
    }

    switch (method) {
      case "method_1":
        return _gradientCalcMethod_1(routes, elevationsList);
      case "method_2":
        return _gradientCalcMethod_2(routes, elevationsList);
      case "method_3":
        return _gradientCalcMethod_3(routes, elevationsList);
      case "method_4":
        return _gradientCalcMethod_4(routes, elevationsList);
      case "method_5":
        return _gradientCalcMethod_5(routes, elevationsList);
      case "method_6":
        return _gradientCalcMethod_6(routes, elevationsList);
      case "method_7":
        return _gradientCalcMethod_7(routes, elevationsList);
      case "method_8":
        return _gradientCalcMethod_8(routes, elevationsList);
      case "method_9":
        return _gradientCalcMethod_9(routes, elevationsList);
      default:
        throw Exception("未知の計算方法: $method");
    }
  }

  // 計算方法1:単純勾配計算
  Map<String, dynamic> _gradientCalcMethod_1(
      List<Map<String, dynamic>> routes, List<List<double>> elevationsList) {
    double minGradientSum = double.infinity;
    Map<String, dynamic>? leastGradientRoute;

    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      final elevations = elevationsList[i];
      final polyline = decodePolyline(route['overview_polyline']['points']);

      double totalGradient = 0.0;
      const double distance = 50.0; // 50m間隔

      for (int j = 0;
          j < polyline.length - 1 && j < elevations.length - 1;
          j++) {
        final elevationDiff = elevations[j + 1] - elevations[j];
        if (elevationDiff != 0) {
          totalGradient += (elevationDiff / distance * 100).abs();
        }
      }

      if (totalGradient < minGradientSum) {
        minGradientSum = totalGradient;
        leastGradientRoute = route;
      }
    }

    if (leastGradientRoute == null) {
      throw Exception("最適なルートが見つかりませんでした。");
    }

    return leastGradientRoute;
  }

  /// 計算方法2: 区分求積法
  Map<String, dynamic> _gradientCalcMethod_2(
    List<Map<String, dynamic>> routes,
    List<List<double>> elevationsList,
  ) {
    Map<String, dynamic>? leastGradientRoute;
    double minGradientSum = double.infinity;

    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      final elevations = elevationsList[i];
      final polyline = decodePolyline(route['overview_polyline']['points']);

      double totalGradient = 0.0;

      // 各区間の勾配を計算し、面積として加算
      for (int j = 0;
          j < polyline.length - 1 && j < elevations.length - 1;
          j++) {
        // 区間の距離
        const double distance = 50.0; // 50m間隔

        // 高度差
        final double elevationDiff = elevations[j + 1] - elevations[j];

        // 勾配の面積 (区間長 × 勾配)
        totalGradient += distance * elevationDiff.abs();
      }

      // 最小の勾配合計を持つルートを更新
      if (totalGradient < minGradientSum) {
        minGradientSum = totalGradient;
        leastGradientRoute = route;
      }
    }

    if (leastGradientRoute == null) {
      throw Exception("最適なルートが見つかりませんでした。");
    }

    return leastGradientRoute;
  }

  /// 計算方法3: 線形計算
  Map<String, dynamic> _gradientCalcMethod_3(
    List<Map<String, dynamic>> routes,
    List<List<double>> elevationsList,
  ) {
    Map<String, dynamic>? leastGradientRoute;
    double minAverageGradient = double.infinity;

    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      final elevations = elevationsList[i];
      final polyline = decodePolyline(route['overview_polyline']['points']);

      double totalGradient = 0.0;
      int segmentCount = 0;

      for (int j = 0;
          j < polyline.length - 1 && j < elevations.length - 1;
          j++) {
        final LatLng point1 = polyline[j];
        final LatLng point2 = polyline[j + 1];

        // x, y, z座標を取得
        final double x1 = point1.latitude;
        final double y1 = point1.longitude;
        final double z1 = elevations[j];

        final double x2 = point2.latitude;
        final double y2 = point2.longitude;
        final double z2 = elevations[j + 1];

        // 勾配の計算: m = (z2 - z1) / sqrt((x2 - x1)^2 + (y2 - y1)^2)
        final double horizontalDistance = sqrt(
          pow(x2 - x1, 2) + pow(y2 - y1, 2),
        );
        if (horizontalDistance == 0) continue; // 0除算を防ぐ

        final double gradient = (z2 - z1) / horizontalDistance;
        totalGradient += gradient.abs(); // 絶対値を加算
        segmentCount++;
      }

      // 平均勾配を計算
      final double averageGradient =
          segmentCount > 0 ? totalGradient / segmentCount : double.infinity;

      // 最小の平均勾配を持つルートを更新
      if (averageGradient < minAverageGradient) {
        minAverageGradient = averageGradient;
        leastGradientRoute = route;
      }
    }

    if (leastGradientRoute == null) {
      throw Exception("最適なルートが見つかりませんでした。");
    }

    return leastGradientRoute;
  }

  /// 計算方法4: ベクトル積
  Map<String, dynamic> _gradientCalcMethod_4(
    List<Map<String, dynamic>> routes,
    List<List<double>> elevationsList,
  ) {
    Map<String, dynamic>? leastGradientRoute;
    double minAverageTheta = double.infinity;

    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      final elevations = elevationsList[i];
      final polyline = decodePolyline(route['overview_polyline']['points']);

      double totalTheta = 0.0;
      int segmentCount = 0;

      for (int j = 0;
          j < polyline.length - 1 && j < elevations.length - 1;
          j++) {
        final LatLng point1 = polyline[j];
        final LatLng point2 = polyline[j + 1];

        // 1. 点1と点2の座標を取得
        final double x1 = point1.latitude;
        final double y1 = point1.longitude;
        final double z1 = elevations[j];

        final double x2 = point2.latitude;
        final double y2 = point2.longitude;
        final double z2 = elevations[j + 1];

        // 2. ベクトルAとBを定義
        final double ax = x2 - x1;
        final double ay = y2 - y1;
        final double az = z2 - z1;

        final double bx = x2 - x1;
        final double by = y2 - y1;
        final double bz = 0.0; // 水平方向

        // 3. ベクトルの内積 |A・B|
        final double dotProduct = (ax * bx) + (ay * by) + (az * bz);

        // 4. ベクトルの大きさ |A| と |B|
        final double magnitudeA = sqrt(pow(ax, 2) + pow(ay, 2) + pow(az, 2));
        final double magnitudeB = sqrt(pow(bx, 2) + pow(by, 2));

        if (magnitudeA == 0 || magnitudeB == 0) continue; // 0除算を防ぐ

        // 5. 勾配角 θ を計算 (θ = arctan(|A・B| / (|A||B|)))
        final double theta = atan(dotProduct / (magnitudeA * magnitudeB));
        totalTheta += theta.abs();
        segmentCount++;
      }

      // 平均勾配角を計算
      final double averageTheta =
          segmentCount > 0 ? totalTheta / segmentCount : double.infinity;

      // 最小の平均勾配角を持つルートを更新
      if (averageTheta < minAverageTheta) {
        minAverageTheta = averageTheta;
        leastGradientRoute = route;
      }
    }

    if (leastGradientRoute == null) {
      throw Exception("最適なルートが見つかりませんでした。");
    }

    return leastGradientRoute;
  }

  /// 計算方法5: テイラー展開
  Map<String, dynamic> _gradientCalcMethod_5(
    List<Map<String, dynamic>> routes,
    List<List<double>> elevationsList,
  ) {
    const double earthRadius = 6371000.0; // 地球の半径 (メートル)
    Map<String, dynamic>? leastGradientRoute;
    double minAverageTheta = double.infinity;

    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      final elevations = elevationsList[i];
      final polyline = decodePolyline(route['overview_polyline']['points']);

      double totalTheta = 0.0;
      int segmentCount = 0;

      for (int j = 0;
          j < polyline.length - 1 && j < elevations.length - 1;
          j++) {
        final LatLng point1 = polyline[j];
        final LatLng point2 = polyline[j + 1];

        // 1. 緯度・経度をラジアンに変換
        final double lat1 = point1.latitude * pi / 180.0;
        final double lon1 = point1.longitude * pi / 180.0;
        final double lat2 = point2.latitude * pi / 180.0;
        final double lon2 = point2.longitude * pi / 180.0;

        // 2. ハヴァーサイン式で水平距離を計算
        final double dLat = lat2 - lat1;
        final double dLon = lon2 - lon1;

        final double a = pow(sin(dLat / 2), 2) +
            cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
        final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
        final double horizontalDistance = earthRadius * c;

        // 3. 高さ差を計算
        final double elevationDiff = elevations[j + 1] - elevations[j];

        // 4. 勾配角を計算 (θ = arctan(Δh / d))
        if (horizontalDistance != 0) {
          final double theta = atan(elevationDiff / horizontalDistance);
          totalTheta += theta.abs(); // 絶対値を取る
          segmentCount++;
        }
      }

      // 平均勾配角を計算
      final double averageTheta =
          segmentCount > 0 ? totalTheta / segmentCount : double.infinity;

      // 最小の平均勾配角を持つルートを更新
      if (averageTheta < minAverageTheta) {
        minAverageTheta = averageTheta;
        leastGradientRoute = route;
      }
    }

    if (leastGradientRoute == null) {
      throw Exception("最適なルートが見つかりませんでした。");
    }

    return leastGradientRoute;
  }

  /// 計算方法6: シンプソン法
  Map<String, dynamic> _gradientCalcMethod_6(
    List<Map<String, dynamic>> routes,
    List<List<double>> elevationsList,
  ) {
    Map<String, dynamic>? leastGradientRoute;
    double minGradientSum = double.infinity;

    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      final elevations = elevationsList[i];
      final polyline = decodePolyline(route['overview_polyline']['points']);

      // シンプソン法の積分結果を計算
      final double gradientSum =
          _calculateSimpsonGradient(polyline, elevations);

      // 勾配の合計が最小のルートを更新
      if (gradientSum < minGradientSum) {
        minGradientSum = gradientSum;
        leastGradientRoute = route;
      }
    }

    if (leastGradientRoute == null) {
      throw Exception("最適なルートが見つかりませんでした。");
    }

    return leastGradientRoute;
  }

  /// 計算方法7: フーリエ変換
  Map<String, dynamic> _gradientCalcMethod_7(
    List<Map<String, dynamic>> routes,
    List<List<double>> elevationsList,
  ) {
    Map<String, dynamic>? leastGradientRoute;
    double minSharpness = double.infinity;

    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      final elevations = elevationsList[i];

      // フーリエ変換を適用して急激な勾配を解析
      final double sharpness = _analyzeGradientUsingFourier(elevations);

      // 急激な変化が最も小さいルートを選択
      if (sharpness < minSharpness) {
        minSharpness = sharpness;
        leastGradientRoute = route;
      }
    }

    if (leastGradientRoute == null) {
      throw Exception("最適なルートが見つかりませんでした。");
    }

    return leastGradientRoute;
  }

  ///  計算方法8: ヘルツホルム分解
  Map<String, dynamic> _gradientCalcMethod_8(
    List<Map<String, dynamic>> routes,
    List<List<double>> elevationsList,
  ) {
    Map<String, dynamic>? leastGradientRoute;

    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      final elevations = elevationsList[i];
      final polyline = decodePolyline(route['overview_polyline']['points']);
    }

    // null チェックをループ外で行う
    if (leastGradientRoute == null) {
      throw Exception("最適なルートが見つかりませんでした。");
    }

    return leastGradientRoute;
  }

  ///  計算方法9: リーマン計量
  Map<String, dynamic> _gradientCalcMethod_9(
    List<Map<String, dynamic>> routes,
    List<List<double>> elevationsList,
  ) {
    Map<String, dynamic>? leastGradientRoute;

    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      final elevations = elevationsList[i];
      final polyline = decodePolyline(route['overview_polyline']['points']);
    }

    // null チェックをループ外で行う
    if (leastGradientRoute == null) {
      throw Exception("最適なルートが見つかりませませんでした。");
    }

    return leastGradientRoute;
  }

  /// Polyline をデコード (Google Maps API Polyline)
  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  /// シンプソン法による勾配の近似計算
  double _calculateSimpsonGradient(
      List<LatLng> polyline, List<double> elevations) {
    if (polyline.length < 3 || elevations.length < 3) {
      throw Exception("ポイントが不足しています。");
    }

    int n = polyline.length - 1; // セグメント数 (偶数が必要)
    if (n % 2 != 0) {
      throw Exception("シンプソン法には偶数のセグメントが必要です。");
    } else {}

    // 区間幅 h
    final double h = _calculateTotalDistance(polyline) / n;

    // 勾配関数 f(x) の計算
    double f(int i) {
      final double horizontalDistance =
          _calculateDistance(polyline[i], polyline[i + 1]);
      final double elevationDiff = elevations[i + 1] - elevations[i];
      return (elevationDiff / horizontalDistance).abs();
    }

    // シンプソン法による積分
    double result = f(0) + f(n);
    for (int i = 1; i < n; i++) {
      if (i % 2 == 0) {
        result += 2 * f(i);
      } else {
        result += 4 * f(i);
      }
    }
    result *= h / 3.0;

    return result;
  }

  /// ポリライン全体の距離を計算
  double _calculateTotalDistance(List<LatLng> polyline) {
    double totalDistance = 0.0;
    for (int i = 0; i < polyline.length - 1; i++) {
      totalDistance += _calculateDistance(polyline[i], polyline[i + 1]);
    }
    return totalDistance;
  }

  /// 2点間の直線距離を計算
  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000; // メートル
    final double dLat = _degreesToRadians(end.latitude - start.latitude);
    final double dLng = _degreesToRadians(end.longitude - start.longitude);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(start.latitude)) *
            cos(_degreesToRadians(end.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  /// フーリエ変換を用いた勾配解析
  double _analyzeGradientUsingFourier(List<double> elevations) {
    // 離散フーリエ変換 (FFT) を適用
    final List<Complex> frequencyDomain = _fft(elevations);

    // 高周波数成分の強度を計算
    double highFrequencyEnergy = 0.0;
    for (int i = frequencyDomain.length ~/ 4;
        i < frequencyDomain.length ~/ 2;
        i++) {
      highFrequencyEnergy += frequencyDomain[i].magnitude;
    }

    return highFrequencyEnergy;
  }

  List<Complex> _fft(List<double> signal) {
    int N = signal.length;

    // 基底ケース: 信号長が1の場合
    if (N == 1) {
      return [Complex(signal[0], 0)];
    }

    // 信号長が2のべき乗でなければ例外をスロー
    if (N % 2 != 0) {
      throw Exception("信号長は2のべき乗である必要があります。");
    }

    // 偶数インデックスの要素と奇数インデックスの要素を分割
    final List<double> evenSignal = List.generate(N ~/ 2, (i) => signal[i * 2]);
    final List<double> oddSignal =
        List.generate(N ~/ 2, (i) => signal[i * 2 + 1]);

    // 再帰的に FFT を適用
    final List<Complex> even = _fft(evenSignal);
    final List<Complex> odd = _fft(oddSignal);

    // FFT 計算の合成
    List<Complex> result = List.filled(N, Complex(0, 0), growable: false);
    for (int k = 0; k < N ~/ 2; k++) {
      // Twiddle factor: e^(-2πik/N)
      final Complex twiddleFactor = Complex.polar(1, -2 * pi * k / N);
      final Complex t = twiddleFactor * odd[k];
      result[k] = even[k] + t;
      result[k + N ~/ 2] = even[k] - t;
    }

    return result;
  }
}

class Complex {
  final double real;
  final double imaginary;

  Complex(this.real, this.imaginary);

  // 加算
  Complex operator +(Complex other) =>
      Complex(real + other.real, imaginary + other.imaginary);

  // 減算
  Complex operator -(Complex other) =>
      Complex(real - other.real, imaginary - other.imaginary);

  // 乗算
  Complex operator *(Complex other) => Complex(
        real * other.real - imaginary * other.imaginary,
        real * other.imaginary + imaginary * other.real,
      );

  // スカラー乗算
  Complex operator ^(double scalar) =>
      Complex(real * scalar, imaginary * scalar);

  // 極形式からの生成
  static Complex polar(double magnitude, double angle) =>
      Complex(magnitude * cos(angle), magnitude * sin(angle));

  // 大きさ（絶対値）
  double get magnitude => sqrt(real * real + imaginary * imaginary);

  @override
  String toString() => "($real + ${imaginary}i)";
}
