import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 汎用ダイアログを表示するヘルパー関数
Future<void> showDialogs({
  required BuildContext context,
  required String title,
  String? content,
  String? cancelText, // キャンセルボタンのテキスト（オプショナル）
  String? confirmText, // 確認ボタンのテキスト（オプショナル）
  VoidCallback? onConfirm, // 確認ボタンの処理（オプショナル）
}) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: content != null
            ? Text(content)
            : const SizedBox.shrink(), // contentがnullの場合は空のウィジェット
        actions: <Widget>[
          // キャンセルボタンが必要な場合のみ表示
          if (cancelText != null)
            CupertinoDialogAction(
              child: Text(cancelText),
              onPressed: () {
                Navigator.of(context).pop(); // ダイアログを閉じる
              },
            ),
          // 確認ボタンが必要な場合のみ表示
          if (confirmText != null)
            CupertinoDialogAction(
              isDestructiveAction: true, // 強調表示
              child: Text(confirmText),
              onPressed: () {
                Navigator.of(context).pop(); // ダイアログを閉じる
                if (onConfirm != null) {
                  onConfirm(); // 確認ボタンの処理を実行
                }
              },
            ),
        ],
      );
    },
  );
}
