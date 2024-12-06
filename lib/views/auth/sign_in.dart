import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../config/providers/viewmodel_provider.dart';
import '../../core/utils/dialog_helpers.dart';
import '../app/app.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/custom_text_field.dart';
import 'sign_up.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(signInViewModelProvider);
    final viewModelNotifier = ref.read(signInViewModelProvider.notifier);

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
        title: Text(AppLocalizations.of(context)!.sign_in),
        automaticallyImplyLeading: false,
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
                  // メールアドレス入力フィールド
                  CustomTextField(
                    label: AppLocalizations.of(context)!.email,
                    icon: Icons.email,
                    isPassword: false,
                    onChanged: viewModelNotifier.updateEmail,
                  ),
                  const SizedBox(height: 16),
                  // パスワード入力フィールド
                  CustomTextField(
                    label: AppLocalizations.of(context)!.password,
                    icon: Icons.lock,
                    isPassword: true,
                    onChanged: viewModelNotifier.updatePassword,
                  ),
                  const SizedBox(height: 60),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        text: AppLocalizations.of(context)!.sign_in,
                        onPressed: () async {
                          final success = await viewModelNotifier.signIn();
                          if (success) {
                            // ログイン成功後、アプリのメイン画面に遷移
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyStatefulWidget(),
                              ),
                            );
                          } else {
                            // ログイン失敗時のエラーダイアログ
                            await showDialogs(
                              context: context,
                              title: AppLocalizations.of(context)!.sign_in_error,
                              confirmText: AppLocalizations.of(context)!.ok,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        text: AppLocalizations.of(context)!.sign_up,
                        onPressed: () {
                          // サインアップ画面へ遷移
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                      ),
                    ],
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
