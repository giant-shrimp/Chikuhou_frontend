import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// アイテムリストを管理するためのProvider
final dragDropItemsProvider = StateProvider<List<Map<String, dynamic>>>((ref) {
  return [
    {'icon': Icons.cloudy_snowing, 'label': 'rain_cloud_radar'},
    {'icon': Icons.volume_up, 'label': 'audio_guidance'},
    {'icon': Icons.g_translate, 'label': 'simple_translation'},
    {'icon': Icons.forum, 'label': 'reviews'},
    {'icon': Icons.directions_run, 'label': 'marathon_course'},
    {'icon': Icons.add_home_work, 'label': 'securing_evacuation_routes'},
    {'icon': Icons.monitor_weight, 'label': 'calorie_count'},
  ];
});
