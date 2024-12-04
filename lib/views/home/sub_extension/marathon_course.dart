import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MarathonCourseScreen extends StatelessWidget {
  const MarathonCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.marathon_course),
        automaticallyImplyLeading: false,
      ),
      body:
                  Expanded(
        child: Container(
          width:600,height:1300,
          child: Image.asset(
            'assets/marason.png',
            fit: BoxFit.cover,
          )
        )
      )
    );
  }
}