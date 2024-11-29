import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SecuringEvacuationRoutesScreen extends StatelessWidget {
  const SecuringEvacuationRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.securing_evacuation_routes),
        automaticallyImplyLeading: false,
      ),
      body:
      const Center(child: Text('避難経路画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}