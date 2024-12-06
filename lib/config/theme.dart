import 'package:flutter/material.dart';

/// アプリ全体のテーマ設定
final appTheme = ThemeData(
  primarySwatch: Colors.blue,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF228B22),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
    ),
    centerTitle: true,
  ),
  scaffoldBackgroundColor: const Color(0xFFF2F2F7),
);
