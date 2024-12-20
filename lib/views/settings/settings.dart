import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../account/account_information.dart';
import '../../viewmodels/settings/account_information_viewmodel.dart';
import 'settings_language.dart';

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: SettingsList(
        platform: DevicePlatform.iOS,
        sections: [
          SettingsSection(
            title: const Text(''),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: Text(AppLocalizations.of(context)!.language),
                value: Text(AppLocalizations.of(context)!.use_language),
                onPressed: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsLanguage(),
                    ),
                  );
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.account_circle),
                title: Text(AppLocalizations.of(context)!.account_information),
                onPressed: (context) {
                  // AccountInformationViewModelを使ってデータを準備しながら画面遷移
                  final viewModel = ref.read(accountInformationProvider);

                  // ユーザー情報を取得する処理を事前に実行
                  viewModel.fetchUserInformation();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountInformation(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
