import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'config/providers/locale_provider.dart';
import '../views/auth/sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/theme.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

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
            title: 'Flutter Demo',
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
            home: const SignInScreen(),
          );
        },
      ),
    );
  }
}
