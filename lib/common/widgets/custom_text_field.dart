import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;

  // 🔥 YENİ EKLENENLER
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller, // 🔥 eklendi
      onChanged: widget.onChanged,   // 🔥 eklendi
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: AppColors.authText,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: AppColors.onboardingBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 14,
        ),

        // 👇 PASSWORD İSE GÖZ ICON
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.authButtonGreen,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : null,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}