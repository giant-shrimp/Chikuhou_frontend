import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'settings.dart';

class MenuScreen extends HookConsumerWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('メニュー'),
        ),
      body:  SettingsList(
        platform: DevicePlatform.iOS,
        sections: [
          SettingsSection(
            title: const Text('セクション'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.settings),
                title: const Text('設定'),
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
                leading: const Icon(Icons.directions_walk_sharp),
                title: const Text('ステータス設定'),
                value: const Text('ウォーカー'),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.g_translate),
                title: const Text('簡単翻訳'),
                description: const Text(''),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.quiz_rounded),
                title: const Text('よくある質問'),
              ),
              SettingsTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text('アプリのバージョン'),
                value: const Text('1.0.0'),
                description: const Text(''),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.logout_rounded),
                title: const Text(
                    'ログアウト',
                    style: TextStyle(
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