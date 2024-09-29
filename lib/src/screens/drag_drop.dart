import 'package:flutter/material.dart';

class DragDropScreen extends StatelessWidget {
  const DragDropScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ドラッグ＆ドロップ'),
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

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Draggable<String>(
          data: items[index],
          child: DragItem(imagePath: items[index]),
          feedback: Material(
            child: DragItem(imagePath: items[index]),
          ),
          childWhenDragging: Container(),
        );
      },
    );
  }
}

class DragItem extends StatelessWidget {
  final String imagePath;

  DragItem({required this.imagePath});

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
