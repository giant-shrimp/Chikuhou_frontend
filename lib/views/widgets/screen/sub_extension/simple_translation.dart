import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SimpleTranslationScreen extends StatelessWidget {
  const SimpleTranslationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.simple_translation),
        automaticallyImplyLeading: false,
      ),
      body:
      const Center(child: Text('簡単翻訳画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}