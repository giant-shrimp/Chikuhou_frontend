import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../app.dart';
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
            TextField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.email,
                prefixIcon: const Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true, // パスワード入力を非表示
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.password,
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 60),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // ログイン成功後、app.dartに遷移
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyStatefulWidget()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // 背景色を白に設定
                    foregroundColor: Colors.black, // テキスト色を黒に設定
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 50),
                  ),
                  child: Text(AppLocalizations.of(context)!.sign_in),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // 背景色を白に設定
                    foregroundColor: Colors.black, // テキスト色を黒に設定
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 50),
                  ),
                  child: Text(AppLocalizations.of(context)!.sign_up),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
