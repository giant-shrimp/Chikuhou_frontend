import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';

/// サインイン画面のロジックを管理するViewModel
class SignInViewModel extends ChangeNotifier {
  final AuthService _authService;

  SignInViewModel(this._authService);

  // ユーザー入力のフィールド
  String email = '';
  String password = '';

  /// 入力値を更新する
  void updateEmail(String value) {
    email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    password = value;
    notifyListeners();
  }

  /// サインイン処理
  Future<bool> signIn() async {
    return await _authService.signIn(email: email, password: password);
  }
}
