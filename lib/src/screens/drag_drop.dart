import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DragDropScreen extends StatelessWidget {
  const DragDropScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.sub_extension),
      ),
      body: DragDropContainer(),
    );
  }
}

class DragDropContainer extends StatefulWidget {
  @override
  _DragDropContainerState createState() => _DragDropContainerState();
}

class _DragDropContainerState extends State<DragDropContainer> {
  // Combine icon and label together
  List<Map<String, dynamic>> items = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize items with localized labels
    items = [
      {
        'icon': Icons.cloudy_snowing,
        'label': AppLocalizations.of(context)!.rain_cloud_radar,
      },
      {
        'icon': Icons.volume_up,
        'label': AppLocalizations.of(context)!.audio_guidance,
      },
      {
        'icon': Icons.g_translate,
        'label': AppLocalizations.of(context)!.simple_translation,
      },
      {
        'icon': Icons.forum,
        'label': AppLocalizations.of(context)!.reviews,
      },
      {
        'icon': Icons.directions_run,
        'label': AppLocalizations.of(context)!.marathon_course,
      },
      {
        'icon': Icons.add_home_work,
        'label': AppLocalizations.of(context)!.securing_evacuation_routes,
      },
      {
        'icon': Icons.monitor_weight,
        'label': AppLocalizations.of(context)!.calorie_count,
      },
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

  const DragItem({required this.icon, required this.label});

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
          ),
        ],
      ),
    );
  }
}
