import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_data.dart';

class WeeklyDayDetailCard extends StatelessWidget {
  final WeeklyDayData data;

  const WeeklyDayDetailCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        15,
        15,
        18,
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  data.dayLabel,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors
                        .planTrackingSecondaryLabel,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _CheckItem(
                        label: context.l10n.calories,
                        checked:
                        data.caloriesAligned,
                      ),
                    ),

                    Expanded(
                      child: _CheckItem(
                        label: context.l10n.activity,
                        checked:
                        data.activityAligned,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 9),

                Row(
                  children: [
                    Expanded(
                      child: _CheckItem(
                        label: context.l10n.water,
                        checked:
                        data.waterAligned,
                      ),
                    ),

                    Expanded(
                      child: _CheckItem(
                        label: context.l10n.protein,
                        checked:
                        data.proteinAligned,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          ClipPath(
            clipper: _BurstClipper(),
            child: Container(
              // 70 -> 82
              width: 82,
              height: 82,

              color: AppColors.authButtonGreen,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: Text(
                '%${data.alignmentPercent}\n'
                    '${context.l10n.aligned}',
                textAlign: TextAlign.center,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.onPrimary,
                  fontSize: 13,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  final String label;
  final bool? checked;

  const _CheckItem({
    required this.label,
    required this.checked,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          checked == null
              ? Icons.remove_rounded
              : checked!
              ? Icons.check_rounded
              : Icons.close_rounded,
          color: checked == null
              ? AppColors.planTrackingSecondaryLabel
              : checked!
              ? AppColors.calendarCompleted
              : AppColors.red,
          size: 17,
        ),

        const SizedBox(width: 4),

        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.homeBrown,

              // 13 -> 14
              fontSize: 14,

              // Daha belirgin.
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _BurstClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const points = 20;

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final outerRadius =
        math.min(size.width, size.height) / 2;

    final innerRadius =
        outerRadius * 0.86;

    final path = Path();

    for (int i = 0; i < points; i++) {
      final angle =
          (math.pi * 2 * i / points) -
              math.pi / 2;

      final radius =
      i.isEven
          ? outerRadius
          : innerRadius;

      final point = Offset(
        center.dx +
            math.cos(angle) * radius,
        center.dy +
            math.sin(angle) * radius,
      );

      if (i == 0) {
        path.moveTo(
          point.dx,
          point.dy,
        );
      } else {
        path.lineTo(
          point.dx,
          point.dy,
        );
      }
    }

    path.close();

    return path;
  }

  @override
  bool shouldReclip(
      covariant CustomClipper<Path> oldClipper,
      ) {
    return false;
  }
}