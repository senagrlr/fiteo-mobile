class OnboardingPageModel {
  final String asset;
  final String? headerTitle;
  final String title;
  final double mediaHeightFactor;
  final bool isLottie;
  final double textSpacing;
  final double topSpacing;
  final double headerSpacing;

  const OnboardingPageModel({
    required this.asset,
    required this.title,
    this.headerTitle,
    this.mediaHeightFactor = 0.42,
    this.isLottie = true,
    this.textSpacing = 0.02,
    this.topSpacing = 0.10,
    this.headerSpacing = 0.05,
  });
}