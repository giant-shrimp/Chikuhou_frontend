import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPassword extends StatelessWidget {
  const SettingsPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.password),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              obscureText: true, // パスワード入力を非表示
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.current_password,
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true, // パスワード入力を非表示
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.new_password,
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true, // パスワード確認を非表示
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.new_password_confirmation,
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // 背景色を白に設定
                foregroundColor: Colors.black, // テキスト色を黒に設定
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
              ),
              child: Text(AppLocalizations.of(context)!.change_password),
            ),
          ],
        ),
      ),
    );
  }
}
