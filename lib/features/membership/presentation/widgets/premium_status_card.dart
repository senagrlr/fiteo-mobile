import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';

class PremiumStatusCard extends StatelessWidget {
  final String planName;
  final String renewalDate;
  final String price;

  const PremiumStatusCard({
    super.key,
    required this.planName,
    required this.renewalDate,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
      double.infinity,
      padding:
      const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        16,
      ),
      decoration: BoxDecoration(
        color:
        AppColors.surfacePrimary,
        borderRadius:
        BorderRadius.circular(
          24,
        ),
        boxShadow:
        const [
          BoxShadow(
            color: AppColors
                .calendarSummaryShadow,
            blurRadius: 14,
            offset: Offset(
              0,
              5,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            planName,
            style:
            AppTextStyles.titleMedium.copyWith(
              color:
              AppColors.homeBrown,
              fontSize: 18,
              fontWeight:
              FontWeight.w900,
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          Container(
            width: 88,
            height: 1,
            color: AppColors
                .planTrackingSecondaryLabel
                .withValues(
              alpha: 0.30,
            ),
          ),

          const SizedBox(
            height: 9,
          ),

          Text(
            'Yenilenme tarihi',
            style:
            AppTextStyles.bodySmall.copyWith(
              color: AppColors
                  .planTrackingSecondaryLabel,
              fontSize: 12,
              fontWeight:
              FontWeight.w500,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          Text(
            renewalDate,
            style:
            AppTextStyles.bodyMedium.copyWith(
              color:
              AppColors.homeBrown,
              fontSize: 14,
              fontWeight:
              FontWeight.w800,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Align(
            alignment:
            Alignment.centerRight,
            child: Text(
              price,
              style:
              AppTextStyles.bodySmall.copyWith(
                color: AppColors
                    .planTrackingSecondaryLabel,
                fontSize: 15,
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}