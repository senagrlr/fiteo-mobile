import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

enum ProgressMetric {
  nutrition,
  water,
  weight,
  workout,
}

enum ProgressRange {
  days7,
  days30,
  days90,
  days365,
}

class ProgressChartData {
  final Color lineColor;
  final List<FlSpot> spots;
  final List<String> bottomLabels;

  final double minY;
  final double maxY;
  final double interval;
  final double targetY;

  final String tooltipUnit;

  const ProgressChartData({
    required this.lineColor,
    required this.spots,
    required this.bottomLabels,
    required this.minY,
    required this.maxY,
    required this.interval,
    required this.targetY,
    required this.tooltipUnit,
  });
}

class ProgressSummaryData {
  final String dateRange;

  final ProgressSummaryItem primaryItem;
  final ProgressSummaryItem bottomLeftItem;
  final ProgressSummaryItem bottomRightItem;

  const ProgressSummaryData({
    required this.dateRange,
    required this.primaryItem,
    required this.bottomLeftItem,
    required this.bottomRightItem,
  });
}

class ProgressSummaryItem {
  final String value;
  final String label;

  const ProgressSummaryItem({
    required this.value,
    required this.label,
  });
}