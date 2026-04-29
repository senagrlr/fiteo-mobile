import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/onboarding/presentation/models/onboarding_page_model.dart';
import 'package:fiteo_myapp/features/onboarding/presentation/widgets/onboarding_indicator.dart';
import 'package:fiteo_myapp/features/onboarding/presentation/widgets/onboarding_page_item.dart';
import 'package:fiteo_myapp/features/auth/presentation/screens/sign_up_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingPageModel> _pages = const [
    OnboardingPageModel(
      asset: 'assets/animations/onboarding_1.json',
      title: 'A new you begins here but\nstaying motivated isn’t\nalways easy.',
      mediaHeightFactor: 0.50,
      isLottie: true,
    ),
    OnboardingPageModel(
      asset: 'assets/animations/onboarding_2.json',
      title: 'You want to live healthier but tracking can be overwhelming.',
      mediaHeightFactor: 0.30,
      isLottie: true,
      textSpacing: 0.05,
      topSpacing: 0.250,
    ),
    OnboardingPageModel(
      asset: 'assets/animations/onboarding_3.json',
      title: 'What if you had an AI coach that makes this journey easier for you?',
      mediaHeightFactor: 0.56,
      textSpacing: 0,
      topSpacing: 0.070,
      isLottie: true,
    ),
    OnboardingPageModel(
      asset: 'assets/images/onboarding_3.png',
      headerTitle: 'Meet Fiteo',
      title: 'Personalized nutrition,\nworkouts,\nand an AI-powered coach\nall in one app.',
      mediaHeightFactor: 0.44,
      isLottie: false,
      headerSpacing: 0.005,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return OnboardingPageItem(page: _pages[index]);
              },
            ),
            if (_currentIndex == 3)
              Positioned(
                top: 16,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onboardingText,
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: screenHeight * 0.05,
              right: screenWidth * 0.10,
              child: OnboardingIndicator(
                currentIndex: _currentIndex,
                itemCount: _pages.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}