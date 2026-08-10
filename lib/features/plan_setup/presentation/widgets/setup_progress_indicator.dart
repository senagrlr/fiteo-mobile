import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class SetupProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const SetupProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        totalSteps,
            (index) {
          final isActive = index < currentStep;

          return Expanded(
            child: Container(
              height: 7,
              margin: EdgeInsets.only(
                right: index == totalSteps - 1 ? 0 : 8,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.authButtonGreen
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }
}