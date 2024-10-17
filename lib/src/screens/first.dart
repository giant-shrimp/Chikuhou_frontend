import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.rain_cloud_radar),
        automaticallyImplyLeading: false,
      ),
      body:
      const Center(child: Text('雨雲レーダー画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}