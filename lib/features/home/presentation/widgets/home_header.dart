import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

class HomeHeader extends StatelessWidget {
  final int streakDays;

  const HomeHeader({
    super.key,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    final locale =
    Localizations.localeOf(context).toLanguageTag();

    final formattedDate = DateFormat(
      'd MMMM',
      locale,
    ).format(today);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          formattedDate,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.homeBrown,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.homeCardBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                color: AppColors.red,
                size: 18,
              ),

              const SizedBox(width: 6),

              Text(
                context.l10n.streakDays(streakDays),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.homeBrown,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}