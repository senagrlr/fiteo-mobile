import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/router/app_routes.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';
import 'package:fiteo_myapp/common/widgets/common_app_bar.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/features/auth/data/auth_repository.dart';

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

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
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
      },
    );
  }

  Future<void> _checkEmailVerification() async {
    setState(() {
      _isChecking = true;
    });

    final isVerified =
    await _authRepository.isCurrentUserEmailVerified();

    if (!mounted) return;

    setState(() {
      _isChecking = false;
    });

    if (isVerified) {
      AppSnackbar.showSuccess(
        context,
        context.l10n.emailVerifiedSuccessfully,
      );

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.planSetup,
      );
    } else {
      AppSnackbar.showError(
        context,
        context.l10n.emailNotVerifiedYet,
      );
    }
  }

  Future<void> _resendEmail() async {
    if (!_canResend) return;

    try {
      await _authRepository.sendEmailVerification();

      if (!mounted) return;

      AppSnackbar.showInfo(
        context,
        context.l10n.verificationEmailSentAgain,
      );

      _startResendTimer();
    } catch (_) {
      if (!mounted) return;

      AppSnackbar.showError(
        context,
        context.l10n.verificationEmailCouldNotSend,
      );
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    final secondsStr =
    remainingSeconds.toString().padLeft(2, '0');

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
      appBar: const CommonAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),

              SizedBox(
                width: double.infinity,
                child: Text(
                  context.l10n.verifyEmailTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.displayMedium.copyWith(
                    color: AppColors.authText,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  color: AppColors.onboardingBackground,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/mail_icon.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: Text(
                  context.l10n.verifyEmailDescription,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
              ),

              const Spacer(),

              GestureDetector(
                onTap: _canResend ? _resendEmail : null,
                child: Text(
                  _canResend
                      ? context.l10n.resendEmail
                      : context.l10n.resendEmailWithTime(
                    _formatTime(_secondsLeft),
                  ),
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                    color: _canResend
                        ? AppColors.authText
                        : Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              CustomButton(
                text: _isChecking
                    ? context.l10n.checking
                    : context.l10n.verify,
                onPressed:
                _isChecking ? null : _checkEmailVerification,
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