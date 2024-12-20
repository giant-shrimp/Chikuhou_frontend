import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// 現在のステータスを管理するためのProvider
final statusProvider = StateProvider<String>((ref) => 'walker'); //初期値:walker
// ステータス変更用の関数
class SettingsStatus extends HookConsumerWidget {
  const SettingsStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStatus = ref.watch(statusProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.status),
        automaticallyImplyLeading: false,
      ),
      body: SettingsList(
        platform: DevicePlatform.iOS,
        sections: [
          SettingsSection(
            title: const Text(''),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(Icons.directions_walk_sharp),
                title: Text(AppLocalizations.of(context)!.walker),
                trailing: currentStatus == 'walker'
                    ? const Icon(Icons.done, color: Colors.blue) // Walker選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  ref.read(statusProvider.notifier).state = 'walker';  // Walkerに変更
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.directions_run_sharp),
                title: Text(AppLocalizations.of(context)!.runner),
                trailing: currentStatus == 'runner'
                    ? const Icon(Icons.done, color: Colors.blue) // Runner選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  ref.read(statusProvider.notifier).state = 'runner';  // Runnerに変更
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.assist_walker_sharp),
                title: Text(AppLocalizations.of(context)!.senior),
                description: const Text(''),
                trailing: currentStatus == 'senior'
                    ? const Icon(Icons.done, color: Colors.blue) // Senior選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  ref.read(statusProvider.notifier).state = 'senior';  // Seniorに変更
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.directions_bike_sharp),
                title: Text(AppLocalizations.of(context)!.bike),
                trailing: currentStatus == 'bike'
                    ? const Icon(Icons.done, color: Colors.blue) // Bike選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  ref.read(statusProvider.notifier).state = 'bike';  // Bikeに変更
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.accessible_forward_sharp),
                title: Text(AppLocalizations.of(context)!.wheelchair),
                trailing: currentStatus == 'wheelchair'
                    ? const Icon(Icons.done, color: Colors.blue) // Wheelchair選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  ref.read(statusProvider.notifier).state = 'wheelchair';  // Wheelchairに変更
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.child_friendly_sharp),
                title: Text(AppLocalizations.of(context)!.stroller),
                description: const Text(''),
                trailing: currentStatus == 'stroller'
                    ? const Icon(Icons.done, color: Colors.blue) // Stroller選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  ref.read(statusProvider.notifier).state = 'stroller';  // Strollerに変更
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.luggage_outlined),
                title: Text(AppLocalizations.of(context)!.traveler),
                trailing: currentStatus == 'traveler'
                    ? const Icon(Icons.done, color: Colors.blue) // Traveler選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  ref.read(statusProvider.notifier).state = 'traveler';  // Travelerに変更
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
