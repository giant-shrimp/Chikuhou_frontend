import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:challecara/viewmodels/map/gradient_calculator.dart';

void main() {
  final calc = GradientCalculator();

  group('calcSegmentGradients', () {
    test('既知の2点間で勾配が正しく計算されること', () {
      // 赤道上、東に経度 0.001 度 ≒ 111.32m。高度差 +10m → 勾配 ≈ 8.99%
      final points = const [LatLng(0, 0), LatLng(0, 0.001)];
      final elevations = [0.0, 10.0];
      final gradients = calc.calcSegmentGradients(points, elevations);
      expect(gradients.length, 1);
      expect(gradients.first, closeTo(8.99, 0.3));
    });

    test('下り勾配は負の値になること', () {
      final points = const [LatLng(0, 0), LatLng(0, 0.001)];
      final elevations = [10.0, 0.0];
      final gradients = calc.calcSegmentGradients(points, elevations);
      expect(gradients.first, lessThan(0));
    });

    test('短い方の長さに合わせて処理されること', () {
      final points = const [
        LatLng(0, 0),
        LatLng(0, 0.001),
        LatLng(0, 0.002),
      ];
      final elevations = [0.0, 5.0];
      final gradients = calc.calcSegmentGradients(points, elevations);
      // 短い方は elevations(2) なのでペア数は 1
      expect(gradients.length, 1);
    });

    test('要素が1点以下なら空リストを返すこと', () {
      expect(calc.calcSegmentGradients(const [LatLng(0, 0)], [0]), isEmpty);
      expect(calc.calcSegmentGradients(const [], const []), isEmpty);
    });
  });

  group('scoreLeastGradient', () {
    test('急坂ルートより緩坂ルートのスコアが低いこと', () {
      final gentle = [0.5, 1.0, 0.5, 1.0];
      final steep = [5.0, 8.0, 6.0, 7.0];
      expect(
        calc.scoreLeastGradient(gentle, 1000.0),
        lessThan(calc.scoreLeastGradient(steep, 1000.0)),
      );
    });

    test('下り(負値)はスコアに加算されないこと', () {
      final allDownhill = [-5.0, -10.0, -3.0];
      expect(calc.scoreLeastGradient(allDownhill, 1000.0), 0.0);
    });
  });

  group('scoreFlatFavorite', () {
    test('最大勾配が小さいルートを選ぶこと', () {
      // a: 最大絶対値 = 3、b: 最大絶対値 = 10
      final a = [1.0, -2.0, 3.0, -1.0];
      final b = [1.0, -10.0, 2.0, 0.0];
      expect(
        calc.scoreFlatFavorite(a, 1000.0),
        lessThan(calc.scoreFlatFavorite(b, 1000.0)),
      );
    });

    test('全要素0なら0を返すこと', () {
      expect(calc.scoreFlatFavorite([0.0, 0.0, 0.0], 1000.0), 0.0);
    });
  });

  group('scoreShortest', () {
    test('距離が短いルートを選ぶこと', () {
      expect(
        calc.scoreShortest(const [1.0, 2.0], 500.0),
        lessThan(calc.scoreShortest(const [1.0, 2.0], 2000.0)),
      );
    });
  });

  group('scoreByStatus', () {
    test('runner では上り累積が大きいほどスコアが低くなること（負値化）', () {
      final mildClimb = [0.5, 0.5];
      final steepClimb = [5.0, 5.0];
      expect(
        calc.scoreByStatus('runner', steepClimb, 1000.0),
        lessThan(calc.scoreByStatus('runner', mildClimb, 1000.0)),
      );
    });

    test('senior は scoreFlatFavorite と等価であること', () {
      final g = [1.0, -3.0, 2.0];
      expect(
        calc.scoreByStatus('senior', g, 1000.0),
        calc.scoreFlatFavorite(g, 1000.0),
      );
    });

    test('traveler は scoreShortest と等価であること', () {
      expect(
        calc.scoreByStatus('traveler', const [1.0, 2.0], 500.0),
        500.0,
      );
    });

    test('walker (デフォルト) は scoreLeastGradient と等価であること', () {
      final g = [2.0, 3.0, -1.0];
      expect(
        calc.scoreByStatus('walker', g, 1000.0),
        calc.scoreLeastGradient(g, 1000.0),
      );
    });
  });
}
