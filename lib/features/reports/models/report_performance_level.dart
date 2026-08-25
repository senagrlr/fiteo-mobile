enum ReportPerformanceLevel {
  strong,
  good,
  needsFocus,
  needsImprovement,
}

class ReportPerformanceLevelCalculator {
  const ReportPerformanceLevelCalculator();

  ReportPerformanceLevel fromScore(double value) {
    if (value >= 85) {
      return ReportPerformanceLevel.strong;
    }

    if (value >= 70) {
      return ReportPerformanceLevel.good;
    }

    if (value >= 55) {
      return ReportPerformanceLevel.needsFocus;
    }

    return ReportPerformanceLevel.needsImprovement;
  }
}