import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

class PremiumMonthlyPlanCard
    extends StatelessWidget {
  final VoidCallback? onTap;

  const PremiumMonthlyPlanCard({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(28),
        child: Container(
          width: double.infinity,
          height: 64,
          padding:
          const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            color: AppColors
                .calendarCompleted
                .withValues(
              alpha: 0.16,
            ),
            borderRadius:
            BorderRadius.circular(28),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.monthly,
                  style: AppTextStyles
                      .titleMedium
                      .copyWith(
                    color: AppColors.homeBrown,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              Text(
                '₺99/ay',
                style: AppTextStyles
                    .bodyMedium
                    .copyWith(
                  color: AppColors.homeBrown,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(width: 7),

              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.homeBrown,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}