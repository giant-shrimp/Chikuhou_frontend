import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'locale_provider.dart';
import 'screens/first.dart';
import 'screens/second.dart';
import 'screens/third.dart';
import 'screens/menu.dart';
import 'screens/home.dart';

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
            home: const MyStatefulWidget(),
          );
        },
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static const _screens = [
    MenuScreen(),
    FirstScreen(),
    HomeScreen(),
    SecondScreen(),
    ThirdScreen()
  ];

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: const Icon(Icons.table_rows_rounded), label: AppLocalizations.of(context)!.menu),
            const BottomNavigationBarItem(icon: Icon(Icons.looks_one_outlined), label: '1st'),
            BottomNavigationBarItem(icon: const Icon(Icons.home), label: AppLocalizations.of(context)!.home),
            const BottomNavigationBarItem(icon: Icon(Icons.looks_two_outlined), label: '2nd'),
            const BottomNavigationBarItem(icon: Icon(Icons.looks_3_outlined), label: '3rd'),
          ],
          type: BottomNavigationBarType.fixed,
        ));
  }
}