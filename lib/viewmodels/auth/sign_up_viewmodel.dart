import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';

/// サインアップ画面のロジックを管理するViewModel
class SignUpViewModel extends ChangeNotifier {
  final AuthService _authService;

  SignUpViewModel(this._authService);

  // ユーザー入力フィールド
  String username = '';
  String email = '';
  String password = '';
  String passwordConfirmation = '';

  /// 入力値を更新する
  void updateUsername(String value) {
    username = value;
    notifyListeners();
  }

  void updateEmail(String value) {
    email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    password = value;
    notifyListeners();
  }

  void updatePasswordConfirmation(String value) {
    passwordConfirmation = value;
    notifyListeners();
  }

  /// サインアップ処理
  Future<bool> signUp() async {
    if (password != passwordConfirmation) {
      return false; // パスワード不一致
    }
    // AuthServiceを利用した仮のサインアップロジック
    return await _authService.signIn(email: email, password: password);
  }
}
