import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GradientCalculationScreen extends StatelessWidget {
  const GradientCalculationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.gradient_calculation),
        automaticallyImplyLeading: false,
      ),
      body:
      const Center(child: Text('勾配計算画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}