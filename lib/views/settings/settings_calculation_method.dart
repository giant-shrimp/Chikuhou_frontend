import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/common/custom_calculation_modal.dart';

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
                  showCustomModal(
                    context,
                    ref,
                    title: AppLocalizations.of(context)!.simple_gradient_calculation,
                    icon: Icons.looks_one_outlined,
                    formulaDescription: 'これは数式の説明です。',
                    overview: '概要の説明',
                    compatibleTypes: 'ここに相性の良いタイプを記載してください。',
                    advantages: 'ここにメリットを記載してください。',
                    disadvantages: 'ここにデメリットを記載してください。',
                    methodKey: 'method_1',
                  );// カスタムモーダル表示
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
                  showCustomModal(
                    context,
                    ref,
                    title: AppLocalizations.of(context)!.quadrature_by_pieces,
                    icon: Icons.looks_two_outlined,
                    formulaDescription: 'これは数式の説明です。',
                    overview: '概要の説明',
                    compatibleTypes: 'ここに相性の良いタイプを記載してください。',
                    advantages: 'ここにメリットを記載してください。',
                    disadvantages: 'ここにデメリットを記載してください。',
                    methodKey: 'method_2',
                  );// カスタムモーダル表示
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
                  showCustomModal(
                    context,
                    ref,
                    title: AppLocalizations.of(context)!.linear_calculations,
                    icon: Icons.looks_3_outlined,
                    formulaDescription: 'これは数式の説明です。',
                    overview: '概要の説明',
                    compatibleTypes: 'ここに相性の良いタイプを記載してください。',
                    advantages: 'ここにメリットを記載してください。',
                    disadvantages: 'ここにデメリットを記載してください。',
                    methodKey: 'method_3',
                  );// カスタムモーダル表示
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
                  showCustomModal(
                    context,
                    ref,
                    title: AppLocalizations.of(context)!.vector_product,
                    icon: Icons.looks_4_outlined,
                    formulaDescription: 'これは数式の説明です。',
                    overview: '概要の説明',
                    compatibleTypes: 'ここに相性の良いタイプを記載してください。',
                    advantages: 'ここにメリットを記載してください。',
                    disadvantages: 'ここにデメリットを記載してください。',
                    methodKey: 'method_4',
                  );// カスタムモーダル表示
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
                  showCustomModal(
                    context,
                    ref,
                    title: AppLocalizations.of(context)!.taylor_expansion,
                    icon: Icons.looks_5_outlined,
                    formulaDescription: 'これは数式の説明です。',
                    overview: '概要の説明',
                    compatibleTypes: 'ここに相性の良いタイプを記載してください。',
                    advantages: 'ここにメリットを記載してください。',
                    disadvantages: 'ここにデメリットを記載してください。',
                    methodKey: 'method_5',
                  );// カスタムモーダル表示
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
                  showCustomModal(
                    context,
                    ref,
                    title: AppLocalizations.of(context)!.simpson_act,
                    icon: Icons.looks_6_outlined,
                    formulaDescription: 'これは数式の説明です。',
                    overview: '概要の説明',
                    compatibleTypes: 'ここに相性の良いタイプを記載してください。',
                    advantages: 'ここにメリットを記載してください。',
                    disadvantages: 'ここにデメリットを記載してください。',
                    methodKey: 'method_6',
                  );// カスタムモーダル表示
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
