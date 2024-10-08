import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アルケール'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/image.png', // assetsフォルダ内の画像を表示
              width: 410, // 必要に応じて幅を調整
              height: 800, // 必要に応じて高さを調整
              fit: BoxFit.cover, // 画像をボックスにフィットさせる方法
            ),
          ),
          Positioned(
            top: 16, // AppBarの下に位置させるための余白
            right: 16, // 右寄せ
            child: IconButton(
              icon: const Icon(Icons.assistant_navigation, size: 50),
              onPressed: () {
                // アイコンが押された時の処理をここに追加
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: Colors.transparent, // 背景を透過に設定
            isScrollControlled: true, // ドラッグ可能に設定
            context: context,
            builder: (BuildContext context) {
              return DraggableScrollableSheet(
                initialChildSize: 0.5, // モーダルが表示されるときの初期の高さ
                minChildSize: 0.2,     // 最小の高さ
                maxChildSize: 1.0,     // 最大の高さ
                builder: (BuildContext context, ScrollController scrollController) {
                  return Container(
                    margin: const EdgeInsets.only(top: 64), // 上部にマージンを追加
                    decoration: const BoxDecoration(
                      color: Colors.white, // モーダルの背景色を白に設定
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: ListView(
                      controller: scrollController, // スクロールを有効にする
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                '経路',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // ここに各フォーム項目を追加
                              const TextField(
                                decoration: InputDecoration(
                                  labelText: 'ここから',
                                  suffixIcon: Icon(Icons.arrow_forward_ios),
                                ),
                              ),
                              const TextField(
                                decoration: InputDecoration(
                                  labelText: 'ここまで',
                                  suffixIcon: Icon(Icons.arrow_forward_ios),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                '徒歩　　　　　　　　　',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                '　　　分　　　秒',
                                style: TextStyle(fontSize: 16,decoration: TextDecoration.underline,),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context); // モーダルを閉じる
                                },
                                child: const Text('閉じる'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.south),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // ボタンを右下に配置
    );
  }
}