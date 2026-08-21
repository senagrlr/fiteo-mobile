import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

class DailyMacrosCard extends StatelessWidget {
  const DailyMacrosCard({
    super.key,
    required this.protein,
    required this.proteinGoal,
    required this.fat,
    required this.fatGoal,
    required this.carbs,
    required this.carbsGoal,
  });

  final double protein;
  final double proteinGoal;

  final double fat;
  final double fatGoal;

  final double carbs;
  final double carbsGoal;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 170,
      ),
      padding: const EdgeInsets.fromLTRB(
        14,
        14,
        12,
        13,
      ),
      decoration: BoxDecoration(
        color: AppColors.dailyGoalCardBackground,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.todaysMacros,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.dailyGoalText,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              height: 1,
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 15),

          MacroProgressBar(
            label: context.l10n.protein,
            consumed: protein,
            goal: proteinGoal,
            color: AppColors.proteinProgress,
          ),

          const SizedBox(height: 14),

          MacroProgressBar(
            label: context.l10n.fat,
            consumed: fat,
            goal: fatGoal,
            color: AppColors.fatProgress,
          ),

          const SizedBox(height: 14),

          MacroProgressBar(
            label: context.l10n.carbs,
            consumed: carbs,
            goal: carbsGoal,
            color: AppColors.carbsProgress,
          ),
        ],
      ),
    );
  }
}

class MacroProgressBar extends StatelessWidget {
  const MacroProgressBar({
    super.key,
    required this.label,
    required this.consumed,
    required this.goal,
    required this.color,
  });

  final String label;
  final double consumed;
  final double goal;
  final Color color;

  double get progress {
    if (goal <= 0) return 0;

    return (consumed / goal).clamp(
      0.0,
      1.0,
    );
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }

  void _showGoal(BuildContext context,) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            24,
            18,
            24,
            32,
          ),
          decoration: const BoxDecoration(
            color: AppColors.bottomSheetBackground,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.bottomSheetHandle,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 22),

                Text(
                  context.l10n.macroGoalTitle(
                    label,
                  ),
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.dailyGoalText,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  '${_formatNumber(consumed)} g / '
                      '${_formatNumber(goal)} g',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.bottomSheetSecondaryText,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 18),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 12,
                    backgroundColor:
                    AppColors.macroProgressBackground,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(
                      color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showGoal(context),
      borderRadius: BorderRadius.circular(10),
      child: Row(
        children: [
          SizedBox(
            width: 78,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 14,
                backgroundColor:
                AppColors.macroProgressBackground,
                valueColor:
                AlwaysStoppedAnimation<Color>(
                  color,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                '${_formatNumber(consumed)}g $label',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.homeSecondaryValue,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}