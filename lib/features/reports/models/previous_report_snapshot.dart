import 'package:fiteo_myapp/features/reports/models/report_comparison_basis.dart';

class PreviousReportSnapshot {
  final int score;
  final ReportComparisonBasis comparisonBasis;

  const PreviousReportSnapshot({
    required this.score,
    required this.comparisonBasis,
  });
}