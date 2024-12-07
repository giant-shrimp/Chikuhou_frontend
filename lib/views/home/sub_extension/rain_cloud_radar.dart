import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RainCloudRadarScreen extends StatelessWidget {
  const RainCloudRadarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.rain_cloud_radar),
          automaticallyImplyLeading: false,
        ),
        body: Expanded(
            child: Container(
                width: 600,
                height: 1300,
                child: Image.asset(
                  'assets/rainCloud.jpg',
                  fit: BoxFit.cover,
                ))));
  }
}
