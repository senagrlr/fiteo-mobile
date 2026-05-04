import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/widgets/setup_progress_indicator.dart';


class AiPlanLoadingScreen extends StatefulWidget {
  const AiPlanLoadingScreen({super.key});

  @override
  State<AiPlanLoadingScreen> createState() => _AiPlanLoadingScreenState();
}

class _AiPlanLoadingScreenState extends State<AiPlanLoadingScreen> {
  int currentStatusIndex = 0;
  double progress = 0.10;

  Timer? _timer;

  final List<String> statuses = const [
    'Analyzing goals...',
    'Calculating calories...',
    'Building meal suggestions...',
    'Designing workout roadmap...',
  ];

  @override
  void initState() {
    super.initState();
    _startLoadingAnimation();
  }

  void _startLoadingAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (currentStatusIndex < statuses.length - 1) {
        setState(() {
          currentStatusIndex++;
          progress += 0.25;
        });
      } else {
        timer.cancel();

        setState(() {
          progress = 1.0;
        });

        // Buraya sonra plan result/home navigation eklenecek.
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.10),
          child: Column(
            children: [
              const SizedBox(height: 24),

              const SetupProgressIndicator(
                currentStep: 6,
                totalSteps: 6,
              ),

              const SizedBox(height: 70),

              const Text(
                'Creating your personalized AI plan...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  color: AppColors.authText,
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: screenHeight * 0.40,
                child: Lottie.asset(
                  'assets/animations/ai_plan_loading.json',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 32),

              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.white,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.authText,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Text(
                  statuses[currentStatusIndex],
                  key: ValueKey(currentStatusIndex),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onboardingText,
                  ),
                ),
              ),

              const Spacer(),

              const Text(
                'This may take a few seconds.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF5E4A4A),
                ),
              ),

              const SizedBox(height: 34),
            ],
          ),
        ),
      ),
    );
  }
}