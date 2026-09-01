class MonthlyTargetAccumulatorCalculator {
  const MonthlyTargetAccumulatorCalculator();

  double calculateSegmentContribution({
    required double expectedWeeklyWeightChangeKg,
    required DateTime segmentStart,
    required DateTime segmentEnd,
  }) {
    if (segmentEnd.isBefore(segmentStart)) {
      return 0;
    }

    final days = segmentEnd.difference(segmentStart).inDays + 1;

    return expectedWeeklyWeightChangeKg * days / 7;
  }

  DateTime segmentStart({
    required DateTime monthStart,
    required DateTime planActivatedAt,
    DateTime? accruedThrough,
  }) {
    var start = planActivatedAt.isAfter(monthStart)
        ? planActivatedAt
        : monthStart;

    if (accruedThrough != null) {
      final nextUnaccruedDay = accruedThrough.add(
        const Duration(days: 1),
      );

      if (nextUnaccruedDay.isAfter(start)) {
        start = nextUnaccruedDay;
      }
    }

    return _dateOnly(start);
  }

  double calculateFinalMonthlyTarget({
    required double accruedExpectedChangeKg,
    required double currentExpectedWeeklyWeightChangeKg,
    required DateTime currentPlanActivatedAt,
    required DateTime periodStart,
    required DateTime periodEnd,
    DateTime? accruedThrough,
  }) {
    final currentSegmentStart = segmentStart(
      monthStart: periodStart,
      planActivatedAt: currentPlanActivatedAt,
      accruedThrough: accruedThrough,
    );

    final currentContribution = calculateSegmentContribution(
      expectedWeeklyWeightChangeKg:
      currentExpectedWeeklyWeightChangeKg,
      segmentStart: currentSegmentStart,
      segmentEnd: periodEnd,
    );

    return accruedExpectedChangeKg + currentContribution;
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}