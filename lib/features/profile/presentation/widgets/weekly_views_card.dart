import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class WeeklyViewsCard extends StatefulWidget {
  const WeeklyViewsCard({super.key});

  @override
  State<WeeklyViewsCard> createState() => _WeeklyViewsCardState();
}

class _WeeklyViewsCardState extends State<WeeklyViewsCard> {
  int selectedBarIndex = 2;
  String selectedWeek = '15–21 March';

  final List<String> weeks = const [
    '1–7 March',
    '8–14 March',
    '15–21 March',
    '22–28 March',
  ];

  final List<double> values = const [
    1600,
    700,
    1740,
    1000,
    2450,
    550,
    1500,
  ];

  final List<String> days = const [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN',
  ];

  @override
  Widget build(BuildContext context) {
    final maxValue = values.reduce(max);

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
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Weekly Calories',
                  style: TextStyle(
                    color: AppColors.homeBrown,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.homeCardBackground,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedWeek,
                    dropdownColor: AppColors.homeCardBackground,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: AppColors.homeBrown,
                    ),
                    style: const TextStyle(
                      color: AppColors.homeBrown,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    items: weeks.map((week) {
                      return DropdownMenuItem(
                        value: week,
                        child: Text(week),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        selectedWeek = value;
                        selectedBarIndex = 0;
                      });
                    },
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
                const _YAxisLabels(),
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
  const _YAxisLabels();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 118,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('3k', style: _axisStyle),
          Text('2k', style: _axisStyle),
          Text('1k', style: _axisStyle),
          Text('0', style: _axisStyle),
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