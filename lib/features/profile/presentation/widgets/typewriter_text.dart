import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class TypewriterText extends StatefulWidget {
  final String text;

  const TypewriterText({
    super.key,
    required this.text,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String visibleText = "";
  int index = 0;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (index < widget.text.length) {
        setState(() {
          visibleText += widget.text[index];
          index++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      visibleText,
      style: const TextStyle(
        color: AppColors.homeBrown,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}