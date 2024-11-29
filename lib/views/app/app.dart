import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/screen/sub_extension/audio_guidance.dart';
import '../widgets/screen/sub_extension/calorie_count.dart';
import '../widgets/screen/sub_extension/marathon_course.dart';
import '../widgets/screen/sub_extension/rain_cloud_radar.dart';
import '../widgets/screen/sub_extension/reviews.dart';
import '../widgets/screen/sub_extension/securing_evacuation_routes.dart';
import '../widgets/screen/sub_extension/simple_translation.dart';
import '../widgets/screen/gradient_calculation.dart';
import '../../../views/settings/settings_status.dart';
import '../../../views/home/menu.dart';
import '../../../views/home/home.dart';
import '../../config/providers/status_provider.dart';
import '../widgets/drag_drop/drag_drop.dart';

class MyStatefulWidget extends ConsumerStatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  ConsumerState<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends ConsumerState<MyStatefulWidget> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 現在のステータスを取得
    final currentStatus = ref.watch(statusProvider);

    final statusDetails = getStatusDetails(context, currentStatus);
    IconData statusIcon = statusDetails['icon'];

    // 選択したサブ機能を取得
    final selectedItem = ref.watch(selectedItemProvider);

    // 選択内容に応じた画面を決定
    Widget subScreen;
    final localizedIcon = selectedItem['icon'];
    switch (localizedIcon) {
      case Icons.cloudy_snowing:
        subScreen = const RainCloudRadarScreen();
        break;
      case Icons.volume_up:
        subScreen = const AudioGuidanceScreen();
        break;
      case Icons.g_translate:
        subScreen = const SimpleTranslationScreen();
        break;
      case Icons.forum:
        subScreen = const ReviewsScreen();
        break;
      case Icons.directions_run:
        subScreen = const MarathonCourseScreen();
        break;
      case Icons.add_home_work:
        subScreen = const SecuringEvacuationRoutesScreen();
        break;
      case Icons.monitor_weight:
        subScreen = const CalorieCountScreen();
        break;
      default:
        subScreen = localizedIcon;
    }

    // 動的にスクリーンリストを構築
    final screens = [
      const MenuScreen(),
      subScreen, // 選択されたサブ機能の画面
      const HomeScreen(),
      const GradientCalculationScreen(),
      const SettingsStatus(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.table_rows_rounded),
            label: AppLocalizations.of(context)!.menu,
          ),
          BottomNavigationBarItem(
            icon: Icon(selectedItem['icon']),
            label: AppLocalizations.of(context)!.sub,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.route),
            label: AppLocalizations.of(context)!.gradient,
          ),
          BottomNavigationBarItem(
            icon: Icon(statusIcon),
            label: AppLocalizations.of(context)!.status,
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
