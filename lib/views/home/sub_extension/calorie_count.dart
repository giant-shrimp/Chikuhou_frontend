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
                  Expanded(
        child: Container(
          width:600,height:1300,
          child: Image.asset(
            'images/tizu.jpg',
            fit: BoxFit.cover,
          )
        )
      )
    );
  }
}