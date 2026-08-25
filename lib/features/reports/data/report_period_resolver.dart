class ReportPeriod {
  final DateTime calendarStart;
  final DateTime calendarEnd;

  final DateTime effectiveStart;
  final DateTime effectiveEnd;

  const ReportPeriod({
    required this.calendarStart,
    required this.calendarEnd,
    required this.effectiveStart,
    required this.effectiveEnd,
  });

  int get eligibleDays {
    if (effectiveEnd.isBefore(effectiveStart)) {
      return 0;
    }

    return effectiveEnd.difference(effectiveStart).inDays + 1;
  }
}

class ReportPeriodResolver {
  const ReportPeriodResolver();

  ReportPeriod weekly({
    required DateTime periodEnd,
    required DateTime userStartedAt,
  }) {
    final end = _dateOnly(periodEnd);

    final start = end.subtract(
      Duration(days: end.weekday - DateTime.monday),
    );

    final effectiveStart = _laterDate(
      start,
      _dateOnly(userStartedAt),
    );

    return ReportPeriod(
      calendarStart: start,
      calendarEnd: end,
      effectiveStart: effectiveStart,
      effectiveEnd: end,
    );
  }

  ReportPeriod monthly({
    required int year,
    required int month,
    required DateTime userStartedAt,
  }) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0);

    final effectiveStart = _laterDate(
      start,
      _dateOnly(userStartedAt),
    );

    return ReportPeriod(
      calendarStart: start,
      calendarEnd: end,
      effectiveStart: effectiveStart,
      effectiveEnd: end,
    );
  }

  DateTime _laterDate(DateTime a, DateTime b) {
    return a.isAfter(b) ? a : b;
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}