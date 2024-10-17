import 'package:flutter/material.dart';

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3'),
        automaticallyImplyLeading: false,
      ),
      body:
      const Center(child: Text('3rd画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}