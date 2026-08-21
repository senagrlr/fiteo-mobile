import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

import 'package:fiteo_myapp/features/meals/domain/models/barcode_food_data.dart';

class BarcodeProductResultCard
    extends StatelessWidget {
  final BarcodeFoodData data;
  final VoidCallback onAdd;

  const BarcodeProductResultCard({
    super.key,
    required this.data,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        24,
        18,
        24,
        24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfacePrimary,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 5,
              decoration: BoxDecoration(
                color:
                AppColors.homeCardBackground,
                borderRadius:
                BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 18),

            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color:
                AppColors.homeCardBackground,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.qr_code_2_rounded,
                color: AppColors.calendarCompleted,
                size: 28,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              data.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
              AppTextStyles.titleLarge.copyWith(
                color: AppColors.homeBrown,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              '${context.l10n.barcodeNumber}: '
                  '${data.barcode}',
              textAlign: TextAlign.center,
              style:
              AppTextStyles.bodySmall.copyWith(
                color: AppColors
                    .planTrackingSecondaryLabel,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 22),

            Row(
              children: [
                Expanded(
                  child: _NutritionBox(
                    title:
                    context.l10n.calories,
                    value:
                    '${data.calories} kcal',
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _NutritionBox(
                    title:
                    context.l10n.protein,
                    value:
                    '${data.protein} g',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _NutritionBox(
                    title:
                    context.l10n.fats,
                    value:
                    '${data.fats} g',
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _NutritionBox(
                    title:
                    context.l10n.carbs,
                    value:
                    '${data.carbs} g',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: 210,
              height: 48,
              child: ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor:
                  AppColors.calendarCompleted,
                  foregroundColor:
                  AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  context.l10n.addScannedFood,
                  style: AppTextStyles
                      .labelMedium
                      .copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutritionBox extends StatelessWidget {
  final String title;
  final String value;

  const _NutritionBox({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 67,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.homeCardBackground,
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            style:
            AppTextStyles.bodySmall.copyWith(
              color: AppColors
                  .planTrackingSecondaryLabel,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            maxLines: 1,
            style:
            AppTextStyles.labelMedium.copyWith(
              color: AppColors.homeBrown,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}