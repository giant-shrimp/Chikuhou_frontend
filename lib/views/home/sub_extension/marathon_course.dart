import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:challecara/l10n/app_localizations.dart';
import 'package:challecara/viewmodels/marathon_course_viewmodel.dart';

class MarathonCourseScreen extends StatelessWidget {
  const MarathonCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MarathonCourseViewModel()..load(),
      child: const _MarathonCourseView(),
    );
  }
}

class _MarathonCourseView extends StatelessWidget {
  const _MarathonCourseView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MarathonCourseViewModel>();
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.marathon_course),
        automaticallyImplyLeading: false,
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.error != null
              ? Center(child: Text('Error: ${vm.error}'))
              : Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: vm.selected!.start,
                        zoom: 14,
                      ),
                      polylines: vm.polylines,
                      markers: vm.markers,
                      myLocationEnabled: true,
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      right: 12,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: vm.selected?.id,
                            underline: const SizedBox.shrink(),
                            items: vm.courses
                                .map((c) => DropdownMenuItem(
                                      value: c.id,
                                      child: Text(c.name),
                                    ))
                                .toList(),
                            onChanged: (id) {
                              if (id != null) vm.select(id);
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                vm.selected!.name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(vm.selected!.description),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _stat('距離', '${vm.selected!.distanceKm} km'),
                                  _stat('所要', '${vm.selected!.estimatedMinutes} 分'),
                                  _stat('高低差', '${vm.selected!.elevationGainM.toInt()} m'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _stat(String label, String value) => Expanded(
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Colors.grey)),
            Text(value,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      );
}
