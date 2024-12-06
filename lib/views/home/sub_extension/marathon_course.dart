import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MarathonCourseScreen extends StatefulWidget {
  const MarathonCourseScreen({super.key});

  @override
  _MarathonCourseScreenState createState() => _MarathonCourseScreenState();
}

class _MarathonCourseScreenState extends State<MarathonCourseScreen> {
  double _scale = 1.0; // 初期ズームスケール

  // ズームイン
  void _zoomIn() {
    setState(() {
      _scale = (_scale + 0.1).clamp(1.0, 3.0); // 最大3倍に制限
    });
  }

  // ズームアウト
  void _zoomOut() {
    setState(() {
      _scale = (_scale - 0.1).clamp(1.0, 3.0); // 最小1倍に制限
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.marathon_course),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          // 画像の表示部分
          Positioned.fill(
            child: InteractiveViewer(
              boundaryMargin: EdgeInsets.all(0),
              minScale: 1.0,
              maxScale: 3.0,
              scaleEnabled: false, // 自動スケール無効
              child: Transform.scale(
                scale: _scale,
                child: Image.asset(
                  'assets/marathon.png', // マラソンコース画像
                  fit: BoxFit.cover, // 画像が全画面にフィットし、途切れても良い
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 20,
            child: Column(
              children: [
                // 拡大ボタン
                GestureDetector(
                  onTap: _zoomIn,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // 縮小ボタン
                GestureDetector(
                  onTap: _zoomOut,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.remove,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
