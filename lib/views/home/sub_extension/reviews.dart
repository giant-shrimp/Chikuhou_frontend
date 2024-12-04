import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.reviews),
        automaticallyImplyLeading: false,
      ),
      body: Container(
          color: Colors.blue.shade50,
          child: Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0x00000000),
                border: Border.all(
                  color: Colors.blue,
                  width: 10.0,
                ),
                borderRadius: BorderRadius.circular(32.0),
              ),
               child: const Center(  // 文字を中央に配置
                child: Text(
                  'サンプル文字',  // 表示したい文字
                  style: TextStyle(
                    fontSize: 24,  // フォントサイズ
                    color: Colors.black,  // 文字色
                  ),
                ),
              ),
            ),
          ),
        ),
    );
  }
}