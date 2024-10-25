import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/locale_provider.dart';

class SettingsLanguage extends HookConsumerWidget {
  const SettingsLanguage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 現在のロケールを取得
    final currentLocale = ref.watch(localeProvider);

    // 言語変更用の関数
    void changeLanguage(Locale locale) {
      ref.read(localeProvider.notifier).setLocale(locale);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.language),
      ),
      body: SettingsList(
        platform: DevicePlatform.iOS,
        sections: [
          SettingsSection(
            title: const Text(''),
            tiles: <SettingsTile>[
              // 英語設定
              SettingsTile(
                title: const Text('English'),
                trailing: currentLocale.languageCode == 'en'
                    ? const Icon(Icons.done,
                        color: Colors.blue) // 英語選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  changeLanguage(const Locale('en')); // 英語に変更
                },
              ),
              // 日本語設定
              SettingsTile(
                title: const Text('日本語'),
                trailing: currentLocale.languageCode == 'ja'
                    ? const Icon(Icons.done,
                        color: Colors.blue) // 日本語選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  changeLanguage(const Locale('ja')); // 日本語に変更
                },
              ),
              // 韓国語設定
              SettingsTile(
                title: const Text('한국어'),
                trailing: currentLocale.languageCode == 'ko'
                    ? const Icon(Icons.done,
                        color: Colors.blue) // 韓国語選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  changeLanguage(const Locale('ko')); // 韓国語に変更
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
