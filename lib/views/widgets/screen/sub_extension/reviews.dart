import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.reviews),
        automaticallyImplyLeading: false,
      ),
      body:
      const Center(child: Text('口コミ画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}