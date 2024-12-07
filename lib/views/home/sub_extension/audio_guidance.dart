import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AudioGuidanceScreen extends StatefulWidget {
  const AudioGuidanceScreen({super.key});

  @override
  _AudioGuidanceScreenState createState() => _AudioGuidanceScreenState();
}

class _AudioGuidanceScreenState extends State<AudioGuidanceScreen> {
  // ボタンが押されたかどうかを管理する変数
  bool isStarted = false;

  // ドロップダウンメニューの選択肢
  String? selectedOption;

  // ドロップダウンの選択肢リスト
  List<String> options = ['日本語', 'English', '한국어'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.audio_guidance),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ドロップダウンボックス
            DropdownButton<String>(
              value: selectedOption,
              hint: Text('選択してください'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedOption = newValue;
                });
              },
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20), // ボタンとドロップダウンの間にスペースを追加
            // 正方形のボタン
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isStarted = !isStarted; // スタートとストップを切り替え
                });
              },
              child: Text(
                isStarted ? 'ストップ' : 'スタート', // 状態に応じて表示を切り替え
                style: TextStyle(fontSize: 24),  // テキストのフォントサイズを設定
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 200), // 横幅と高さを同じに設定して正方形にする
                shape: RoundedRectangleBorder(  // ボタンを角丸にする場合
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: isStarted ? Colors.red : Colors.green, // ボタンの色を変更
              ),
            ),
          ],
        ),
      ),
    );
  }
}
