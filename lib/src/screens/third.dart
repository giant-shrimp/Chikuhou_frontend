import 'package:flutter/material.dart';

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3'),
      ),
      body:
      const Center(child: Text('3rd画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}