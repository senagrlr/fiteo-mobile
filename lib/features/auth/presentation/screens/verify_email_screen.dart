import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/common_app_bar.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ Common App Bar
      appBar: const CommonAppBar(),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),

              const SizedBox(
                width: double.infinity,
                child: Text(
                  'Verify your email',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: AppColors.authText,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ✅ ICON + BACKGROUND CIRCLE
              Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  color: AppColors.onboardingBackground,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/mail_icon.png', // senin png
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const SizedBox(
                width: double.infinity,
                child: Text(
                  'We’ve sent a verification link to your email address. Please check your inbox and tap the link to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Color(0xFF5E4A4A),
                  ),
                ),
              ),

              const Spacer(),

              GestureDetector(
                onTap: () {
                  // resend logic (ileride bağlanır)
                },
                child: const Text(
                  'Resend Email',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.authText,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              CustomButton(
                text: 'Verify',
                onPressed: () {},
                backgroundColor: AppColors.authButtonGreen,
                textColor: Colors.white,
                height: 56,
                width: screenWidth * 0.72,
                fontSize: 22,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}