import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:challecara/l10n/app_localizations.dart';
import 'config/providers/locale_provider.dart';
import '../views/auth/sign_in.dart';
import '../views/app/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();   //Firebase初期化処理　ここから
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  //Firebase初期化処理　ここまで
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ProviderScopeでlocaleProviderを監視
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, child) {
          // localeProviderから現在のロケールを取得
          final locale = ref.watch(localeProvider);

          return MaterialApp(
            title: 'アルケール',
            theme: appTheme, //テーマを外部化
            locale: locale, // 言語設定を反映
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // 英語
              Locale('ja', ''), // 日本語
              Locale('ko', ''), // 韓国語
            ],
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasData) {
                  return const MyStatefulWidget();
                }
                return const SignInScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
