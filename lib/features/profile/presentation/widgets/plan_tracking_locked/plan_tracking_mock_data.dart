import 'package:fiteo_myapp/features/profile/presentation/models/overview_achievement.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/overview_stats.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/plan_status.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/plan_tracking_stats.dart';

class PlanTrackingMockData {
  PlanTrackingMockData._();

  static final OverviewStats overview =
  OverviewStats(
    trackingEligibleDays: 30,
    trackedDays: 25,

    successfulGoalChecks: 91,
    totalGoalChecks: 120,

    currentTrackingStreak: 7,
    longestTrackingStreak: 12,

    currentHydrationStreak: 5,
    longestHydrationStreak: 9,

    activeDays: 18,
    totalWorkoutMinutes: 840,

    weekdayWorkoutMinutes: {
      'monday': 120,
      'tuesday': 60,
      'wednesday': 180,
      'thursday': 90,
      'friday': 150,
      'saturday': 160,
      'sunday': 80,
    },

    calorieGoalHitDays: 22,
    proteinGoalHitDays: 25,
    carbsGoalHitDays: 21,
    fatGoalHitDays: 23,
    waterGoalHitDays: 26,
    balancedDays: 19,

    bestProteinAdherence: 98,
    bestProteinValue: 124,

    fiteoScore: 84,

    aiNote:
    'Your consistency has been improving. '
        'Keep maintaining your nutrition, '
        'hydration and activity routine.',
  );

  static const List<OverviewAchievement>
  achievements = [
    OverviewAchievement(
      type:
      OverviewAchievementType.longestStreak,
      strength: 0.92,
      value: '12',
    ),
    OverviewAchievement(
      type:
      OverviewAchievementType.bestProtein,
      strength: 0.86,
      value: '124',
    ),
    OverviewAchievement(
      type:
      OverviewAchievementType.mostActiveDay,
      strength: 0.80,
      value: 'wednesday',
    ),
  ];

  static final PlanTrackingStats plan =
  PlanTrackingStats(
    planActivatedAt:
    DateTime(2026, 7, 20),

    lastProcessedDate:
    DateTime(2026, 9, 1),

    planStartWeight:
    72.0,

    targetWeight:
    65.0,

    weightUnit:
    'kg',

    expectedWeeklyWeightChangeKg:
    -0.5,

    planEligibleDays:
    43,

    calorieTrackedDays:
    36,

    calorieAdherenceSum:
    3096,

    weightEntryCount:
    6,

    latestWeight:
    68.8,

    latestWeightDate:
    DateTime(2026, 8, 24),

    actualWeeklyWeightChangeKg:
    -0.48,

    weightPoints: [
      PlanTrackingWeightPoint(
        date: DateTime(2026, 7, 20),
        weightKg: 72.0,
      ),
      PlanTrackingWeightPoint(
        date: DateTime(2026, 7, 27),
        weightKg: 71.3,
      ),
      PlanTrackingWeightPoint(
        date: DateTime(2026, 8, 3),
        weightKg: 70.7,
      ),
      PlanTrackingWeightPoint(
        date: DateTime(2026, 8, 10),
        weightKg: 70.0,
      ),
      PlanTrackingWeightPoint(
        date: DateTime(2026, 8, 17),
        weightKg: 69.5,
      ),
      PlanTrackingWeightPoint(
        date: DateTime(2026, 8, 24),
        weightKg: 68.8,
      ),
    ],

    progressRatio:
    0.46,

    expectedGoalDate:
    DateTime(2026, 11, 18),

    estimatedGoalDate:
    DateTime(2026, 11, 16),

    projectionDifferenceDays:
    -2,

    planStatus:
    PlanStatus.onTrack,

    aiNote:
    'Your progress is moving close to '
        'the expected pace. Keep your '
        'current routine consistent.',

    aiNoteDate:
    DateTime(2026, 9, 1),

    aiNoteStatus:
    PlanStatus.onTrack.name,

    aiNoteWeightSignature:
    null,
  );
}