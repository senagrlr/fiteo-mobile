import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/common_app_bar.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/common/widgets/custom_text_field.dart';
import 'package:fiteo_myapp/features/auth/presentation/screens/verify_email_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ COMMON APP BAR
      appBar: const CommonAppBar(),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 120),

              const Text(
                'Forgot password?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: AppColors.authText,
                ),
              ),

              const SizedBox(height: 30),

              const CustomTextField(
                hintText: 'Mail',
              ),

              const SizedBox(height: 50),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Enter your email address and we’ll send you a link to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF5E4A4A),
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              CustomButton(
                text: 'Send link',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VerifyEmailScreen(),
                    ),
                  );
                },
                backgroundColor: AppColors.authButtonGreen,
                textColor: Colors.white,
                height: 54,
                width: screenWidth * 0.65,
                fontSize: 20,
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}