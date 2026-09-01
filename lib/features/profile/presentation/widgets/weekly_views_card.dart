import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/home/data/calendar_repository.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/weekly_views_loading_card.dart';

class WeeklyViewsCard extends StatefulWidget {
  final VoidCallback? onArrowTap;

  const WeeklyViewsCard({
    super.key,
    this.onArrowTap,
  });

  @override
  State<WeeklyViewsCard> createState() =>
      _WeeklyViewsCardState();
}

class _WeeklyViewsCardState extends State<WeeklyViewsCard> {
  int selectedBarIndex = 2;

  final _calendarRepository = CalendarRepository();

  List<double> values = List.filled(7, 0.0);
  List<int> weekdays = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeeklyCalories();
  }

  Future<void> _loadWeeklyCalories() async {
    final today = DateTime.now();

    final start = today.subtract(
      const Duration(days: 6),
    );

    final weeklyValues = <double>[];
    final weeklyWeekdays = <int>[];

    for (int i = 0; i < 7; i++) {
      final date = start.add(
        Duration(days: i),
      );

      final data =
      await _calendarRepository.getDayCalories(
        date,
      );

      final consumed = data['consumed'] ?? 0;
      final burned = data['burned'] ?? 0;

      weeklyValues.add(
        (consumed - burned).toDouble(),
      );

      weeklyWeekdays.add(
        date.weekday,
      );
    }

    if (!mounted) return;

    setState(() {
      values = weeklyValues;
      weekdays = weeklyWeekdays;
      selectedBarIndex = 6;
      isLoading = false;
    });
  }

  String _dayName(
      BuildContext context,
      int weekday,
      ) {
    switch (weekday) {
      case DateTime.monday:
        return context.l10n.mondayShort;

      case DateTime.tuesday:
        return context.l10n.tuesdayShort;

      case DateTime.wednesday:
        return context.l10n.wednesdayShort;

      case DateTime.thursday:
        return context.l10n.thursdayShort;

      case DateTime.friday:
        return context.l10n.fridayShort;

      case DateTime.saturday:
        return context.l10n.saturdayShort;

      case DateTime.sunday:
        return context.l10n.sundayShort;

      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const WeeklyViewsLoadingCard();
    }

    final positiveValues = values
        .map(
          (value) => value < 0 ? 0.0 : value,
    )
        .toList();

    final rawMax = positiveValues.isEmpty
        ? 0.0
        : positiveValues.reduce(max);

    final double maxValue = rawMax <= 0
        ? 500
        : ((rawMax / 500).ceil() * 500)
        .toDouble();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        22,
        22,
        22,
        18,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfacePrimary,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.08,
            ),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.weeklyCalories,
                  style:
                  AppTextStyles.titleMedium.copyWith(
                    color: AppColors.homeBrown,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              // Sağ üst ok
              InkWell(
                onTap: widget.onArrowTap,
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 30,
                    color: AppColors.homeBrown,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Divider(
            color: AppColors.weeklyChartDivider,
          ),

          const SizedBox(height: 14),

          SizedBox(
            height: 165,
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.end,
              children: [
                _YAxisLabels(
                  maxValue: maxValue,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Stack(
                    children: [
                      const _ChartGridLines(),

                      LayoutBuilder(
                        builder: (
                            context,
                            constraints,
                            ) {
                          final itemWidth =
                          (constraints.maxWidth /
                              values.length)
                              .clamp(
                            28.0,
                            38.0,
                          );

                          return Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.end,
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: List.generate(
                              values.length,
                                  (index) {
                                final safeValue =
                                values[index] < 0
                                    ? 0.0
                                    : values[index];

                                final barHeight =
                                ((safeValue /
                                    maxValue) *
                                    60)
                                    .clamp(
                                  4.0,
                                  60.0,
                                );

                                final isSelected =
                                    selectedBarIndex ==
                                        index;

                                return _BarItem(
                                  width: itemWidth,
                                  day: _dayName(
                                    context,
                                    weekdays[index],
                                  ),
                                  height: barHeight,
                                  value: values[index]
                                      .toInt(),
                                  isSelected:
                                  isSelected,
                                  onTap: () {
                                    setState(() {
                                      selectedBarIndex =
                                          index;
                                    });
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _YAxisLabels extends StatelessWidget {
  final double maxValue;

  const _YAxisLabels({
    required this.maxValue,
  });

  String _formatLabel(
      double value,
      ) {
    if (value == 0) {
      return '0';
    }

    final kValue = value / 1000;

    if (kValue % 1 == 0) {
      return '${kValue.toInt()}k';
    }

    return '${kValue.toStringAsFixed(1)}k';
  }

  @override
  Widget build(BuildContext context) {
    final step = maxValue / 3;

    final axisStyle =
    AppTextStyles.bodySmall.copyWith(
      color: AppColors.homeSecondaryValue,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    );

    return SizedBox(
      width: 44,
      height: 126,
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            _formatLabel(maxValue),
            style: axisStyle,
          ),
          Text(
            _formatLabel(step * 2),
            style: axisStyle,
          ),
          Text(
            _formatLabel(step),
            style: axisStyle,
          ),
          Text(
            '0',
            style: axisStyle,
          ),
        ],
      ),
    );
  }
}

class _ChartGridLines extends StatelessWidget {
  const _ChartGridLines();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 26,
          bottom: 30,
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: List.generate(
            4,
                (_) => Container(
              height: 1,
              color: AppColors.weeklyChartGridLine,
            ),
          ),
        ),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  final double width;
  final String day;
  final double height;
  final int value;
  final bool isSelected;
  final VoidCallback onTap;

  const _BarItem({
    required this.width,
    required this.day,
    required this.height,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 26,
              child: isSelected
                  ? OverflowBox(
                minWidth: 0,
                maxWidth: 72,
                alignment:
                Alignment.center,
                child: Container(
                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration:
                  BoxDecoration(
                    color:
                    AppColors.homeBrown,
                    borderRadius:
                    BorderRadius
                        .circular(
                      12,
                    ),
                  ),
                  child: Text(
                    value.toString(),
                    maxLines: 1,
                    softWrap: false,
                    overflow:
                    TextOverflow
                        .visible,
                    style:
                    AppTextStyles
                        .bodySmall
                        .copyWith(
                      color: AppColors
                          .onPrimary,
                      fontSize: 11,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                ),
              )
                  : null,
            ),

            const SizedBox(height: 4),

            AnimatedContainer(
              duration: const Duration(
                milliseconds: 250,
              ),
              curve: Curves.easeOut,
              width: 18,
              height: height,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors
                    .calendarCompleted
                    : AppColors
                    .calendarCompleted
                    .withValues(
                  alpha: 0.35,
                ),
                borderRadius:
                BorderRadius.circular(
                  14,
                ),
              ),
            ),

            const SizedBox(height: 4),

            Text(
              day,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style:
              AppTextStyles.bodySmall.copyWith(
                color: isSelected
                    ? AppColors.homeBrown
                    : AppColors
                    .homeSecondaryValue,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}