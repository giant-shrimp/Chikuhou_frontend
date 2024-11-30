import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// 現在のステータスを管理するためのProvider
final methodProvider = StateProvider<String>((ref) => 'method_1'); //初期値:単純勾配計算
// ステータス変更用の関数
class SettingsCalculationMethod extends HookConsumerWidget {
  const SettingsCalculationMethod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMethod = ref.watch(methodProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.gradient_calculation),
        automaticallyImplyLeading: false,
      ),
      body: SettingsList(
        platform: DevicePlatform.iOS,
        sections: [
          SettingsSection(
            title: const Text(''),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(Icons.looks_one_outlined),
                title: Text(AppLocalizations.of(context)!.simple_gradient_calculation),
                description: const Text(''),
                trailing: currentMethod == 'method_1'
                    ? const Icon(Icons.done, color: Colors.blue) // method_1選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  ref.read(methodProvider.notifier).state = 'method_1';  // method_1に変更
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.looks_two_outlined),
                title: Text(AppLocalizations.of(context)!.quadrature_by_pieces),
                description: const Text(''),
                trailing: currentMethod == 'method_2'
                    ? const Icon(Icons.done, color: Colors.blue) // method_2選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  ref.read(methodProvider.notifier).state = 'method_2';  // method_2に変更
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.looks_3_outlined),
                title: Text(AppLocalizations.of(context)!.linear_calculations),
                description: const Text(''),
                trailing: currentMethod == 'method_3'
                    ? const Icon(Icons.done, color: Colors.blue) // method_3選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  ref.read(methodProvider.notifier).state = 'method_3';  // method_3に変更
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.looks_4_outlined),
                title: Text(AppLocalizations.of(context)!.vector_product),
                description: const Text(''),
                trailing: currentMethod == 'method_4'
                    ? const Icon(Icons.done, color: Colors.blue) // method_4選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  ref.read(methodProvider.notifier).state = 'method_4';  // method_4に変更
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.looks_5_outlined),
                title: Text(AppLocalizations.of(context)!.taylor_expansion),
                description: const Text(''),
                trailing: currentMethod == 'method_5'
                    ? const Icon(Icons.done, color: Colors.blue) // method_5選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  ref.read(methodProvider.notifier).state = 'method_5';  // method_5に変更
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.looks_6_outlined),
                title: Text(AppLocalizations.of(context)!.simpson_act),
                description: const Text(''),
                trailing: currentMethod == 'method_6'
                    ? const Icon(Icons.done, color: Colors.blue) // method_6選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  ref.read(methodProvider.notifier).state = 'method_6';  // method_6に変更
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
