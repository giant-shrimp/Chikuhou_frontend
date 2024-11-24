import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';

/// パスワード変更画面のロジックを管理するViewModel
class PasswordSettingsViewModel extends ChangeNotifier {
  final AuthService _authService;

  PasswordSettingsViewModel(this._authService);

  // ユーザー入力のフィールド
  String currentPassword = '';
  String newPassword = '';
  String confirmPassword = '';

  /// 入力値を更新する
  void updateCurrentPassword(String value) {
    currentPassword = value;
    notifyListeners();
  }

  void updateNewPassword(String value) {
    newPassword = value;
    notifyListeners();
  }

  void updateConfirmPassword(String value) {
    confirmPassword = value;
    notifyListeners();
  }

  /// パスワード変更処理
  Future<bool> changePassword() async {
    // バリデーションチェック（例: 現在のパスワード、入力一致など）
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      return false; // 新しいパスワードまたは確認用パスワードが未入力の場合
    }
    if (newPassword != confirmPassword) {
      return false; // 新しいパスワードと確認用パスワードが一致しない場合
    }

    // サーバー側にパスワード変更をリクエスト
    return await _authService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
