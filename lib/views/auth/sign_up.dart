import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../config/providers/viewmodel_provider.dart';
import '../../core/utils/dialog_helpers.dart';
import '../app/app.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/custom_text_field.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final viewModel = ref.watch(signUpViewModelProvider);
    final viewModelNotifier = ref.read(signUpViewModelProvider.notifier);

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
        title: Text(AppLocalizations.of(context)!.sign_up),
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
                    label: AppLocalizations.of(context)!.username,
                    icon: Icons.account_circle,
                    isPassword: false,
                    onChanged: viewModelNotifier.updateUsername,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: AppLocalizations.of(context)!.email,
                    icon: Icons.email,
                    isPassword: false,
                    onChanged: viewModelNotifier.updateEmail,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: AppLocalizations.of(context)!.password,
                    icon: Icons.lock,
                    isPassword: true,
                    onChanged: viewModelNotifier.updatePassword,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: AppLocalizations.of(context)!.password_confirmation,
                    icon: Icons.lock,
                    isPassword: true,
                    onChanged: viewModelNotifier.updatePasswordConfirmation,
                  ),
                  const SizedBox(height: 60),
                  CustomButton(
                    text: AppLocalizations.of(context)!.sign_up,
                    onPressed: () async {
                      final success = await viewModelNotifier.signUp();
                      if (success) {
                        // サインアップ成功後、アプリのメイン画面に遷移
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyStatefulWidget(),
                          ),
                        );
                      } else {
                        // サインアップ失敗時のエラー表示
                        await showDialogs(
                          context: context,
                          title: AppLocalizations.of(context)!.sign_up_error,
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