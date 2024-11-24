class UserModel {
  final String userName;
  final String email;
  final String phone;

  UserModel({
    required this.userName,
    required this.email,
    this.phone = '', // 任意フィールドとして初期値を設定
  });
}
