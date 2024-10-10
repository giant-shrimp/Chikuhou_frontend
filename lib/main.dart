import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'src/locale_provider.dart';
import 'src/screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
            theme: ThemeData(
              primarySwatch: Colors.blue,
              // AppBarのタイトルスタイルを一括で設定
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF7CFC00),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
                centerTitle: true,
              ),
              scaffoldBackgroundColor: const Color(0xFFF2F2F7),
            ),
            locale: locale,  // 言語設定を反映
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),  // 英語
              Locale('ja', ''),  // 日本語
              Locale('ko', ''),  // 韓国語
            ],
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
