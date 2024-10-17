import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DragDropScreen extends StatelessWidget {
  const DragDropScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.sub_extension),
      ),
      body: Stack(
        children: [
          const DragDropContainer(), // ドラッグドロップエリア
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavigationBar(
              currentIndex: 2, // デフォルトでホームを選択
              onTap: null, // タップを無効化
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: const Icon(Icons.table_rows_rounded),
                    label: AppLocalizations.of(context)!.menu
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.cloudy_snowing, color: Colors.redAccent),
                  label: '1st',
                ),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.home),
                    label: AppLocalizations.of(context)!.home
                ),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.volume_up, color: Colors.redAccent),
                    label: '2nd'
                ),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.directions_walk_sharp),
                    label: AppLocalizations.of(context)!.status
                ),
              ],
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.grey, // 選択中のアイテムの色
              unselectedItemColor: Colors.grey, // 未選択のアイテムの色
            ),
          ),
          // 上部に空箱を追加
          Positioned(
            top: 590,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //const EmptyBox(),
                EmptyBox1(
                  icon: Icons.cloudy_snowing,
                  label: AppLocalizations.of(context)!.rain_cloud_radar,
                ),
                EmptyBox2(
                  icon: Icons.volume_up,
                  label: AppLocalizations.of(context)!.audio_guidance,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DragDropContainer extends StatefulWidget {
  const DragDropContainer({super.key});

  @override
  _DragDropContainerState createState() => _DragDropContainerState();
}

class _DragDropContainerState extends State<DragDropContainer> {
  List<Map<String, dynamic>> items = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    items = [
      {'icon': Icons.cloudy_snowing, 'label': AppLocalizations.of(context)!.rain_cloud_radar},
      {'icon': Icons.volume_up, 'label': AppLocalizations.of(context)!.audio_guidance},
      {'icon': Icons.g_translate, 'label': AppLocalizations.of(context)!.simple_translation},
      {'icon': Icons.forum, 'label': AppLocalizations.of(context)!.reviews},
      {'icon': Icons.directions_run, 'label': AppLocalizations.of(context)!.marathon_course},
      {'icon': Icons.add_home_work, 'label': AppLocalizations.of(context)!.securing_evacuation_routes},
      {'icon': Icons.monitor_weight, 'label': AppLocalizations.of(context)!.calorie_count},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return DragTarget<Map<String, dynamic>>(
          onAccept: (receivedItem) {
            setState(() {
              final draggedIndex = items.indexOf(receivedItem);
              final tempItem = items[index];
              items[index] = receivedItem;
              items[draggedIndex] = tempItem;
            });
          },
          onWillAccept: (receivedItem) => receivedItem != items[index],
          builder: (context, candidateData, rejectedData) {
            return Draggable<Map<String, dynamic>>(
              data: items[index],
              onDragCompleted: () {
                setState(() {});
              },
              onDraggableCanceled: (velocity, offset) {
                setState(() {});
              },
              feedback: Material(
                child: DragItem(
                  icon: items[index]['icon'],
                  label: items[index]['label'],
                ),
              ),
              childWhenDragging: Container(),
              child: DragItem(
                icon: items[index]['icon'],
                label: items[index]['label'],
              ),
            );
          },
        );
      },
    );
  }
}

class DragItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const DragItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.white),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center, // テキストを中央揃え
          ),
        ],
      ),
    );
  }
}

// 空の箱ウィジェット
class EmptyBox extends StatelessWidget {
  const EmptyBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      height: 125,
      decoration: BoxDecoration(
        color: Colors.grey[400], // 背景色を設定
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          '右のボックスに\nサブ機能を入れて\nカスタマイズする\nことができます',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

// アイコンとラベルを持つ空箱ウィジェット
class EmptyBox1 extends StatelessWidget {
  final IconData icon;
  final String label;

  const EmptyBox1({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      height: 125,
      decoration: BoxDecoration(
        color: Colors.redAccent, // 背景色を設定
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 50),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class EmptyBox2 extends StatelessWidget {
  final IconData icon;
  final String label;

  const EmptyBox2({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      height: 125,
      decoration: BoxDecoration(
        color: Colors.redAccent, // 背景色を設定
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 50),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
