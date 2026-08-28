import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

class PremiumAnnualPlanCard extends StatelessWidget {
  final VoidCallback? onTap;

  const PremiumAnnualPlanCard({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius:
            BorderRadius.circular(28),
            child: Container(
              width: double.infinity,
              height: 72,
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
                border: Border.all(
                  color:
                  AppColors.calendarCompleted,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.yearly,
                          style: AppTextStyles
                              .titleMedium
                              .copyWith(
                            color:
                            AppColors.homeBrown,
                            fontSize: 15,
                            fontWeight:
                            FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Row(
                          children: [
                            Text(
                              '₺3310',
                              style: AppTextStyles
                                  .bodySmall
                                  .copyWith(
                                color: AppColors
                                    .planTrackingSecondaryLabel,
                                fontSize: 11,
                                fontWeight:
                                FontWeight.w600,
                                decoration:
                                TextDecoration
                                    .lineThrough,
                              ),
                            ),

                            const SizedBox(width: 7),

                            Text(
                              '₺1659,99',
                              style: AppTextStyles
                                  .bodySmall
                                  .copyWith(
                                color:
                                AppColors.homeBrown,
                                fontSize: 12,
                                fontWeight:
                                FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Text(
                    '₺138,33/ay',
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
        ),

        Positioned(
          right: 0,
          top: -15,
          child: Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius:
              BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: AppColors
                      .calendarSummaryShadow,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              '${context.l10n.popular} 🔥',
              style:
              AppTextStyles.labelSmall.copyWith(
                color: AppColors.homeBrown,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}