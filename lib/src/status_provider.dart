import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Map<String, dynamic> getStatusDetails(BuildContext context, String currentStatus) {
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
  } else {
    statusIcon = Icons.directions_walk_sharp;
    statusText = AppLocalizations.of(context)!.walker;
  }

  return {'icon': statusIcon, 'text': statusText};
}