import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';

import 'package:fiteo_myapp/features/home/data/daily_feedback_service.dart';
import 'package:fiteo_myapp/features/home/data/daily_summary_repository.dart';
import 'package:fiteo_myapp/features/home/data/home_repository.dart';

import 'package:fiteo_myapp/features/home/presentation/widgets/ai_feedback_card.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/calorie_apple_progress.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/calorie_donut_chart.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/daily_macros_card.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/home_header.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/water_progress_card.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/week_calendar_row.dart';

import 'package:fiteo_myapp/features/home/presentation/widgets/home_loading_skeleton.dart';
import 'package:fiteo_myapp/features/home/presentation/coordinators/home_popup_coordinator.dart';

import 'package:fiteo_myapp/features/reports/models/monthly_report_data.dart';
import 'package:fiteo_myapp/features/reports/presentation/popups/monthly_report_popup.dart';
import 'package:fiteo_myapp/features/reports/data/report_repository.dart';
import 'package:fiteo_myapp/features/reports/presentation/mappers/monthly_report_mapper.dart';
import 'package:fiteo_myapp/features/reports/presentation/mappers/weekly_report_mapper.dart';
import 'package:fiteo_myapp/features/reports/presentation/popups/weekly_report_popup.dart';
import 'package:fiteo_myapp/features/membership/data/premium_access_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeRepository _homeRepository =
  HomeRepository();

  final DailyFeedbackService _dailyFeedbackService =
  DailyFeedbackService();

  final DailySummaryRepository _dailySummaryRepository =
  DailySummaryRepository();

  final ReportRepository _reportRepository =
  ReportRepository();

  final WeeklyReportMapper _weeklyReportMapper =
  const WeeklyReportMapper();

  final HomePopupCoordinator _popupCoordinator =
  HomePopupCoordinator();

  final PremiumAccessService _premiumAccessService =
  PremiumAccessService();

  DailyFeedbackResult? dailyFeedback;

  int consumed = 0;
  int burned = 0;
  int net = 0;
  int streakDays = 0;

  int calorieGoal = 2000;

  double proteinConsumed = 0;
  double proteinGoal = 70;

  double fatConsumed = 0;
  double fatGoal = 50;

  double carbsConsumed = 0;
  double carbsGoal = 120;

  int waterConsumedMl = 0;
  int waterGoalMl = 2500;

  bool isLoading = true;

  // ============================================================
  // MONTHLY REPORT TEST
  // ============================================================

  bool _monthlyReportShown = false;
  bool _weeklyReportShown = false;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  // ============================================================
  // HOME DATA
  // ============================================================

  Future<void> _loadData() async {
    try {
      final data =
      await _homeRepository.getTodaySummary();

      final currentPlan =
      await _homeRepository.getCurrentNutritionPlan();

      final streak =
      await _homeRepository.getCurrentStreak();

      final last7Stats =
      await _homeRepository.getLast7DaysStats();

      final todayWater =
      await _dailySummaryRepository
          .getWaterForDay();

      final todayConsumed =
          data['consumed'] as int? ?? 0;

      final todayBurned =
          data['burned'] as int? ?? 0;

      final todayNet =
          data['netCalories'] as int? ?? 0;

      final todayGoal =
          (data['calorieGoal'] as num?)?.round() ??
              (currentPlan['calorieGoal'] as num?)?.round() ??
              2000;

      final todayProtein =
          (data['protein'] as num?)
              ?.toDouble() ??
              0.0;

      final todayFats =
          (data['fats'] as num?)
              ?.toDouble() ??
              0.0;

      final todayCarbs =
          (data['carbs'] as num?)
              ?.toDouble() ??
              0.0;

      final todayProteinGoal =
          (data['proteinGoal'] as num?)?.toDouble() ??
              (currentPlan['proteinGoal'] as num?)?.toDouble() ??
              70.0;

      final todayFatGoal =
          (data['fatGoal'] as num?)?.toDouble() ??
              (currentPlan['fatGoal'] as num?)?.toDouble() ??
              50.0;

      final todayCarbsGoal =
          (data['carbsGoal'] as num?)?.toDouble() ??
              (currentPlan['carbsGoal'] as num?)?.toDouble() ??
              120.0;

      final todayWaterGoal =
          (data['waterGoalMl'] as num?)?.round() ??
              (currentPlan['waterGoalMl'] as num?)?.round() ??
              2500;

      final todayGoalReached =
          data['isGoalReached'] as bool? ??
              todayConsumed >= todayGoal;

      final trackedDaysLast7 =
          (last7Stats['trackedDays']
          as num?)
              ?.toInt() ??
              0;

      final activeDaysLast7 =
          (last7Stats['activeDays']
          as num?)
              ?.toInt() ??
              0;

      final isFirstAppDay =
      await _homeRepository
          .isFirstAppDay();

      final feedback =
      _dailyFeedbackService
          .generateFeedback(
        consumedCalories:
        todayConsumed,
        burnedCalories:
        todayBurned,
        netCalories:
        todayNet,
        calorieGoal:
        todayGoal,
        isGoalReached:
        todayGoalReached,
        streak:
        streak,
        trackedDaysLast7:
        trackedDaysLast7,
        activeDaysLast7:
        activeDaysLast7,
        isFirstAppDay:
        isFirstAppDay,
      );

      if (!mounted) return;

      setState(() {
        consumed = todayConsumed;

        burned = todayBurned;

        net = todayNet;

        calorieGoal = todayGoal;

        streakDays = streak;

        proteinConsumed = todayProtein;
        proteinGoal = todayProteinGoal;

        fatConsumed = todayFats;
        fatGoal = todayFatGoal;

        carbsConsumed = todayCarbs;
        carbsGoal = todayCarbsGoal;

        waterConsumedMl = todayWater;
        waterGoalMl = todayWaterGoal;

        dailyFeedback = feedback;

        isLoading = false;
      });

      final isPremium =
      await _premiumAccessService.isPremium();

      if (!mounted) return;

      if (isPremium) {
        await _tryShowWeeklyReport();

        if (!mounted) return;

        await _tryShowMonthlyReport();

        if (!mounted) return;
      }

      await _popupCoordinator.tryShowWeightCheckIn(
        context,
      );

    } catch (_) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> _tryShowMonthlyReport() async {
    if (_monthlyReportShown || !mounted) {
      return false;
    }

    try {
      final cache =
      await _reportRepository.getMonthlyReport();

      if (!mounted ||
          _monthlyReportShown ||
          cache == null ||
          !cache.isAvailable ||
          cache.dismissed) {
        return false;
      }

      final data =
      const MonthlyReportMapper()
          .toPresentation(
        context: context,
        cache: cache,
      );

      _monthlyReportShown = true;

      await showMonthlyReportPopup(
        context,
        data,
      );

      if (!mounted) {
        return true;
      }

      try {
        await _reportRepository
            .dismissMonthlyReport();
      } catch (_) {
        // Report dismissal failure
        // should not break Home.
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _tryShowWeeklyReport() async {
    if (_weeklyReportShown || !mounted) {
      return false;
    }

    try {
      final cache =
      await _reportRepository.getWeeklyReport();

      if (cache == null ||
          !cache.isAvailable ||
          cache.dismissed ||
          !mounted) {
        return false;
      }

      final data =
      _weeklyReportMapper.toPresentation(
        context: context,
        cache: cache,
      );

      _weeklyReportShown = true;

      await showWeeklyReportPopup(
        context,
        data,
      );

      if (!mounted) {
        return true;
      }

      try {
        await _reportRepository
            .dismissWeeklyReport();
      } catch (_) {
        // Report dismissal failure
        // should not break Home.
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _addWater(
      int amount,
      ) async {
    await _dailySummaryRepository
        .addWater(
      amountMl: amount,
    );

    if (!mounted) return;

    final updatedWater =
    await _dailySummaryRepository
        .getWaterForDay();

    if (!mounted) return;

    setState(() {
      waterConsumedMl =
          updatedWater;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    if (isLoading) {
      return const SystemNavigationBar(
        color: AppColors.generalBackground,
        child: Scaffold(
          backgroundColor: AppColors.generalBackground,
          body: HomeLoadingContent(),
        ),
      );
    }

    return SystemNavigationBar(
      color:
      AppColors.generalBackground,
      child: Scaffold(
        backgroundColor:
        AppColors.generalBackground,
        body: SafeArea(
          child:
          SingleChildScrollView(
            padding:
            const EdgeInsets.fromLTRB(
              24,
              22,
              24,
              50,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                // =================================================
                // HEADER
                // =================================================

                HomeHeader(
                  streakDays:
                  streakDays,
                ),

                const SizedBox(
                  height: 28,
                ),

                // =================================================
                // WEEK
                // =================================================

                const WeekCalendarRow(),

                const SizedBox(
                  height: 30,
                ),

                // =================================================
                // AI FEEDBACK
                // =================================================

                AiFeedbackCard(
                  mainMessage:
                  dailyFeedback
                      ?.mainMessage ??
                      context
                          .l10n
                          .defaultAiFeedbackMessage,

                  suggestion:
                  dailyFeedback
                      ?.suggestion ??
                      context
                          .l10n
                          .defaultAiFeedbackSuggestion,
                ),

                const SizedBox(
                  height: 45,
                ),

                // =================================================
                // CALORIE DONUT
                // =================================================

                Center(
                  child:
                  CalorieDonutChart(
                    consumed:
                    consumed.toDouble(),

                    burned:
                    burned.toDouble(),
                  ),
                ),

                const SizedBox(
                  height: 48,
                ),

                // =================================================
                // CALORIE APPLE
                // =================================================

                CalorieAppleProgress(
                  consumedCalories:
                  consumed,

                  calorieGoal:
                  calorieGoal,
                ),

                const SizedBox(
                  height: 34,
                ),

                // =================================================
                // MACROS + WATER
                // =================================================

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: DailyMacrosCard(
                        protein: proteinConsumed,
                        proteinGoal: proteinGoal,
                        fat: fatConsumed,
                        fatGoal: fatGoal,
                        carbs: carbsConsumed,
                        carbsGoal: carbsGoal,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        height: 170,
                        child: WaterProgressCard(
                          consumedMl: waterConsumedMl,
                          goalMl: waterGoalMl,
                          onWaterAdded: _addWater,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}