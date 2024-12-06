import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';

/// 認証に関する処理を提供するサービスクラス
class AuthService {
  /// ユーザーを保存する仮のデータストア
  final Map<String, UserModel> _userStore = {};
  ///firestoreを用いた認証サービス用
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// サインイン処理
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    ///firestoreからユーザー情報を取得
    try {
      // Firestoreからメールアドレスとパスワードが一致するユーザーを取得
      final querySnapshot = await _firestore
          .collection('users') // コレクション名を確認
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      // ユーザーが存在するか確認
      if (querySnapshot.docs.isNotEmpty) {
        // 認証成功
        return true;
      }

      // 認証失敗
      return false;
    } catch (e) {
      print('Error during signIn: $e');
      return false; // エラー時も認証失敗とする
    }
  }

  /// サインアップ処理
  Future<bool> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    // メールアドレスが既に存在するか確認
    final querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      print("Email already exists");
      return false; // メールアドレスが既に登録済み
    }

    // Firestoreにユーザー情報を保存
    final newDocRef = _firestore.collection('users').doc();
    await newDocRef.set({
      'id': newDocRef.id,
      'user': username,
      'password': password,
      'email': email,
    });
    print("SignUp successful");
    return true; // サインアップ成功
  }

  /// パスワード変更処理
  Future<bool> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    // 現在のパスワードが正しいか確認
    final querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: currentPassword)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return false; // 現在のパスワードが間違っている
    }

    // パスワードを更新
    final docId = querySnapshot.docs.first.id;
    await _firestore.collection('users').doc(docId).update({
      'password': newPassword,
    });

    return true; // パスワード変更成功
  }
}
