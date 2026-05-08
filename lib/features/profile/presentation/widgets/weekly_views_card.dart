import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/home/data/calendar_repository.dart';

class WeeklyViewsCard extends StatefulWidget {
  const WeeklyViewsCard({super.key});

  @override
  State<WeeklyViewsCard> createState() => _WeeklyViewsCardState();
}

class _WeeklyViewsCardState extends State<WeeklyViewsCard> {
  int selectedBarIndex = 2;

  final _calendarRepository = CalendarRepository();

  List<double> values = List.filled(7, 0);
  List<String> days = [];
  int? calorieGoal;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeeklyCalories();
  }

  Future<void> _loadWeeklyCalories() async {
    final today = DateTime.now();
    final start = today.subtract(const Duration(days: 6));

    final weeklyValues = <double>[];
    final weeklyDays = <String>[];

    for (int i = 0; i < 7; i++) {
      final date = start.add(Duration(days: i));
      final data = await _calendarRepository.getDayCalories(date);

      final consumed = data['consumed'] ?? 0;
      final burned = data['burned'] ?? 0;

      weeklyValues.add((consumed - burned).toDouble());
      weeklyDays.add(_dayName(date.weekday));
    }

    if (!mounted) return;

    setState(() {
      values = weeklyValues;
      days = weeklyDays;
      selectedBarIndex = 6;
      isLoading = false;
    });
  }

  String _dayName(int weekday) {
    const names = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return names[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final rawMax = values.isEmpty ? 0.0 : values.reduce(max);
    final double maxValue = rawMax <= 0
        ? 500
        : ((rawMax / 500).ceil() * 500).toDouble();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Weekly Calories',
                  style: TextStyle(
                    color: AppColors.homeBrown,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(color: Color(0xFFE1DED6)),
          const SizedBox(height: 14),

          SizedBox(
            height: 155,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _YAxisLabels(maxValue: maxValue),
                const SizedBox(width: 12),
                Expanded(
                  child: Stack(
                    children: [
                      const _ChartGridLines(),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(values.length, (index) {
                          final barHeight = (values[index] / maxValue) * 82;
                          final isSelected = selectedBarIndex == index;

                          return _BarItem(
                            day: days[index],
                            height: barHeight,
                            value: values[index].toInt(),
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                selectedBarIndex = index;
                              });
                            },
                          );
                        }),
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

  String _formatLabel(double value) {
    if (value == 0) return '0';

    final kValue = value / 1000;

    if (kValue % 1 == 0) {
      return '${kValue.toInt()}k';
    }

    return '${kValue.toStringAsFixed(1)}k';
  }

  @override
  Widget build(BuildContext context) {
    final step = maxValue / 3;

    return SizedBox(
      height: 118,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(_formatLabel(maxValue), style: _axisStyle),
          Text(_formatLabel(step * 2), style: _axisStyle),
          Text(_formatLabel(step), style: _axisStyle),
          const Text('0', style: _axisStyle),
        ],
      ),
    );
  }
}

const TextStyle _axisStyle = TextStyle(
  color: AppColors.homeBrown,
  fontSize: 12,
  fontWeight: FontWeight.w500,
);

class _ChartGridLines extends StatelessWidget {
  const _ChartGridLines();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.only(top: 28, bottom: 26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            4,
                (_) => Container(
              height: 1,
              color: const Color(0xFFE7E3EE),
            ),
          ),
        ),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  final String day;
  final double height;
  final int value;
  final bool isSelected;
  final VoidCallback onTap;

  const _BarItem({
    required this.day,
    required this.height,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 155,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /// 🔥 TOOLTIP FIX
            SizedBox(
              height: 36,
              child: isSelected
                  ? OverflowBox(
                minWidth: 0,
                maxWidth: 80,
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.homeBrown,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    value.toString(),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              )
                  : null,
            ),

            const SizedBox(height: 4),

            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: 18,
              height: height,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.calendarCompleted
                    : AppColors.calendarCompleted.withOpacity(0.35),
                borderRadius: BorderRadius.circular(14),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              day,
              style: TextStyle(
                color: isSelected
                    ? AppColors.homeBrown
                    : const Color(0xFFB1A887),
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