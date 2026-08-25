import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_data.dart';

class MonthlyWeightPlanCard extends StatelessWidget {
  final MonthlyWeightPlanData data;

  const MonthlyWeightPlanCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final hasWeightData =
        data.startWeight != null && data.currentWeight != null;

    final change = hasWeightData
        ? data.currentWeight! - data.startWeight!
        : null;

    final lostWeight = change != null && change < 0;
    final unchanged = change == null || change.abs() < 0.01;

    final startWeightText = data.startWeight == null
        ? '-'
        : '${data.startWeight!.toStringAsFixed(1)} kg';

    final currentWeightText = data.currentWeight == null
        ? '-'
        : '${data.currentWeight!.toStringAsFixed(1)} kg';

    final monthlyTargetText = data.monthlyTargetChange == null
        ? '-'
        : '${data.monthlyTargetChange!.toStringAsFixed(1)} kg';

    final progressText = data.progressAchievedPercent == null
        ? '-'
        : '%${data.progressAchievedPercent}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        22,
      ),
      decoration: BoxDecoration(
        color: AppColors.calendarSummaryCardBackground,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: AppColors.calendarSummaryShadow,
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // =====================================================
          // WEIGHT
          // =====================================================

          Row(
            children: [
              Expanded(
                child: _WeightValue(
                  value: startWeightText,
                  label: context.l10n.start,
                ),
              ),

              Expanded(
                child: _WeightValue(
                  value: currentWeightText,
                  label: context.l10n.now,
                  alignRight: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 19),

          // =====================================================
          // MONTHLY WEIGHT CHANGE
          // =====================================================

          Center(
            child: Row(
              mainAxisSize:
              MainAxisSize.min,
              children: [
                if (!unchanged)
                  Icon(
                    lostWeight
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    size: 19,
                    color: lostWeight
                        ? AppColors.calendarCompleted
                        : AppColors.red,
                  ),

                if (!unchanged)
                  const SizedBox(width: 4),

                Text(
                  change == null
                      ? '-'
                      : '${change.abs().toStringAsFixed(1)} kg',
                  style:
                  AppTextStyles.titleMedium.copyWith(
                    color: AppColors.homeBrown,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // =====================================================
          // MONTHLY TARGET
          // =====================================================

          _ValueRow(
            label: context.l10n.monthlyTarget,
            value: monthlyTargetText,
          ),

          const SizedBox(height: 10),

          // =====================================================
          // PROGRESS ACHIEVED
          // =====================================================

          _ValueRow(
            label: context.l10n.progressAchieved,
            value: progressText,
          ),

          const SizedBox(height: 25),

          // =====================================================
          // STATUS
          // =====================================================

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              Container(
                width: 9,
                height: 9,
                decoration:
                const BoxDecoration(
                  color:
                  AppColors.calendarCompleted,
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: Text(
                  data.statusLabel,
                  style:
                  AppTextStyles.titleMedium.copyWith(
                    color: AppColors.homeBrown,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          if (data.statusDescription != null &&
              data.statusDescription!.isNotEmpty) ...[
            const SizedBox(height: 13),

            Text(
              data.statusDescription!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.homeBrown,
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],

          if (data.statusDescription != null &&
              data.statusDescription!.isNotEmpty)
            Text(
              data.statusDescription!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.homeBrown,
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// WEIGHT VALUE
// ============================================================

class _WeightValue extends StatelessWidget {
  final String value;
  final String label;
  final bool alignRight;

  const _WeightValue({
    required this.value,
    required this.label,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style:
          AppTextStyles.titleMedium.copyWith(
            color: AppColors.homeBrown,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          label,
          style:
          AppTextStyles.bodySmall.copyWith(
            color:
            AppColors.planTrackingSecondaryLabel,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// MONTHLY TARGET / PROGRESS ROW
// ============================================================

class _ValueRow extends StatelessWidget {
  final String label;
  final String value;

  const _ValueRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style:
          AppTextStyles.bodyMedium.copyWith(
            color: AppColors.homeBrown,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),

        const Spacer(),

        Text(
          value,
          style:
          AppTextStyles.bodyMedium.copyWith(
            color: AppColors.homeBrown,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}