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

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.sign_in),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
    );
  }
}
