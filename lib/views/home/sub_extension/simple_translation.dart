import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SimpleTranslationScreen extends StatefulWidget {
  const SimpleTranslationScreen({super.key});

  @override
  _SimpleTranslationScreenState createState() => _SimpleTranslationScreenState();
}

class _SimpleTranslationScreenState extends State<SimpleTranslationScreen> {
  // ドロップダウンの初期値
  String? _selectedValue1 = '日本語';
  String? _selectedValue2 = '日本語';

  // ドロップダウンの選択肢
   List<String> _dropdownValues1 = ['日本語', 'English', '한국어'];
   List<String> _dropdownValues2 = ['日本語', 'English', '한국어'];

  @override
  Widget build(BuildContext context) {
    // 画面サイズを取得
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // レスポンシブに合わせて幅や高さを調整
    double containerWidth = width > 600 ? 400 : width * 0.8;  // 横幅が600pxを超える場合は400px、そうでなければ80%
    double containerHeight = height * 0.6;  // 高さは画面の60%

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.simple_translation),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.blue.shade50,
        child: Center(
          child: Container(
            width: containerWidth,  // レスポンシブ対応した幅
            height: containerHeight,  // レスポンシブ対応した高さ
            decoration: BoxDecoration(
              color: const Color(0x00000000),
              border: Border.all(
                color: Colors.blue,
                width: 10.0,
              ),
              borderRadius: BorderRadius.circular(32.0),
            ),
            child: SingleChildScrollView(  // コンテンツが画面サイズを超える場合にスクロールできるように
              child: Column(  // Columnウィジェットを使って縦に並べる
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 最初のドロップダウンメニュー
                  DropdownButton<String>(
                    value: _selectedValue1,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedValue1 = newValue;
                      });
                    },
                    items: _dropdownValues1.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),  // ドロップダウンとテキストボックスの間にスペースを追加
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),  // テキストボックスの左右の余白
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '入力してください',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),  // 上下に余白を追加して、間隔を空ける

                  const Center(child: Text('↓', style: TextStyle(fontSize: 40.0))),

                  // 2つ目のドロップダウンメニュー
                  DropdownButton<String>(
                    value: _selectedValue2,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedValue2 = newValue;
                      });
                    },
                    items: _dropdownValues2.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),  // ドロップダウンとテキストボックスの間にスペースを追加
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),  // テキストボックスの左右の余白
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '入力してください',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}