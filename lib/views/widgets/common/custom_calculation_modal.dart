import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../settings/settings_calculation_method.dart';
import 'custom_button.dart';

class CustomModal extends StatelessWidget {
  final WidgetRef ref; // WidgetRefを受け取る
  final String title;
  final IconData headerIcon;
  final String formulaDescription; // 数式の説明
  final String overview; //概要の説明
  final List<Map<String, dynamic>> compatibleTypes; // 相性の良いタイプの説明 (アイコンと文字のリスト)
  final String advantages; // メリットの説明
  final String disadvantages; // デメリットの説明
  final String methodKey; // どの計算方法が選ばれたかを渡す

  const CustomModal({
    super.key,
    required this.ref,
    required this.title,
    required this.headerIcon,
    required this.formulaDescription,
    required this.overview,
    required this.compatibleTypes,
    required this.advantages,
    required this.disadvantages,
    required this.methodKey, // methodKeyを追加
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(); // モーダル外をタップすると閉じる
      },
      child: Scaffold(
        backgroundColor: Colors.transparent, // 背景を透明に
        body: Row(
          children: [
            Expanded(
              flex: 1, // 画面左側1/5を空白に
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // 左側空白部分タップで閉じる
                },
                child: Container(color: Colors.transparent),
              ),
            ),
            Expanded(
              flex: 4, // 画面右側4/5にモーダル
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // モーダルのヘッダー
                    AppBar(
                      leading: Icon(headerIcon, color: Colors.white), // ヘッダーにアイコン追加
                      title: Text(title),
                      automaticallyImplyLeading: false, // デフォルト戻るボタン無効化
                      backgroundColor: const Color(0xFF228B22),
                    ),
                    // モーダルの本文
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '数式',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(formulaDescription),
                            const SizedBox(height: 16),
                            const Text(
                              '概要',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(overview),
                            const SizedBox(height: 16),
                            const Text(
                              '相性の良いタイプ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: compatibleTypes.map((type) {
                                return Row(
                                  children: [
                                    Icon(type['icon'], color: Colors.green),
                                    const SizedBox(width: 8),
                                    Text(type['label']),
                                  ],
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'メリット',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(advantages),
                            const SizedBox(height: 16),
                            const Text(
                              'デメリット',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(disadvantages),
                          ],
                        ),
                      ),
                    ),
                    // 決定ボタン
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: '決定',
                          onPressed: () {
                            // 計算方法を変更
                            ref.read(methodProvider.notifier).state = methodKey;
                            Navigator.of(context).pop(); // モーダルを閉じる
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// モーダル表示関数
void showCustomModal(BuildContext context, WidgetRef ref,
    {required String title,
      required IconData icon,
      required String formulaDescription,
      required String overview,
      required List<Map<String, dynamic>> compatibleTypes,
      required String advantages,
      required String disadvantages,
      required String methodKey}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true, // モーダル外タップで閉じる
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    pageBuilder: (context, animation, secondaryAnimation) => CustomModal(
      ref: ref, // WidgetRefを渡す
      title: title,
      headerIcon: icon,
      formulaDescription: formulaDescription,
      overview: overview,
      compatibleTypes: compatibleTypes,
      advantages: advantages,
      disadvantages: disadvantages,
      methodKey: methodKey, // methodKeyも渡す
    ),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final slideAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0), // 右側からスライドイン
        end: Offset.zero,
      ).animate(animation);

      return SlideTransition(
        position: slideAnimation,
        child: child,
      );
    },
  );
}
