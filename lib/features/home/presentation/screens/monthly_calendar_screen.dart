import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/home_header.dart';

class MonthlyCalendarScreen extends StatefulWidget {
  const MonthlyCalendarScreen({super.key});

  @override
  State<MonthlyCalendarScreen> createState() => _MonthlyCalendarScreenState();
}

class _MonthlyCalendarScreenState extends State<MonthlyCalendarScreen> {
  DateTime currentMonth = DateTime(2026, 3);
  int selectedDay = 2;

  final Set<int> trackedDays = {
    2,
    4,
    8,
    12,
    14,
    15,
  };

  final Map<int, DayCalories> dayData = {
    2: DayCalories(consumed: 1850, burned: 420),
    4: DayCalories(consumed: 2100, burned: 350),
    8: DayCalories(consumed: 1600, burned: 280),
    12: DayCalories(consumed: 1950, burned: 500),
    14: DayCalories(consumed: 1750, burned: 300),
    15: DayCalories(consumed: 2050, burned: 310),
  };

  String get monthName {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[currentMonth.month - 1];
  }

  int get daysInMonth {
    return DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
  }

  int get firstWeekdayIndex {
    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    return firstDay.weekday % 7;
  }

  void previousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
      selectedDay = 1;
    });
  }

  void nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
      selectedDay = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedData = dayData[selectedDay];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 18, 26, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.homeBrown,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: HomeHeader(streakDays: 2),
                  ),
                ],
              ),

              const SizedBox(height: 54),

              const Center(
                child: Text(
                  'Monthly calendar',
                  style: TextStyle(
                    color: AppColors.homeBrown,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 36),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: previousMonth,
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Color(0xFFB8BEC4),
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '$monthName ${currentMonth.year}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.homeBrown,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: nextMonth,
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFFB8BEC4),
                            size: 20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _WeekDayText('SAN'),
                        _WeekDayText('MON'),
                        _WeekDayText('TUE'),
                        _WeekDayText('WED'),
                        _WeekDayText('THU'),
                        _WeekDayText('FRI'),
                        _WeekDayText('SAT'),
                      ],
                    ),

                    const SizedBox(height: 12),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: firstWeekdayIndex + daysInMonth,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 6,
                      ),
                      itemBuilder: (context, index) {
                        if (index < firstWeekdayIndex) {
                          return const SizedBox();
                        }

                        final day = index - firstWeekdayIndex + 1;
                        final isTracked = trackedDays.contains(day);
                        final isSelected = selectedDay == day;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDay = day;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isTracked
                                  ? AppColors.calendarCompleted
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(
                                color: AppColors.homeBrown,
                                width: 1.5,
                              )
                                  : null,
                            ),
                            child: Text(
                              '$day',
                              style: TextStyle(
                                color: isTracked
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 42),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
                decoration: BoxDecoration(
                  color: AppColors.homeCardBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date : $selectedDay $monthName ${currentMonth.year}',
                      style: const TextStyle(
                        color: AppColors.homeBrown,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Divider(color: Color(0xFFDCD9D1)),

                    const SizedBox(height: 14),

                    if (selectedData == null)
                      const Text(
                        'No calorie data for this day.',
                        style: TextStyle(
                          color: AppColors.homeBrown,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    else ...[
                      _InfoRow(
                        text:
                        'Calories Consumed: ${selectedData.consumed} kcal',
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        text: 'Calories Burned: ${selectedData.burned} kcal',
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        text:
                        'Net Calories: ${selectedData.netCalories} kcal',
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DayCalories {
  final int consumed;
  final int burned;

  const DayCalories({
    required this.consumed,
    required this.burned,
  });

  int get netCalories => consumed - burned;
}

class _WeekDayText extends StatelessWidget {
  final String text;

  const _WeekDayText(this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFFA9A0A0),
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String text;

  const _InfoRow({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          '✔',
          style: TextStyle(
            color: AppColors.red,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.homeBrown,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}