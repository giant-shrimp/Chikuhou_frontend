import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 言語の状態を管理するNotifier
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('ja'));  // 初期値:日本語

  // 言語を更新するメソッド
  void setLocale(Locale locale) {
    state = locale;
  }
}

// LocaleNotifierのプロバイダー
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
