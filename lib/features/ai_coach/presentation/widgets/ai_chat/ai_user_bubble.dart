import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';

class AiUserBubble extends StatelessWidget {
  final String text;

  const AiUserBubble({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 270,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.homeBrown,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodyMedium.copyWith(
          color: Colors.white,
          fontSize: 14,
          height: 1.4,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}