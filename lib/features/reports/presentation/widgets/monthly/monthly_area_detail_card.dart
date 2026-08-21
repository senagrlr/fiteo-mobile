import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_data.dart';

class MonthlyAreaDetailCard extends StatelessWidget {
  final MonthlyAreaData data;
  final bool isStrongest;

  const MonthlyAreaDetailCard({
    super.key,
    required this.data,
    required this.isStrongest,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isStrongest
        ? AppColors.calendarCompleted
        : AppColors.red;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style:
                AppTextStyles.titleMedium.copyWith(
                  color: AppColors.homeBrown,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Icon(
                    isStrongest
                        ? Icons.check_rounded
                        : Icons
                        .priority_high_rounded,
                    size: 18,
                    color: statusColor,
                  ),

                  const SizedBox(width: 6),

                  Expanded(
                    child: Text(
                      data.primaryText,
                      style: AppTextStyles
                          .bodyMedium
                          .copyWith(
                        color: AppColors.homeBrown,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 7),

              Text(
                data.secondaryText,
                style:
                AppTextStyles.bodySmall.copyWith(
                  color: AppColors.homeBrown,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 13),

        ClipPath(
          clipper: _MonthlyBadgeClipper(),
          child: Container(
            width: 76,
            height: 76,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            color: isStrongest
                ? AppColors.authButtonGreen
                : AppColors.red.withValues(
              alpha: 0.78,
            ),
            child: Text(
              data.badgeText,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.onPrimary,
                fontSize: 11,
                height: 1.15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MonthlyBadgeClipper
    extends CustomClipper<Path> {
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
        outerRadius * 0.87;

    final path = Path();

    for (int i = 0; i < points; i++) {
      final angle =
          (math.pi * 2 * i / points) -
              math.pi / 2;

      final radius = i.isEven
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