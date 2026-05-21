import 'package:flutter/foundation.dart';
import 'package:challecara/models/calorie_entry_model.dart';

class CalorieCountViewModel extends ChangeNotifier {
  final List<CalorieEntry> history = [];
  CalorieEntry? latest;

  double calc(double weightKg, int minutes, ExerciseType type) {
    final hours = minutes / 60.0;
    return type.mets * weightKg * hours * 1.05;
  }

  void submit({
    required double weightKg,
    required int minutes,
    required ExerciseType type,
  }) {
    final kcal = calc(weightKg, minutes, type);
    final entry = CalorieEntry(
      weightKg: weightKg,
      minutes: minutes,
      type: type,
      kcal: kcal,
      calculatedAt: DateTime.now(),
    );
    latest = entry;
    history.insert(0, entry);
    notifyListeners();
  }

  void clear() {
    history.clear();
    latest = null;
    notifyListeners();
  }
}
