import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// アカウント情報を管理するViewModel
class AccountInformationViewModel extends ChangeNotifier {
  String _userName = 'John Doe';
  String _email = 'johndoe@example.com';
  String _phone = '+123 456 7890';

  // Getters to access the user information
  String get userName => _userName;
  String get email => _email;
  String get phone => _phone;

  // データを更新するメソッド
  void fetchUserInformation() {
    // ここでは簡易的にダミーデータを使っていますが、firebaseから後で取得できるように置き換えましょう
    // _userName = 'firebaseからのデータ';
    // _email = 'firebaseからのデータ';
    // _phone = 'firebaseからのデータ';
    notifyListeners();
  }

  // ユーザー名を変更するメソッド
  void updateUserName(String newUserName) {
    _userName = newUserName;
    notifyListeners();
  }

  // メールを変更するメソッド
  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  // 電話番号を変更するメソッド
  void updatePhone(String newPhone) {
    _phone = newPhone;
    notifyListeners();
  }
}

// Riverpodのプロバイダを定義
final accountInformationProvider =
    ChangeNotifierProvider<AccountInformationViewModel>(
  (ref) => AccountInformationViewModel(),
);
