import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../config/providers/status_provider.dart';
import '../../core/utils/dialog_helpers.dart';
import '../settings/settings_sub.dart';
import '../auth/sign_in.dart';
import '../settings/settings.dart';
import '../settings/settings_status.dart';

class MenuScreen extends HookConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 現在のステータスを取得
    final currentStatus = ref.watch(statusProvider);

    final statusDetails = getStatusDetails(context, currentStatus);
    IconData statusIcon = statusDetails['icon'];
    String statusText = statusDetails['text'];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.menu),
        automaticallyImplyLeading: false,
      ),
      body: SettingsList(
        platform: DevicePlatform.iOS,
        sections: [
          SettingsSection(
            title: const Text(''),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.settings),
                title: Text(AppLocalizations.of(context)!.settings),
                onPressed: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
              SettingsTile(
                leading: Icon(statusIcon),
                title: Text(AppLocalizations.of(context)!.status),
                value: Text(statusText),
                description: const Text(''),
                // onPressed: (context) {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const SettingsStatus(),
                //     ),
                //   );
                // },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.build),
                title: Text(AppLocalizations.of(context)!.sub_extension),
                description: const Text(''),
                onPressed: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsSub(),
                    ),
                  );
                },
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
                leading: const Icon(Icons.swap_horizontal_circle_outlined),
                title: Text(AppLocalizations.of(context)!.swap),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.logout_rounded),
                title: Text(
                  AppLocalizations.of(context)!.sign_out,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: (context) {
                  // ログアウト確認ダイアログを表示
                  showDialogs(
                    context: context,
                    title: AppLocalizations.of(context)!.sign_out_confirmation,
                    content: AppLocalizations.of(context)!.are_you_sure_sign_out,
                    cancelText: AppLocalizations.of(context)!.cancel,
                    confirmText: AppLocalizations.of(context)!.sign_out,
                    onConfirm: () {
                      // ログアウト処理
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      );
                    },
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
