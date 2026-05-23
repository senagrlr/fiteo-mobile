import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class AiTypingBubble extends StatefulWidget {
  const AiTypingBubble({super.key});

  @override
  State<AiTypingBubble> createState() => _AiTypingBubbleState();
}

class _AiTypingBubbleState extends State<AiTypingBubble> {
  int dotCount = 1;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(milliseconds: 350),
          (_) {
        if (!mounted) return;

        setState(() {
          dotCount = dotCount == 3 ? 1 : dotCount + 1;
        });
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 270),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.onboardingBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        '.' * dotCount,
        style: const TextStyle(
          color: AppColors.homeBrown,
          fontSize: 22,
          height: 1,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}