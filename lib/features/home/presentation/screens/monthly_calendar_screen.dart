import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/home_header.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/calendar_day_summary_card.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/monthly_calendar_widget.dart';
import 'package:fiteo_myapp/features/home/data/calendar_repository.dart';
import 'package:fiteo_myapp/features/home/data/home_repository.dart';

class MonthlyCalendarScreen extends StatefulWidget {
  const MonthlyCalendarScreen({super.key});

  @override
  State<MonthlyCalendarScreen> createState() =>
      _MonthlyCalendarScreenState();
}

class _MonthlyCalendarScreenState
    extends State<MonthlyCalendarScreen> {
  DateTime currentMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );

  int selectedDay = DateTime.now().day;

  final _repo = CalendarRepository();
  final _homeRepository = HomeRepository();

  int streakDays = 0;

  Map<int, DayCalories> dayData = {};
  Set<int> trackedDays = {};

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMonth();
  }

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
    return DateTime(
      currentMonth.year,
      currentMonth.month + 1,
      0,
    ).day;
  }

  int get firstWeekdayIndex {
    final firstDay = DateTime(
      currentMonth.year,
      currentMonth.month,
      1,
    );

    return firstDay.weekday % 7;
  }

  void previousMonth() {
    setState(() {
      currentMonth = DateTime(
        currentMonth.year,
        currentMonth.month - 1,
      );

      selectedDay = 1;
      isLoading = true;
    });

    _loadMonth();
  }

  void nextMonth() {
    setState(() {
      currentMonth = DateTime(
        currentMonth.year,
        currentMonth.month + 1,
      );

      selectedDay = 1;
      isLoading = true;
    });

    _loadMonth();
  }

  Future<void> _loadMonth() async {
    final data = await _repo.getMonthlyData(currentMonth);
    final streak =
    await _homeRepository.getCurrentStreak();

    final map = <int, DayCalories>{};
    final tracked = <int>{};

    data.forEach((day, values) {
      final consumed = (values['consumed'] ?? 0).round();
      final burned = (values['burned'] ?? 0).round();
      final protein = (values['protein'] ?? 0).toDouble();
      final fats = (values['fats'] ?? 0).toDouble();
      final carbs = (values['carbs'] ?? 0).toDouble();
      final netCalories = (values['netCalories'] ?? 0).round();
      final hydration = (values['hydration'] ?? 0).round();

      if (consumed > 0 || burned > 0 || hydration > 0) {
        tracked.add(day);

        map[day] = DayCalories(
          consumed: consumed,
          burned: burned,
          protein: protein,
          fats: fats,
          carbs: carbs,
          netCalories: netCalories,
          hydration: hydration,
        );
      }
    });

    if (!mounted) {
      return;
    }

    setState(() {
      dayData = map;
      trackedDays = tracked;
      streakDays = streak;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final selectedData = dayData[selectedDay];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            26,
            18,
            26,
            110,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.homeBrown,
                      size: 26,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: HomeHeader(
                      streakDays: streakDays,
                    ),
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

              MonthlyCalendarWidget(
                currentMonth: currentMonth,
                selectedDay: selectedDay,
                firstWeekdayIndex:
                firstWeekdayIndex,
                daysInMonth: daysInMonth,
                trackedDays: trackedDays,
                onPreviousMonth: previousMonth,
                onNextMonth: nextMonth,
                onDaySelected: (day) {
                  setState(() {
                    selectedDay = day;
                  });
                },
              ),

              const SizedBox(height: 42),

              CalendarDaySummaryCard(
                selectedDay: selectedDay,
                monthName: monthName,
                year: currentMonth.year,
                consumedCalories: selectedData?.consumed ?? 0,
                burnedCalories: selectedData?.burned ?? 0,
                protein: selectedData?.protein ?? 0,
                fats: selectedData?.fats ?? 0,
                carbs: selectedData?.carbs ?? 0,
                netCalories: selectedData?.netCalories ?? 0,
                hydration: selectedData?.hydration ?? 0,
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

  final double protein;
  final double fats;
  final double carbs;

  final int netCalories;
  final int hydration;

  const DayCalories({
    required this.consumed,
    required this.burned,
    required this.protein,
    required this.fats,
    required this.carbs,
    required this.netCalories,
    required this.hydration,
  });
}