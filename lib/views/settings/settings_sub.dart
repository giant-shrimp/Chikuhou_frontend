import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../config/providers/status_provider.dart';
import '../../config/providers/sub_provider.dart';
import 'settings_status.dart';

// 選択されたアイテムの状態を管理するプロバイダー
final selectedItemProvider =
    StateNotifierProvider<SelectedItemNotifier, Map<String, dynamic>>(
  (ref) => SelectedItemNotifier(),
);

class SelectedItemNotifier extends StateNotifier<Map<String, dynamic>> {
  SelectedItemNotifier()
      : super({'icon': Icons.cloudy_snowing, 'label': '雨雲レーダー'});

  void selectItem(Map<String, dynamic> item) {
    state = item;
  }
}

class SettingsSub extends ConsumerWidget {
  const SettingsSub({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 現在のステータスを取得
    final currentStatus = ref.watch(statusProvider);
    final statusDetails = getStatusDetails(context, currentStatus);
    IconData statusIcon = statusDetails['icon'];
    // 選択したサブ機能を取得
    final selectedItem = ref.watch(selectedItemProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.sub_extension),
      ),
      body: Stack(
        children: [
          const DragDropContainer(), // アイコン選択エリア
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavigationBar(
              currentIndex: 2, // デフォルトでホームを選択
              onTap: null, // タップを無効化
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: const Icon(Icons.table_rows_rounded),
                    label: AppLocalizations.of(context)!.menu),
                BottomNavigationBarItem(
                  icon: Icon(selectedItem['icon'], color: Colors.indigo[400]),
                  label: AppLocalizations.of(context)!.sub,
                ),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.home),
                    label: AppLocalizations.of(context)!.home),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.route),
                    label: AppLocalizations.of(context)!.gradient),
                BottomNavigationBarItem(
                    icon: Icon(statusIcon),
                    label: AppLocalizations.of(context)!.status),
              ],
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.grey, // 選択中のアイテムの色
              unselectedItemColor: Colors.grey, // 未選択のアイテムの色
            ),
          ),
          // 上部に選択されたアイテムを表示
          Positioned(
            top: 590,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                EmptyBox1(
                  icon: selectedItem['icon'],
                  label: selectedItem['label'],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DragDropContainer extends HookConsumerWidget {
  const DragDropContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(dragDropItemsProvider);

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        // ローカライズされたラベルを取得
        final localizedLabel =
            _getLocalizedLabel(context, items[index]['label']);

        return DragItem(
          icon: items[index]['icon'],
          label: localizedLabel,
          onSelect: () {
            // アイテムを選択
            ref.read(selectedItemProvider.notifier).selectItem({
              'icon': items[index]['icon'],
              'label': localizedLabel,
            });
          },
        );
      },
    );
  }

  // ラベルをローカライズするメソッド
  String _getLocalizedLabel(BuildContext context, String labelKey) {
    final localizations = AppLocalizations.of(context)!;
    switch (labelKey) {
      case 'rain_cloud_radar':
        return localizations.rain_cloud_radar;
      case 'audio_guidance':
        return localizations.audio_guidance;
      case 'simple_translation':
        return localizations.simple_translation;
      case 'reviews':
        return localizations.reviews;
      case 'marathon_course':
        return localizations.marathon_course;
      case 'securing_evacuation_routes':
        return localizations.securing_evacuation_routes;
      case 'calorie_count':
        return localizations.calorie_count;
      default:
        return labelKey; // デフォルトはキーをそのまま表示
    }
  }
}

class DragItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onSelect;

  const DragItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onSelect,
  });

  @override
  State<DragItem> createState() => _DragItemState();
}

class _DragItemState extends State<DragItem> {
  Color _backgroundColor = Colors.blueGrey[400]!;
  bool _isHovering = false;
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isActive = true; // タップ時の状態
        });
        widget.onSelect();
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) {
        setState(() {
          _isActive = false; // タップ解除
        });
      },
      onTapCancel: () {
        setState(() {
          _isActive = false; // キャンセル時
        });
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovering = true; // ホバー状態
          });
        },
        onExit: (_) {
          setState(() {
            _isHovering = false; // ホバー解除
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: _isActive
                ? const Color.fromARGB(255, 0, 255, 229)
                : _isHovering
                    ? Colors.teal[100]
                    : _backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 50, color: Colors.white),
              const SizedBox(height: 5),
              Text(
                widget.label,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
        color: Colors.indigo[400], // 背景色を設定
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
