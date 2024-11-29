import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalorieCountScreen extends StatelessWidget {
  const CalorieCountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.calorie_count),
        automaticallyImplyLeading: false,
      ),
      body:
      const Center(child: Text('カロリー計算画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}