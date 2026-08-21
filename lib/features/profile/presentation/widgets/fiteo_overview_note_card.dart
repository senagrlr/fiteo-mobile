import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

class FiteoOverviewNoteCard extends StatelessWidget {
  const FiteoOverviewNoteCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              minHeight: 125,
            ),
            padding: const EdgeInsets.fromLTRB(
              20,
              27,
              20,
              18,
            ),
            decoration: BoxDecoration(
              color:
              AppColors.planTrackingNoteBackground,
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color:
                  AppColors.calendarSummaryShadow,
                  blurRadius: 14,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  '“ ${context.l10n.fiteoOverviewNote}',
                  style:
                  AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '– Fiteo',
                    style:
                    AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: -12,
            left: 21,
            child: Transform.rotate(
              angle: -0.08,
              child: const Icon(
                Icons.attach_file_rounded,
                color: AppColors.planTrackingLabel,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}