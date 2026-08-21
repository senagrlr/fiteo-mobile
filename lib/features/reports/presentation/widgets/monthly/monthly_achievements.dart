import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_data.dart';

class MonthlyAchievements extends StatelessWidget {
  final List<MonthlyAchievementData> achievements;

  const MonthlyAchievements({
    super.key,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    if (achievements.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.achievements
              .toUpperCase(),
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.calendarCompleted,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 15),

        ...achievements.asMap().entries.map(
              (entry) {
            return Padding(
              padding: EdgeInsets.only(
                bottom:
                entry.key ==
                    achievements.length - 1
                    ? 0
                    : 15,
              ),
              child: _AchievementRow(
                data: entry.value,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _AchievementRow extends StatelessWidget {
  final MonthlyAchievementData data;

  const _AchievementRow({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;

    switch (data.type) {
      case MonthlyAchievementType.trophy:
        icon = Icons.emoji_events_rounded;

      case MonthlyAchievementType.streak:
        icon =
            Icons.local_fire_department_rounded;

      case MonthlyAchievementType.strength:
        icon = Icons.fitness_center_rounded;
    }

    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.calendarCompleted
                .withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.calendarCompleted,
            size: 19,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                data.title.toUpperCase(),
                style:
                AppTextStyles.labelMedium.copyWith(
                  color: AppColors.homeBrown,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                data.description,
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
      ],
    );
  }
}