import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class CookMessageInput extends StatelessWidget {
  final TextEditingController controller;
  final Future<void> Function() onSend;
  final double horizontalPadding;
  final double bottomPadding;

  const CookMessageInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.horizontalPadding = 28,
    this.bottomPadding = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        8,
        horizontalPadding,
        bottomPadding,
      ),
      child: Container(
        height: 50,
        padding: const EdgeInsets.only(left: 20, right: 6),
        decoration: BoxDecoration(
          color: AppColors.onboardingBackground,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: const TextStyle(
                  color: AppColors.homeBrown,
                  fontSize: 15,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter ingredients',
                  hintStyle: TextStyle(
                    color: AppColors.homeBrown,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),

            IconButton(
              onPressed: onSend,
              icon: const Icon(
                Icons.arrow_forward,
                color: AppColors.homeBrown,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}