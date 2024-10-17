import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'screens/first.dart';
import 'screens/second.dart';
import 'screens/settings_status.dart';
//import 'screens/third.dart';
import 'screens/menu.dart';
import 'screens/home.dart';
import 'status_provider.dart';

class MyStatefulWidget extends ConsumerStatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  ConsumerState<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends ConsumerState<MyStatefulWidget> {
  static const _screens = [
    MenuScreen(),
    FirstScreen(),
    HomeScreen(),
    SecondScreen(),
    //ThirdScreen()
    SettingsStatus()
  ];

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

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.table_rows_rounded),
            label: AppLocalizations.of(context)!.menu,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.cloudy_snowing),
            label: AppLocalizations.of(context)!.rain_cloud_radar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.volume_up),
            label: AppLocalizations.of(context)!.audio_guidance,
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