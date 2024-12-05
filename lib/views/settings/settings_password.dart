import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../config/providers/viewmodel_provider.dart';
import '../../core/utils/dialog_helpers.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/custom_text_field.dart';

class SettingsPassword extends ConsumerWidget {
  const SettingsPassword({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(passwordSettingsViewModelProvider);
    final viewModelNotifier = ref.read(passwordSettingsViewModelProvider.notifier);

        // 画面サイズを取得
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // アプリバーの高さを引いて残りの高さを使う
    double appBarHeight = AppBar().preferredSize.height;
    double containerHeight = height - appBarHeight - 32;  // 32pxの余白を考慮

    // レスポンシブに合わせて幅や高さを調整
    double containerWidth = width > 600 ? 400 : width * 0.8;  // 横幅が600pxを超える場合は400px、そうでなければ80%

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.password),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(  // スクロール可能にして画面サイズに合わせる
          child: Center(
            child: Container(
              width: containerWidth,  // レスポンシブ対応した幅
              height: containerHeight,  // 高さを画面の残り部分に設定
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    label: AppLocalizations.of(context)!.current_password,
                    icon: Icons.lock_outline,
                    isPassword: true,
                    onChanged: viewModelNotifier.updateCurrentPassword,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: AppLocalizations.of(context)!.new_password,
                    icon: Icons.lock,
                    isPassword: true,
                    onChanged: viewModelNotifier.updateNewPassword,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: AppLocalizations.of(context)!.new_password_confirmation,
                    icon: Icons.lock,
                    isPassword: true,
                    onChanged: viewModelNotifier.updateConfirmPassword,
                  ),
                  const SizedBox(height: 60),
                  CustomButton(
                    text: AppLocalizations.of(context)!.change_password,
                    onPressed: () async {
                      final success = await viewModelNotifier.changePassword();
                      if (success) {
                        // 成功した場合、ダイアログなどで通知を表示
                        await showDialogs(
                          context: context,
                          title: AppLocalizations.of(context)!.change_password_success,
                          confirmText: AppLocalizations.of(context)!.ok,
                        );
                      } else {
                        // 失敗した場合、エラーダイアログを表示
                        await showDialogs(
                          context: context,
                          title: AppLocalizations.of(context)!.change_password_error,
                          confirmText: AppLocalizations.of(context)!.ok,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
