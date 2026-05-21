import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 下部ナビゲーションバーの選択インデックスを管理するProvider
final selectedIndexProvider = StateProvider<int>((ref) => 2);

// アイテムリストを管理するためのProvider
final dragDropItemsProvider = StateProvider<List<Map<String, dynamic>>>((ref) {
  return [
    {'icon': Icons.cloudy_snowing, 'label': 'rain_cloud_radar'},
    {'icon': Icons.directions_run, 'label': 'marathon_course'},
    {'icon': Icons.monitor_weight, 'label': 'calorie_count'},
  ];
});
