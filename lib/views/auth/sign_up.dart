import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../app/app.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.sign_up),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              label: AppLocalizations.of(context)!.username,
              icon: Icons.account_circle,
              isPassword: false,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: AppLocalizations.of(context)!.email,
              icon: Icons.email,
              isPassword: false,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: AppLocalizations.of(context)!.password,
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: AppLocalizations.of(context)!.password_confirmation,
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 60),
            CustomButton(
              text: AppLocalizations.of(context)!.sign_up,
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
          ],
        ),
      ),
    );
  }
}
