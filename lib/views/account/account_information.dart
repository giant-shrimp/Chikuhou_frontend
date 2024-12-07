import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../viewmodels/settings/account_information_viewmodel.dart';
import '../settings/settings_password.dart';

class AccountInformation extends HookConsumerWidget {
  const AccountInformation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ViewModelのプロバイダーを利用して状態を取得
    final accountInformationViewModel = ref.watch(accountInformationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.account_information),
      ),
      body: SettingsList(
        platform: DevicePlatform.iOS,
        sections: [
          SettingsSection(
            title: const Text(''),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: Text(AppLocalizations.of(context)!.username),
                value: Text(
                    accountInformationViewModel.userName), // ViewModelからデータを取得
              ),
              SettingsTile.navigation(
                title: Text(AppLocalizations.of(context)!.email),
                value: Text(
                    accountInformationViewModel.email), // ViewModelからデータを取得
              ),
              SettingsTile.navigation(
                title: Text(AppLocalizations.of(context)!.phone),
                value: Text(
                    accountInformationViewModel.phone), // ViewModelからデータを取得
                description: const Text(''),
              ),
              SettingsTile.navigation(
                title: Text(AppLocalizations.of(context)!.password),
                onPressed: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPassword(),
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
