import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../settings/settings_password.dart';

class AccountInformation extends HookConsumerWidget {
  const AccountInformation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                value: const Text('John Doe'),
              ),
              SettingsTile.navigation(
                title: Text(AppLocalizations.of(context)!.email),
                value: const Text('johndoe@example.com'),
              ),
              SettingsTile.navigation(
                title: Text(AppLocalizations.of(context)!.phone),
                value: const Text('+123 456 7890'),
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
