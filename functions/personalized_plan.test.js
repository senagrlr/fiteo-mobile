const test = require("node:test");
const assert = require("node:assert/strict");

const {
  buildReviewedPlan,
} = require("./personalized_plan");

const basePreferences = {
  age: 25,
  height: 175,
  weight: 80,
  targetWeight: 72,
  gender: "Male",
  goal: "Lose Weight",
  activityLevel: "Moderately Active",
  nutritionPreference: "Balanced Diet",
  workoutPreference: "Mixed",
};

test("reviewed plan applies negative calorie adjustment", () => {
  const plan = buildReviewedPlan({
    userPreferences: basePreferences,
    currentCalories: 2300,
    adjustmentDeltaKcal: -150,
  });

  assert.ok(plan.calories < 2300);
});

test("reviewed plan applies positive calorie adjustment", () => {
  const plan = buildReviewedPlan({
    userPreferences: basePreferences,
    currentCalories: 1800,
    adjustmentDeltaKcal: 150,
  });

  assert.ok(plan.calories > 1800);
});

test("reviewed plan clamps requested adjustment to minimum 100 kcal", () => {
  const lowDeltaPlan = buildReviewedPlan({
    userPreferences: basePreferences,
    currentCalories: 1900,
    adjustmentDeltaKcal: 20,
  });

  const minimumDeltaPlan = buildReviewedPlan({
    userPreferences: basePreferences,
    currentCalories: 1900,
    adjustmentDeltaKcal: 100,
  });

  assert.equal(lowDeltaPlan.calories, minimumDeltaPlan.calories);
});

test("reviewed plan clamps requested adjustment to maximum 200 kcal", () => {
  const highDeltaPlan = buildReviewedPlan({
    userPreferences: basePreferences,
    currentCalories: 1900,
    adjustmentDeltaKcal: 500,
  });

  const maximumDeltaPlan = buildReviewedPlan({
    userPreferences: basePreferences,
    currentCalories: 1900,
    adjustmentDeltaKcal: 200,
  });

  assert.equal(highDeltaPlan.calories, maximumDeltaPlan.calories);
});

test("reviewed plan calories stay inside backend safety range", () => {
  const plan = buildReviewedPlan({
    userPreferences: basePreferences,
    currentCalories: 5000,
    adjustmentDeltaKcal: 200,
  });

  assert.ok(plan.calories >= plan.safetyRange.minCalories);
  assert.ok(plan.calories <= plan.safetyRange.maxCalories);
});

test("reviewed plan calories are rounded to nearest five", () => {
  const plan = buildReviewedPlan({
    userPreferences: basePreferences,
    currentCalories: 1873,
    adjustmentDeltaKcal: -117,
  });

  assert.equal(plan.calories % 5, 0);
});

test("reviewed plan keeps carbohydrate ratio between 35 and 65 percent", () => {
  const plan = buildReviewedPlan({
    userPreferences: basePreferences,
    currentCalories: 1900,
    adjustmentDeltaKcal: -150,
  });

  const carbRatio =
    (plan.carbsGrams * 4) / plan.calories;

  assert.ok(carbRatio >= 0.35);
  assert.ok(carbRatio <= 0.65);
});

test("reviewed plan macro calories stay reasonably aligned with calorie target", () => {
  const plan = buildReviewedPlan({
    userPreferences: basePreferences,
    currentCalories: 1900,
    adjustmentDeltaKcal: -150,
  });

  const macroCalories =
    plan.proteinGrams * 4 +
    plan.carbsGrams * 4 +
    plan.fatsGrams * 9;

  assert.ok(
    Math.abs(macroCalories - plan.calories) <= 15
  );
});

test("reviewed plan expected weekly change is derived from final calories and tdee", () => {
  const plan = buildReviewedPlan({
    userPreferences: basePreferences,
    currentCalories: 1900,
    adjustmentDeltaKcal: -150,
  });

  const expected =
    ((plan.calories - plan.tdee) * 7) / 7700;

  assert.ok(
    Math.abs(
      plan.expectedWeeklyWeightChangeKg - expected
    ) < 0.000001
  );
});

test("reviewed plan returns deterministic output for identical input", () => {
  const first = buildReviewedPlan({
    userPreferences: basePreferences,
    currentCalories: 1900,
    adjustmentDeltaKcal: -150,
  });

  const second = buildReviewedPlan({
    userPreferences: basePreferences,
    currentCalories: 1900,
    adjustmentDeltaKcal: -150,
  });

  assert.deepEqual(first, second);
});

test("reviewed plan rejects zero adjustment", () => {
  assert.throws(
    () => {
      buildReviewedPlan({
        userPreferences: basePreferences,
        currentCalories: 1900,
        adjustmentDeltaKcal: 0,
      });
    },
    /Invalid review plan input/
  );
});

test("reviewed plan rejects invalid current calories", () => {
  assert.throws(
    () => {
      buildReviewedPlan({
        userPreferences: basePreferences,
        currentCalories: 0,
        adjustmentDeltaKcal: -150,
      });
    },
    /Invalid review plan input/
  );
});

test("reviewed plan rejects invalid profile data", () => {
  assert.throws(
    () => {
      buildReviewedPlan({
        userPreferences: {
          ...basePreferences,
          weight: 0,
        },
        currentCalories: 1900,
        adjustmentDeltaKcal: -150,
      });
    },
    /Invalid user preferences/
  );
});

test("high protein profile still respects carbohydrate safety rule", () => {
  const plan = buildReviewedPlan({
    userPreferences: {
      ...basePreferences,
      weight: 100,
      nutritionPreference: "High Protein",
      workoutPreference: "Strength Training",
    },
    currentCalories: 2300,
    adjustmentDeltaKcal: -200,
  });

  const carbRatio =
    (plan.carbsGrams * 4) / plan.calories;

  assert.ok(carbRatio >= 0.35);
  assert.ok(carbRatio <= 0.65);
});