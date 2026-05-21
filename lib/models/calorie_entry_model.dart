enum ExerciseType { walk, jog, run, bike }

extension ExerciseTypeX on ExerciseType {
  String get label {
    switch (this) {
      case ExerciseType.walk:
        return 'ウォーキング';
      case ExerciseType.jog:
        return 'ジョギング';
      case ExerciseType.run:
        return 'ランニング';
      case ExerciseType.bike:
        return 'サイクリング';
    }
  }

  double get mets {
    switch (this) {
      case ExerciseType.walk:
        return 3.5;
      case ExerciseType.jog:
        return 7.0;
      case ExerciseType.run:
        return 10.0;
      case ExerciseType.bike:
        return 6.0;
    }
  }
}

class CalorieEntry {
  final double weightKg;
  final int minutes;
  final ExerciseType type;
  final double kcal;
  final DateTime calculatedAt;

  CalorieEntry({
    required this.weightKg,
    required this.minutes,
    required this.type,
    required this.kcal,
    required this.calculatedAt,
  });
}
