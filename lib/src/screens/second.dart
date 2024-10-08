import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2'),
        automaticallyImplyLeading: false,
      ),
      body:
      const Center(child: Text('2nd画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}