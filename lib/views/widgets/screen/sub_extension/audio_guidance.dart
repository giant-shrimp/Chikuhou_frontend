import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AudioGuidanceScreen extends StatelessWidget {
  const AudioGuidanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.audio_guidance),
        automaticallyImplyLeading: false,
      ),
      body:
      const Center(child: Text('音声案内画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}