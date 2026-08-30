import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';
import 'package:fiteo_myapp/features/membership/data/premium_access_service.dart';
import 'package:fiteo_myapp/features/membership/domain/premium_feature.dart';

import 'package:fiteo_myapp/features/profile/data/overview_achievement_calculator.dart';
import 'package:fiteo_myapp/features/profile/data/overview_repository.dart';
import 'package:fiteo_myapp/features/profile/data/plan_tracking_repository.dart';

import 'package:fiteo_myapp/features/profile/presentation/models/overview_achievement.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/overview_stats.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/plan_status.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/plan_tracking_stats.dart';

import 'package:fiteo_myapp/features/profile/presentation/widgets/fiteo_overview_note_card.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/fiteo_score_header.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_review_sheet.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_status_header.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_status_note_card.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_weight_progress_chart.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_weight_summary_card.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/tracking_summary_card.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/unique_features_card.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/overview_loading_skeleton.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_loading_skeleton.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_tracking_locked_content.dart';

class PlanTrackingScreen extends StatefulWidget {
  const PlanTrackingScreen({
    super.key,
  });

  @override
  State<PlanTrackingScreen> createState() =>
      _PlanTrackingScreenState();
}

class _PlanTrackingScreenState
    extends State<PlanTrackingScreen> {
  int selectedTab = 0;

  final PremiumAccessService _premiumAccessService =
  PremiumAccessService();

  bool _isCheckingPremiumAccess = true;
  bool _hasPremiumAccess = false;
  bool _premiumAccessHasError = false;

  final OverviewRepository _overviewRepository =
  OverviewRepository();

  final OverviewAchievementCalculator
  _achievementCalculator =
  const OverviewAchievementCalculator();

  OverviewStats? _overviewStats;

  List<OverviewAchievement> _achievements = const [];

  bool _isOverviewLoading = true;
  bool _overviewHasError = false;

  final PlanTrackingRepository _planTrackingRepository =
  PlanTrackingRepository();

  PlanTrackingStats? _planTrackingStats;

  bool _isPlanLoading = true;
  bool _planHasError = false;

  @override
  void initState() {
    super.initState();

    _initializeScreen();
  }

  void _retryPremiumAccess() {
    setState(() {
      _isCheckingPremiumAccess = true;
      _premiumAccessHasError = false;
    });

    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    try {
      final hasAccess =
      await _premiumAccessService.canAccess(
        PremiumFeature.planTracking,
      );

      if (!mounted) return;

      if (!hasAccess) {
        setState(() {
          _hasPremiumAccess = false;
          _isCheckingPremiumAccess = false;
          _premiumAccessHasError = false;
        });

        return;
      }

      setState(() {
        _hasPremiumAccess = true;
        _isCheckingPremiumAccess = false;
        _premiumAccessHasError = false;
      });

      await Future.wait([
        _loadOverview(),
        _loadPlanTracking(),
      ]);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _hasPremiumAccess = false;
        _isCheckingPremiumAccess = false;
        _premiumAccessHasError = true;
      });
    }
  }

  Future<void> _loadOverview() async {
    try {
      final stats =
      await _overviewRepository.loadOverview();

      final achievements =
      _achievementCalculator.topAchievements(
        stats,
      );

      if (!mounted) return;

      setState(() {
        _overviewStats = stats;
        _achievements = achievements;
        _isOverviewLoading = false;
        _overviewHasError = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isOverviewLoading = false;
        _overviewHasError = true;
      });
    }
  }

  Future<void> _loadPlanTracking() async {
    try {
      final stats =
      await _planTrackingRepository.loadPlanTracking();

      if (!mounted) return;

      setState(() {
        _planTrackingStats = stats;
        _isPlanLoading = false;
        _planHasError = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isPlanLoading = false;
        _planHasError = true;
      });
    }
  }

  void _changeTab(int index) {
    setState(() {
      selectedTab = index;
    });
  }

  Widget _buildScreenBody() {
    if (_isCheckingPremiumAccess) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.homeBrown,
        ),
      );
    }

    if (_premiumAccessHasError) {
      return Center(
        child: IconButton(
          onPressed: _retryPremiumAccess,
          icon: const Icon(
            Icons.refresh_rounded,
            color: AppColors.homeBrown,
          ),
        ),
      );
    }

    if (!_hasPremiumAccess) {
      return Column(
        children: [
          OverviewLoadingHeader(
            selectedTab: selectedTab,
            onTabChanged: _changeTab,
          ),
          Expanded(
            child: PlanTrackingLockedContent(
              selectedTab: selectedTab,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        if (selectedTab == 0)
          _isOverviewLoading
              ? OverviewLoadingHeader(
            selectedTab: selectedTab,
            onTabChanged: _changeTab,
          )
              : FiteoScoreHeader(
            score:
            _overviewStats?.fiteoScore ?? 0,
            selectedTab: selectedTab,
            onTabChanged: _changeTab,
          )
        else
          _isPlanLoading
              ? PlanLoadingHeader(
            selectedTab: selectedTab,
            onTabChanged: _changeTab,
          )
              : PlanStatusHeader(
            status:
            _planTrackingStats?.planStatus ??
                PlanStatus.notEnoughData,
            selectedTab: selectedTab,
            onTabChanged: _changeTab,
          ),

        Expanded(
          child: selectedTab == 0
              ? _buildOverviewContent()
              : _buildPlanContent(),
        ),
      ],
    );
  }

  Widget _buildOverviewContent() {
    if (_isOverviewLoading) {
      return const OverviewLoadingContent();
    }

    if (_overviewHasError || _overviewStats == null) {
      return Center(
        child: IconButton(
          onPressed: () {
            setState(() {
              _isOverviewLoading = true;
              _overviewHasError = false;
            });

            _loadOverview();
          },
          icon: const Icon(
            Icons.refresh_rounded,
            color: AppColors.homeBrown,
          ),
        ),
      );
    }

    return _OverviewContent(
      stats: _overviewStats!,
      achievements: _achievements,
    );
  }

  Widget _buildPlanContent() {
    if (_isPlanLoading) {
      return const PlanLoadingContent();
    }

    if (_planHasError || _planTrackingStats == null) {
      return Center(
        child: IconButton(
          onPressed: () {
            setState(() {
              _isPlanLoading = true;
              _planHasError = false;
            });

            _loadPlanTracking();
          },
          icon: const Icon(
            Icons.refresh_rounded,
            color: AppColors.homeBrown,
          ),
        ),
      );
    }

    return _PlanContent(
      stats: _planTrackingStats!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SystemNavigationBar(
      color: AppColors.surfacePrimary,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor:
          AppColors.planTrackingHeaderBackground,
          statusBarIconBrightness:
          Brightness.dark,
          statusBarBrightness:
          Brightness.light,
        ),
        child: Scaffold(
          backgroundColor:
          AppColors.surfacePrimary,
          extendBodyBehindAppBar: true,
          body: _buildScreenBody(),
        ),
      ),
    );
  }
}

