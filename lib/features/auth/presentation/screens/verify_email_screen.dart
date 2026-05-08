import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/router/app_routes.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/common_app_bar.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/features/auth/data/auth_repository.dart';
import 'package:fiteo_myapp/features/auth/utils/auth_messages.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final AuthRepository _authRepository = AuthRepository();

  bool _isChecking = false;
  bool _canResend = false;
  int _secondsLeft = 90;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _secondsLeft = 90;
    });

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 1) {
        timer.cancel();
        setState(() {
          _secondsLeft = 0;
          _canResend = true;
        });
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  Future<void> _checkEmailVerification() async {
    setState(() => _isChecking = true);

    final isVerified = await _authRepository.isCurrentUserEmailVerified();

    if (!mounted) return;

    setState(() => _isChecking = false);

    if (isVerified) {
      AppSnackbar.showSuccess(context, AuthMessages.emailVerifiedSuccessfully);

      Navigator.pushReplacementNamed(context, AppRoutes.planSetup);
    } else {
      AppSnackbar.showError(context, AuthMessages.emailNotVerifiedYet);
    }
  }

  Future<void> _resendEmail() async {
    if (!_canResend) return;

    try {
      await _authRepository.sendEmailVerification();

      if (!mounted) return;

      AppSnackbar.showInfo(context, AuthMessages.verificationEmailSentAgain);

      _startResendTimer();
    } catch (e) {
      if (!mounted) return;

      AppSnackbar.showError(context, AuthMessages.verificationEmailCouldNotSend);
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    final secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$minutes:$secondsStr';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
                onTap: _canResend ? _resendEmail : null,
                child: Text(
                  _canResend ? 'Resend Email' : 'Resend Email (${_formatTime(_secondsLeft)})',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: _canResend
                        ? AppColors.authText
                        : Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              CustomButton(
                text: _isChecking ? 'Checking...' : 'Verify',
                onPressed: _isChecking ? null : _checkEmailVerification,
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