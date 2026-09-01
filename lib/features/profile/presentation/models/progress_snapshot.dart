import 'package:fiteo_myapp/features/profile/data/progress_date_utils.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_day_data.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_month_data.dart';
import 'package:fiteo_myapp/features/profile/data/weight_repository.dart';

class ProgressSnapshot {
  final Map<String, ProgressDayData> days;
  final Map<String, ProgressMonthData> months;
  final DateTime trackingStartDate;
  final List<WeightEntry> weightEntries;
  final double? targetWeightKg;
  final String weightUnit;

  const ProgressSnapshot({
    required this.days,
    required this.months,
    required this.trackingStartDate,
    required this.weightEntries,
    required this.targetWeightKg,
    required this.weightUnit,
  });

  ProgressDayData? day(DateTime date) {
    return days[progressDateKey(date)];
  }

  ProgressMonthData? month(DateTime date) {
    return months[progressMonthKey(date)];
  }
}