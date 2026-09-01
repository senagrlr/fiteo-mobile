import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/overview_achievement.dart';

class UniqueFeaturesCard extends StatefulWidget {
  final List<OverviewAchievement> achievements;

  const UniqueFeaturesCard({
    super.key,
    required this.achievements,
  });

  @override
  State<UniqueFeaturesCard> createState() => _UniqueFeaturesCardState();
}

class _UniqueFeaturesCardState extends State<UniqueFeaturesCard> {
  int? _activeBubbleIndex;
  Timer? _bubbleTimer;

  @override
  void dispose() {
    _bubbleTimer?.cancel();
    super.dispose();
  }

  void _toggleBubble(int index) {
    _bubbleTimer?.cancel();

    if (_activeBubbleIndex == index) {
      setState(() {
        _activeBubbleIndex = null;
      });
      return;
    }

    setState(() {
      _activeBubbleIndex = index;
    });

    _bubbleTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted || _activeBubbleIndex != index) return;

      setState(() {
        _activeBubbleIndex = null;
      });
    });
  }

  String _title(BuildContext context, OverviewAchievementType type) {
    switch (type) {
      case OverviewAchievementType.longestStreak:
        return context.l10n.achievementLongestStreak;
      case OverviewAchievementType.bestProtein:
        return context.l10n.achievementBestProtein;
      case OverviewAchievementType.mostActiveDay:
        return context.l10n.achievementMostActiveDay;
      case OverviewAchievementType.hydrationHero:
        return context.l10n.achievementHydrationHero;
      case OverviewAchievementType.nutritionPro:
        return context.l10n.achievementNutritionPro;
      case OverviewAchievementType.balancedDays:
        return context.l10n.achievementBalancedDays;
      case OverviewAchievementType.activeChampion:
        return context.l10n.achievementActiveChampion;
      case OverviewAchievementType.goalKeeper:
        return context.l10n.achievementGoalKeeper;
      case OverviewAchievementType.calorieCompass:
        return context.l10n.achievementCalorieCompass;
      case OverviewAchievementType.hydrationStreak:
        return context.l10n.achievementHydrationStreak;
    }
  }

  String _description(BuildContext context, OverviewAchievementType type) {
    switch (type) {
      case OverviewAchievementType.longestStreak:
        return context.l10n.achievementLongestStreakDescription;
      case OverviewAchievementType.bestProtein:
        return context.l10n.achievementBestProteinDescription;
      case OverviewAchievementType.mostActiveDay:
        return context.l10n.achievementMostActiveDayDescription;
      case OverviewAchievementType.hydrationHero:
        return context.l10n.achievementHydrationHeroDescription;
      case OverviewAchievementType.nutritionPro:
        return context.l10n.achievementNutritionProDescription;
      case OverviewAchievementType.balancedDays:
        return context.l10n.achievementBalancedDaysDescription;
      case OverviewAchievementType.activeChampion:
        return context.l10n.achievementActiveChampionDescription;
      case OverviewAchievementType.goalKeeper:
        return context.l10n.achievementGoalKeeperDescription;
      case OverviewAchievementType.calorieCompass:
        return context.l10n.achievementCalorieCompassDescription;
      case OverviewAchievementType.hydrationStreak:
        return context.l10n.achievementHydrationStreakDescription;
    }
  }

  String _badgeText(BuildContext context, OverviewAchievement achievement) {
    switch (achievement.type) {
      case OverviewAchievementType.longestStreak:
      case OverviewAchievementType.balancedDays:
      case OverviewAchievementType.activeChampion:
      case OverviewAchievementType.hydrationStreak:
        return achievement.value;

      case OverviewAchievementType.bestProtein:
        return '${achievement.value}g';

      case OverviewAchievementType.mostActiveDay:
        return _localizedWeekday(context, achievement.value);

      case OverviewAchievementType.goalKeeper:
        return _localizedGoal(context, achievement.value);

      case OverviewAchievementType.hydrationHero:
      case OverviewAchievementType.nutritionPro:
      case OverviewAchievementType.calorieCompass:
        return achievement.value;
    }
  }

  String _localizedWeekday(BuildContext context, String value) {
    switch (value) {
      case 'monday':
        return context.l10n.monday;
      case 'tuesday':
        return context.l10n.tuesday;
      case 'wednesday':
        return context.l10n.wednesday;
      case 'thursday':
        return context.l10n.thursday;
      case 'friday':
        return context.l10n.friday;
      case 'saturday':
        return context.l10n.saturday;
      case 'sunday':
        return context.l10n.sunday;
      default:
        return value;
    }
  }

  String _localizedGoal(BuildContext context, String value) {
    switch (value) {
      case 'calories':
        return context.l10n.calories;
      case 'protein':
        return context.l10n.protein;
      case 'carbs':
        return context.l10n.carbs;
      case 'fat':
        return context.l10n.fat;
      case 'water':
        return context.l10n.water;
      default:
        return value;
    }
  }

  Color _badgeColorByIndex(int index) {
    switch (index) {
      case 0:
        return AppColors.planTrackingStreakBadge;
      case 1:
        return AppColors.planTrackingProteinBadge;
      case 2:
        return AppColors.planTrackingActiveDayBadge;
      default:
        return AppColors.planTrackingProteinBadge;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 215,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: AppColors.calendarSummaryCardBackground,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: AppColors.calendarSummaryShadow,
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.yourUniqueFeatures,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.planTrackingLabel,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: widget.achievements.isEmpty
                ? Center(
              child: Text(
                context.l10n.overviewNoAchievements,
                textAlign: TextAlign.center,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.planTrackingSecondaryLabel,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
                : _buildAchievements(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = widget.achievements.length;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(count, (index) {
                  final achievement = widget.achievements[index];
                  final middleItem = count == 3 && index == 1;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: middleItem ? 30 : 0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _toggleBubble(index),
                        child: _UniqueFeatureItem(
                          badgeColor: _badgeColorByIndex(index),
                          badgeText: _badgeText(context, achievement),
                          label: _title(context, achievement.type),
                          fitBadgeText:
                          achievement.type == OverviewAchievementType.mostActiveDay ||
                              achievement.type == OverviewAchievementType.goalKeeper,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            if (_activeBubbleIndex != null)
              _buildBubble(
                context,
                constraints.maxWidth,
                constraints.maxHeight,
                _activeBubbleIndex!,
              ),
          ],
        );
      },
    );
  }

  Widget _buildBubble(
      BuildContext context,
      double availableWidth,
      double availableHeight,
      int index,
      ) {
    const bubbleWidth = 170.0;

    final count = widget.achievements.length;
    final cellWidth = availableWidth / count;
    final targetCenterX = cellWidth * (index + 0.5);

    final unclampedLeft = targetCenterX - bubbleWidth / 2;
    final maxLeft = math.max(0.0, availableWidth - bubbleWidth);
    final left = unclampedLeft.clamp(0.0, maxLeft).toDouble();

    final arrowCenterX = targetCenterX - left;
    final middleItem = count == 3 && index == 1;
    final itemTop = middleItem ? 30.0 : 0.0;

    return Positioned(
      left: left,
      width: bubbleWidth,
      bottom: availableHeight - itemTop + 8,
      child: _AchievementBubble(
        description: _description(
          context,
          widget.achievements[index].type,
        ),
        arrowCenterX: arrowCenterX,
        onTap: () => _toggleBubble(index),
      ),
    );
  }
}

class _AchievementBubble extends StatelessWidget {
  final String description;
  final double arrowCenterX;
  final VoidCallback onTap;

  const _AchievementBubble({
    required this.description,
    required this.arrowCenterX,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.homeBrown,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.calendarSummaryShadow,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 7,
              child: CustomPaint(
                painter: _BubbleArrowPainter(
                  centerX: arrowCenterX,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BubbleArrowPainter extends CustomPainter {
  final double centerX;

  const _BubbleArrowPainter({
    required this.centerX,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final safeCenter = centerX.clamp(8.0, size.width - 8.0).toDouble();
    final paint = Paint()..color = AppColors.homeBrown;

    final path = Path()
      ..moveTo(safeCenter - 7, 0)
      ..lineTo(safeCenter + 7, 0)
      ..lineTo(safeCenter, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BubbleArrowPainter oldDelegate) {
    return oldDelegate.centerX != centerX;
  }
}

class _UniqueFeatureItem extends StatelessWidget {
  final Color badgeColor;
  final String badgeText;
  final String label;
  final bool fitBadgeText;

  const _UniqueFeatureItem({
    required this.badgeColor,
    required this.badgeText,
    required this.label,
    this.fitBadgeText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipPath(
          clipper: _HexagonClipper(),
          child: Container(
            width: 60,
            height: 66,
            color: badgeColor,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: fitBadgeText
                ? FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                badgeText,
                maxLines: 1,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.onPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
                : Text(
              badgeText,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.onPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 9),
        Text(
          label,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.planTrackingSecondaryLabel,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width * 0.5, 0);
    path.lineTo(size.width, size.height * 0.24);
    path.lineTo(size.width, size.height * 0.76);
    path.lineTo(size.width * 0.5, size.height);
    path.lineTo(0, size.height * 0.76);
    path.lineTo(0, size.height * 0.24);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}