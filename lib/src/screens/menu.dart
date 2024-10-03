import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'drag_drop.dart';
import 'settings.dart';
import 'settings_status.dart';

class MenuScreen extends HookConsumerWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 現在のステータスを取得
    final currentStatus = ref.watch(statusProvider);

    // ステータスに応じてアイコンを決定
    IconData statusIcon;
    String statusText;
    if (currentStatus == 'runner') {
      statusIcon = Icons.directions_run_sharp;
      statusText = AppLocalizations.of(context)!.runner;
    } else if (currentStatus == 'senior') {
      statusIcon = Icons.assist_walker_sharp;
      statusText = AppLocalizations.of(context)!.senior;
    } else {
      statusIcon = Icons.directions_walk_sharp;
      statusText = AppLocalizations.of(context)!.walker;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.menu),
        ),
      body:  SettingsList(
        platform: DevicePlatform.iOS,
        sections: [
          SettingsSection(
            title: const Text(''),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.settings),
                title: Text(AppLocalizations.of(context)!.settings),
                onPressed: (context){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                      ),
                  );
                },
              ),
              SettingsTile.navigation(
                leading: Icon(statusIcon),
                title: Text(AppLocalizations.of(context)!.status_settings),
                value: Text(statusText),
                description: const Text(''),
                onPressed: (context){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsStatus(),
                    ),
                  );
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.g_translate),
                title: Text(AppLocalizations.of(context)!.simple_translation),
                description: const Text(''),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.quiz_rounded),
                title: Text(AppLocalizations.of(context)!.faq),
              ),
              SettingsTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: Text(AppLocalizations.of(context)!.app_version),
                value: const Text('1.0.0'),
                description: const Text(''),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.build),
                title: Text(AppLocalizations.of(context)!.sub_extension),
                description: const Text(''),
                onPressed: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DragDropScreen(),
                    ),
                  );
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.swap_horizontal_circle_outlined),
                title: Text(AppLocalizations.of(context)!.swap),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.logout_rounded),
                title: Text(
                  AppLocalizations.of(context)!.logout,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}