class _OverviewContent extends StatelessWidget {
  final OverviewStats stats;
  final List<OverviewAchievement> achievements;

  const _OverviewContent({
    required this.stats,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      physics:
      const ClampingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        screenWidth * 0.07,
        26,
        screenWidth * 0.07,
        45,
      ),
      child: Column(
        children: [
          TrackingSummaryCard(
            trackingConsistency:
            stats.trackingConsistency.round(),
            goalAchievement:
            stats.goalAchievement.round(),
          ),

          const SizedBox(height: 24),

          UniqueFeaturesCard(
            achievements: achievements,
          ),

          const SizedBox(height: 30),

          const FiteoOverviewNoteCard(),
        ],
      ),
    );
  }
}

class _PlanContent extends StatelessWidget {
  final PlanTrackingStats stats;

  const _PlanContent({
    required this.stats,
  });

  void _openPlanReviewSheet(
      BuildContext context,
      ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor:
      Colors.transparent,
      barrierColor:
      Colors.black.withValues(
        alpha: 0.26,
      ),
      isDismissible: true,
      enableDrag: true,
      builder: (sheetContext) {
        return PlanReviewSheet(
          previousPlan:
          const PlanNutritionTargets(
            calories: 1630,
            protein: 120,
            carbs: 180,
            fats: 55,
            waterLiters: 2.0,
          ),
          newPlan:
          const PlanNutritionTargets(
            calories: 1500,
            protein: 130,
            carbs: 160,
            fats: 50,
            waterLiters: 2.3,
          ),
          onSavePlan: () {
            Navigator.pop(
              sheetContext,
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  String _formatShortMonth(
      BuildContext context,
      DateTime date,
      ) {
    final locale =
    Localizations.localeOf(context)
        .toLanguageTag();

    return DateFormat.MMM(locale).format(date);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      physics:
      const ClampingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        screenWidth * 0.07,
        26,
        screenWidth * 0.07,
        45,
      ),
      child: Column(
        children: [
          PlanWeightSummaryCard(
            startWeight:
            stats.planStartWeight,
            startDate:
            _formatDate(
              stats.planActivatedAt,
            ),
            reachDay:
            stats.estimatedGoalDate?.day ?? 0,
            reachMonth:
            stats.estimatedGoalDate == null
                ? '-'
                : _formatShortMonth(
              context,
              stats.estimatedGoalDate!,
            ),
            isProjectionGood:
            stats.projectionDifferenceDays ==
                null
                ? null
                : stats.projectionDifferenceDays! <=
                -3
                ? true
                : stats.projectionDifferenceDays! >=
                3
                ? false
                : null,
            goalWeight:
            stats.targetWeight,
            weightUnit:
            stats.weightUnit,
          ),

          const SizedBox(height: 24),

          PlanWeightProgressChart(
            planActivatedAt: stats.planActivatedAt,
            expectedGoalDate: stats.expectedGoalDate,
            planStartWeight: stats.planStartWeight,
            targetWeight: stats.targetWeight,
            weightPoints: stats.weightPoints,
            weightUnit: stats.weightUnit,
          ),

          const SizedBox(height: 30),

          PlanStatusNoteCard(
            status: stats.planStatus,
            estimatedGoalDate:
            stats.estimatedGoalDate == null
                ? '-'
                : '${stats.estimatedGoalDate!.day} '
                '${_formatShortMonth(
              context,
              stats.estimatedGoalDate!,
            )} '
                '${stats.estimatedGoalDate!.year}',
            onReviewPlan: () {
              _openPlanReviewSheet(
                context,
              );
            },
          ),
        ],
      ),
    );
  }
}