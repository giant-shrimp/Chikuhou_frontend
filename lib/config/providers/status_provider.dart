import 'package:flutter/material.dart';
import 'package:challecara/l10n/app_localizations.dart';

Map<String, dynamic> getStatusDetails(
    BuildContext context, String currentStatus) {
  IconData statusIcon;
  String statusText;

  if (currentStatus == 'runner') {
    statusIcon = Icons.directions_run_sharp;
    statusText = AppLocalizations.of(context)!.runner;
  } else if (currentStatus == 'senior') {
    statusIcon = Icons.assist_walker_sharp;
    statusText = AppLocalizations.of(context)!.senior;
  } else if (currentStatus == 'bike') {
    statusIcon = Icons.directions_bike_sharp;
    statusText = AppLocalizations.of(context)!.bike;
  } else if (currentStatus == 'wheelchair') {
    statusIcon = Icons.accessible_forward_sharp;
    statusText = AppLocalizations.of(context)!.wheelchair;
  } else if (currentStatus == 'stroller') {
    statusIcon = Icons.child_friendly_sharp;
    statusText = AppLocalizations.of(context)!.stroller;
  } else if (currentStatus == 'traveler') {
    statusIcon = Icons.luggage_outlined;
    statusText = AppLocalizations.of(context)!.traveler;
  } else {
    statusIcon = Icons.directions_walk_sharp;
    statusText = AppLocalizations.of(context)!.walker;
  }

  return {'icon': statusIcon, 'text': statusText};
}


// ステータスごとのおすすめ勾配計算手法（勾配計算画面で赤字強調表示される）
// ステータス選択時は先頭の手法が自動で選択される
const Map<String, List<String>> recommendedMethodsByStatus = {
  'walker': ['method_3', 'method_8'],
  'runner': ['method_1', 'method_3', 'method_5', 'method_7', 'method_8'],
  'senior': ['method_2', 'method_5', 'method_6', 'method_9'],
  'bike': ['method_1', 'method_2', 'method_4', 'method_5', 'method_6', 'method_7', 'method_8'],
  'wheelchair': ['method_2', 'method_4', 'method_9'],
  'stroller': ['method_2', 'method_6', 'method_9'],
  'traveler': ['method_3', 'method_8'],
};
