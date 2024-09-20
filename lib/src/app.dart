import 'package:flutter/material.dart';

import '../next_page.dart';
import 'screens/first.dart';
import 'screens/second.dart';
import 'screens/third.dart';
import 'screens/menu.dart';
import 'screens/home.dart';
import 'screens/search_bar.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyStatefulWidget(),
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
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.table_rows_rounded), label: 'メニュー'),
            BottomNavigationBarItem(icon: Icon(Icons.looks_one_outlined), label: '1st'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
            BottomNavigationBarItem(icon: Icon(Icons.looks_two_outlined), label: '2nd'),
            BottomNavigationBarItem(icon: Icon(Icons.looks_3_outlined), label: '3rd'),
          ],
          type: BottomNavigationBarType.fixed,
        ));
  }
}
