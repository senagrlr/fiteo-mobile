import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';

class ReportHeader extends StatelessWidget {
  final String title;
  final String dateRange;
  final VoidCallback onClose;

  const ReportHeader({
    super.key,
    required this.title,
    required this.dateRange,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // =====================================================
          // TITLE + DATE
          // =====================================================

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 58,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.homeBrown,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  dateRange,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color:
                    AppColors.planTrackingSecondaryLabel,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // =====================================================
          // CLOSE BUTTON
          // =====================================================

          Positioned(
            left: 0,
            top: 7,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onClose,
                customBorder: const CircleBorder(),
                child: const SizedBox(
                  width: 42,
                  height: 42,
                  child: Center(
                    child: Icon(
                      Icons.close_rounded,
                      color: AppColors.homeBrown,
                      size: 29,
                      weight: 700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}