class ActivityCalculator {
  const ActivityCalculator();

  static const int activeDayMinutes = 20;

  static const double expectedActiveDaysPerWeek = 3;

  bool isActiveDay({
    required int workoutMinutes,
  }) {
    return workoutMinutes >= activeDayMinutes;
  }

  double dailyActivityScore({
    required int workoutMinutes,
  }) {
    return (workoutMinutes /
        activeDayMinutes *
        100)
        .clamp(0, 100)
        .toDouble();
  }

  double periodActivityScore({
    required int activeDays,
    required int eligibleDays,
  }) {
    if (eligibleDays <= 0) {
      return 0;
    }

    final expectedActiveDays =
        eligibleDays *
            expectedActiveDaysPerWeek /
            7;

    if (expectedActiveDays <= 0) {
      return 0;
    }

    return (activeDays /
        expectedActiveDays *
        100)
        .clamp(0, 100)
        .toDouble();
  }
}