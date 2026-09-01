import 'package:flutter_test/flutter_test.dart';

import 'package:fiteo_myapp/features/reports/data/report_period_resolver.dart';

void main() {
  const resolver = ReportPeriodResolver();

  group('ReportPeriodResolver', () {
    test(
      'weekly keeps calendar week but clips effective start to user start date',
          () {
        final period = resolver.weekly(
          periodEnd: DateTime(2026, 8, 30),
          userStartedAt: DateTime(2026, 8, 26),
        );

        expect(
          period.calendarStart,
          DateTime(2026, 8, 24),
        );

        expect(
          period.calendarEnd,
          DateTime(2026, 8, 30),
        );

        expect(
          period.effectiveStart,
          DateTime(2026, 8, 26),
        );

        expect(
          period.effectiveEnd,
          DateTime(2026, 8, 30),
        );

        expect(
          period.eligibleDays,
          5,
        );
      },
    );

    test(
      'monthly keeps full calendar month but clips effective start',
          () {
        final period = resolver.monthly(
          year: 2026,
          month: 8,
          userStartedAt: DateTime(2026, 8, 17),
        );

        expect(
          period.calendarStart,
          DateTime(2026, 8, 1),
        );

        expect(
          period.calendarEnd,
          DateTime(2026, 8, 31),
        );

        expect(
          period.effectiveStart,
          DateTime(2026, 8, 17),
        );

        expect(
          period.effectiveEnd,
          DateTime(2026, 8, 31),
        );

        expect(
          period.eligibleDays,
          15,
        );
      },
    );
  });
}