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
  List<String> items = [
    'image1.jpg',
    'image2.jpg',
    'image3.jpg',
    'image4.jpg',
    'image5.jpg',
    'image6.jpg',
    'image7.jpg',
    'image8.jpg',
    'image9.jpg',
    'image10.jpg',
    'image11.jpg',
    'image12.jpg',
  ];

  String? draggedItem;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return DragTarget<String>(
          onAccept: (receivedItem) {
            setState(() {
              final draggedIndex = items.indexOf(receivedItem);
              // ドラッグしたアイテムとドロップ先のアイテムを入れ替え
              final temp = items[index];
              items[index] = receivedItem;
              items[draggedIndex] = temp;
            });
          },
          onWillAccept: (receivedItem) => receivedItem != items[index],
          builder: (context, candidateData, rejectedData) {
            return Draggable<String>(
              data: items[index],
              onDragStarted: () {
                setState(() {
                  draggedItem = items[index];
                });
              },
              onDragCompleted: () {
                setState(() {
                  draggedItem = null;
                });
              },
              onDraggableCanceled: (velocity, offset) {
                setState(() {
                  draggedItem = null;
                });
              },
              feedback: Material(
                child: DragItem(imagePath: items[index]),
              ),
              childWhenDragging: Container(),
              child: DragItem(imagePath: items[index]),
            );
          },
        );
      },
    );
  }
}

class DragItem extends StatelessWidget {
  final String imagePath;

  const DragItem({required this.imagePath});

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
          Image.asset(imagePath, fit: BoxFit.cover),
          const SizedBox(height: 5),
          Text(imagePath.split('/').last),
        ],
      ),
    );
  }
}
