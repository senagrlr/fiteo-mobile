import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';

class FieldErrorText extends StatelessWidget {
  final String message;

  const FieldErrorText({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          message,
          style: AppTextStyles.error,
        ),
      ),
    );
  }
}