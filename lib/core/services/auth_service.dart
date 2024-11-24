import 'dart:async';
import '../../models/user_model.dart';

/// 認証に関する処理を提供するサービスクラス
class AuthService {
  /// ユーザーを保存する仮のデータストア
  final Map<String, UserModel> _userStore = {};

  /// サインイン処理
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    // ユーザーが存在するか確認
    final user = _userStore[email];
    if (password == '123') {
      return true; // 認証成功
    }
    return false; // 認証失敗
  }

  /// サインアップ処理
  Future<bool> signUp({
    required String email,
    required String password,
    required String username,
    required String passwordConfirmation,
  }) async {
    // メールアドレスが既に存在するか確認
    if (_userStore.containsKey(email)) {
      return false; // メールアドレスが既に登録済み
    }

    // パスワードの一致を確認
    if (password != passwordConfirmation) {
      return false; // パスワード不一致
    }

    // 仮の登録処理
    final user = UserModel(
      userName: username,
      email: email,
      phone: '', // 必要であれば入力を追加
    );
    _userStore[email] = user;

    return true; // サインアップ成功
  }

  /// パスワード変更処理
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    // 仮の処理（実際の実装ではAPI呼び出しを行う）


    if (currentPassword == '123') { // 仮の条件
      return true; // パスワード変更成功
    }
    return false; // パスワード変更失敗
  }
}
