class AiUsageState {
  final int usedCount;
  final int rewardedCredits;

  const AiUsageState({
    required this.usedCount,
    required this.rewardedCredits,
  });

  const AiUsageState.empty()
      : usedCount = 0,
        rewardedCredits = 0;

  int totalAllowed({
    required int baseLimit,
  }) {
    return baseLimit + rewardedCredits;
  }

  int remaining({
    required int baseLimit,
  }) {
    final value =
        totalAllowed(baseLimit: baseLimit) - usedCount;

    return value > 0 ? value : 0;
  }

  bool hasReachedLimit({
    required int baseLimit,
  }) {
    return usedCount >=
        totalAllowed(baseLimit: baseLimit);
  }
}