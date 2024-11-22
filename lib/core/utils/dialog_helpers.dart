import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// ログアウト確認ダイアログを表示するヘルパー関数
Future<void> showDialogs({
  required BuildContext context,
  required String title,
  required String content,
  required String cancelText,
  required String confirmText,
  required VoidCallback onConfirm,
}) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(cancelText),
            onPressed: () {
              Navigator.of(context).pop(); // ダイアログを閉じる
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true, // 強調表示
            child: Text(confirmText),
            onPressed: () {
              Navigator.of(context).pop(); // ダイアログを閉じる
              onConfirm(); // 確認ボタンの処理を実行
            },
          ),
        ],
      );
    },
  );
}
