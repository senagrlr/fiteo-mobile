import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';

class AdRewardBanner extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const AdRewardBanner({
    super.key,
    required this.onTap,
    this.text = 'Reklam izleyerek 1 hak kazanın',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 18,
        bottom: 26,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: AppColors.textMuted,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.ondemand_video_outlined,
                color: AppColors.surfacePrimary,
                size: 15,
              ),
            ),

            const SizedBox(width: 14),

            Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.planTrackingSecondaryLabel,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}