import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('勾配計算'),
        automaticallyImplyLeading: false,
      ),
      body:
      const Center(child: Text('勾配計算画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}