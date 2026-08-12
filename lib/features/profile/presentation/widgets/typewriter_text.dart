import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';

class TypewriterText extends StatefulWidget {
  final String text;

  const TypewriterText({
    super.key,
    required this.text,
  });

  @override
  State<TypewriterText> createState() =>
      _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String visibleText = '';
  int index = 0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void didUpdateWidget(
      covariant TypewriterText oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text) {
      _restartTyping();
    }
  }

  void _startTyping() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(milliseconds: 40),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (index < widget.text.length) {
          setState(() {
            visibleText += widget.text[index];
            index++;
          });
        } else {
          timer.cancel();
        }
      },
    );
  }

  void _restartTyping() {
    _timer?.cancel();

    setState(() {
      visibleText = '';
      index = 0;
    });

    _startTyping();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      visibleText,
      style: AppTextStyles.titleMedium.copyWith(
        color: AppColors.homeBrown,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}