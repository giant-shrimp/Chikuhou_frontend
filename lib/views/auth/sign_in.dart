import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../app/app.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/custom_text_field.dart';
import 'sign_up.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            ),
            const SizedBox(height: 16),
            // パスワード入力フィールド
            CustomTextField(
              label: AppLocalizations.of(context)!.password,
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 60),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  text: AppLocalizations.of(context)!.sign_in,
                  onPressed: () {
                    // ログイン成功後、アプリのメイン画面に遷移
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyStatefulWidget(),
                      ),
                    );
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
