import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 中華フォントへのフォールバックを防ぐための日本語フォント候補
const List<String> _jpFontFallback = <String>[
  'Noto Sans JP',
  'Noto Sans CJK JP',
  'Hiragino Sans',
  'Hiragino Kaku Gothic ProN',
  'Yu Gothic',
  'YuGothic',
  'Meiryo',
  'sans-serif',
];

TextTheme _withJpFallback(TextTheme base) {
  return base.apply(fontFamilyFallback: _jpFontFallback);
}

/// アプリ全体のテーマ設定
final appTheme = ThemeData(
  primarySwatch: Colors.blue,
  textTheme: _withJpFallback(GoogleFonts.notoSansJpTextTheme()),
  primaryTextTheme: _withJpFallback(GoogleFonts.notoSansJpTextTheme()),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF228B22),
    titleTextStyle: GoogleFonts.notoSansJp(
      color: Colors.white,
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
    ),
    centerTitle: true,
  ),
  scaffoldBackgroundColor: const Color(0xFFF2F2F7),
);
