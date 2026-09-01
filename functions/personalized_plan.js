const OpenAI = require("openai");

function clampNumber(value, min, max) {
  return Math.min(Math.max(value, min), max);
}

function calculateCarbsFromRemainingCalories(calories, proteinGrams, fatsGrams) {
  const remainingCalories = calories - proteinGrams * 4 - fatsGrams * 9;
  return Math.max(0, remainingCalories / 4);
}

function buildPersonalizedPlanBaseline(userPreferences) {
  const age = Number(userPreferences.age);
  const height = Number(userPreferences.height);
  const weight = Number(userPreferences.weight);
  const targetWeight = Number(userPreferences.targetWeight);

  const gender = String(userPreferences.gender || "");
  const goal = String(userPreferences.goal || "");
  const activityLevel = String(userPreferences.activityLevel || "");
  const nutritionPreference = String(userPreferences.nutritionPreference || "");
  const workoutPreference = String(userPreferences.workoutPreference || "");

  if (
    !Number.isFinite(age) ||
    !Number.isFinite(height) ||
    !Number.isFinite(weight) ||
    age <= 0 ||
    height <= 0 ||
    weight <= 0
  ) {
    throw new Error("Invalid user preferences");
  }

  const isMale = gender.toLowerCase() === "male";

  const bmr = isMale
    ? 10 * weight + 6.25 * height - 5 * age + 5
    : 10 * weight + 6.25 * height - 5 * age - 161;

  const activityMultipliers = {
    "Sedentary": 1.2,
    "Lightly Active": 1.375,
    "Moderately Active": 1.55,
    "Very Active": 1.725,
  };

  const activityMultiplier = activityMultipliers[activityLevel];

  if (!activityMultiplier) {
    throw new Error("Invalid activity level");
  }

  const tdee = bmr * activityMultiplier;

  let calorieMin = tdee * 0.95;
  let calorieCenter = tdee;
  let calorieMax = tdee * 1.05;

  if (goal === "Lose Weight") {
    calorieMin = tdee * 0.80;
    calorieCenter = tdee * 0.825;
    calorieMax = tdee * 0.85;
  } else if (goal === "Build Muscle") {
    calorieMin = tdee * 1.05;
    calorieCenter = tdee * 1.075;
    calorieMax = tdee * 1.10;
  }

  calorieMin = clampNumber(calorieMin, 1200, 4000);
  calorieCenter = clampNumber(calorieCenter, 1200, 4000);
  calorieMax = clampNumber(calorieMax, 1200, 4000);

  let proteinPerKgMin = 1.4;
  let proteinPerKgMax = 1.8;

  if (goal === "Build Muscle" || workoutPreference === "Strength Training") {
    proteinPerKgMin = Math.max(proteinPerKgMin, 1.6);
    proteinPerKgMax = Math.max(proteinPerKgMax, 2.0);
  }

  if (nutritionPreference === "High Protein") {
    proteinPerKgMin = Math.max(proteinPerKgMin, 1.8);
    proteinPerKgMax = Math.max(proteinPerKgMax, 2.0);
  }

  const proteinMin = weight * proteinPerKgMin;
  const proteinMax = weight * proteinPerKgMax;
  const proteinCenter = (proteinMin + proteinMax) / 2;

  const fatMin = (calorieCenter * 0.20) / 9;
  const fatMax = (calorieCenter * 0.35) / 9;
  const fatCenter = (fatMin + fatMax) / 2;

  const baselineCarbs = calculateCarbsFromRemainingCalories(
    calorieCenter,
    proteinCenter,
    fatCenter
  );

  const waterCenter = clampNumber(weight * 35, 1500, 5000);
  const waterMin = clampNumber(weight * 30, 1500, 5000);
  const waterMax = clampNumber(weight * 40, waterMin, 5000);

  return {
    input: {
      age,
      height,
      weight,
      targetWeight: Number.isFinite(targetWeight) ? targetWeight : null,
      gender,
      goal,
      activityLevel,
      nutritionPreference,
      workoutPreference,
    },

    baseline: {
      bmr: Math.round(bmr),
      tdee: Math.round(tdee),
      calories: Math.round(calorieCenter),
      proteinGrams: Math.round(proteinCenter),
      carbsGrams: Math.round(baselineCarbs),
      fatsGrams: Math.round(fatCenter),
      waterMl: Math.round(waterCenter),
    },

    allowedRanges: {
      calories: {
        min: Math.round(calorieMin),
        max: Math.round(calorieMax),
      },
      proteinGrams: {
        min: Math.round(proteinMin),
        max: Math.round(proteinMax),
      },
      fatsGrams: {
        min: Math.round(fatMin),
        max: Math.round(fatMax),
      },
      waterMl: {
        min: Math.round(waterMin),
        max: Math.round(waterMax),
      },
    },
  };
}

function roundToNearestFiveWithinRange(
  value,
  min,
  max
) {
  const clamped = clampNumber(
    value,
    min,
    max
  );

  let rounded =
      Math.round(clamped / 5) * 5;

  if (rounded < min) {
    rounded =
        Math.ceil(min / 5) * 5;
  }

  if (rounded > max) {
    rounded =
        Math.floor(max / 5) * 5;
  }

  return rounded;
}

function buildReviewedPlan({
  userPreferences,
  currentCalories,
  adjustmentDeltaKcal,
}) {
  const calculation =
      buildPersonalizedPlanBaseline(
        userPreferences
      );

  const current =
      Number(currentCalories);

  const requestedDelta =
      Number(adjustmentDeltaKcal);

  if (
    !Number.isFinite(current) ||
    current <= 0 ||
    !Number.isFinite(requestedDelta) ||
    requestedDelta === 0
  ) {
    throw new Error(
      "Invalid review plan input"
    );
  }

  const safeAdjustment =
      clampNumber(
        Math.abs(requestedDelta),
        100,
        200
      );

  const signedAdjustment =
      requestedDelta < 0
        ? -safeAdjustment
        : safeAdjustment;

  const rawCandidate =
      current + signedAdjustment;

  const calorieMin =
      calculation.allowedRanges
          .calories.min;

  const calorieMax =
      calculation.allowedRanges
          .calories.max;

  const calories =
      roundToNearestFiveWithinRange(
        rawCandidate,
        calorieMin,
        calorieMax
      );

  const proteinMin =
      calculation.allowedRanges
          .proteinGrams.min;

  const proteinMax =
      calculation.allowedRanges
          .proteinGrams.max;

  let protein =
      (proteinMin + proteinMax) / 2;

  const fatMin =
      (calories * 0.20) / 9;

  const fatMax =
      (calories * 0.35) / 9;

  let fats =
      (fatMin + fatMax) / 2;

  let carbs =
      calculateCarbsFromRemainingCalories(
        calories,
        protein,
        fats
      );

  let carbRatio =
      (carbs * 4) / calories;

  if (carbRatio < 0.35) {
    fats = fatMin;

    carbs =
        calculateCarbsFromRemainingCalories(
          calories,
          protein,
          fats
        );

    carbRatio =
        (carbs * 4) / calories;

    if (carbRatio < 0.35) {
      protein = proteinMin;

      carbs =
          calculateCarbsFromRemainingCalories(
            calories,
            protein,
            fats
          );
    }
  } else if (carbRatio > 0.65) {
    fats = fatMax;

    carbs =
        calculateCarbsFromRemainingCalories(
          calories,
          protein,
          fats
        );

    carbRatio =
        (carbs * 4) / calories;

    if (carbRatio > 0.65) {
      protein = proteinMax;

      carbs =
          calculateCarbsFromRemainingCalories(
            calories,
            protein,
            fats
          );
    }
  }

  const water =
      (
        calculation.allowedRanges
            .waterMl.min +
        calculation.allowedRanges
            .waterMl.max
      ) / 2;

  const expectedWeeklyWeightChangeKg =
      (
        (
          calories -
          calculation.baseline.tdee
        ) *
        7
      ) /
      7700;

  return {
    calories,
    proteinGrams:
        Math.round(protein),
    carbsGrams:
        Math.round(carbs),
    fatsGrams:
        Math.round(fats),
    waterMl:
        Math.round(water),
    tdee:
        calculation.baseline.tdee,
    expectedWeeklyWeightChangeKg,
    safetyRange: {
      minCalories: calorieMin,
      maxCalories: calorieMax,
    },
  };
}

function buildPlanFromValues({
  calories,
  proteinGrams,
  fatsGrams,
  waterMl,
  personalizationReason,
  source,
}) {
  const carbsGrams = calculateCarbsFromRemainingCalories(
    calories,
    proteinGrams,
    fatsGrams
  );

  return {
    calories: Math.round(calories),
    proteinGrams: Math.round(proteinGrams),
    carbsGrams: Math.round(carbsGrams),
    fatsGrams: Math.round(fatsGrams),
    waterMl: Math.round(waterMl),
    personalizationReason,
    source,
  };
}

function validateAndBuildAiPlan(selection, calculation, source = "ai") {
  if (!selection) return null;

  const calories = Number(selection.calories);
  const protein = Number(selection.proteinGrams);
  const fats = Number(selection.fatsGrams);
  const water = Number(selection.waterMl);

  if (![calories, protein, fats, water].every(Number.isFinite)) {
    return null;
  }

  const ranges = calculation.allowedRanges;

  if (
    calories < ranges.calories.min ||
    calories > ranges.calories.max ||
    protein < ranges.proteinGrams.min ||
    protein > ranges.proteinGrams.max ||
    fats < ranges.fatsGrams.min ||
    fats > ranges.fatsGrams.max ||
    water < ranges.waterMl.min ||
    water > ranges.waterMl.max
  ) {
    return null;
  }

  const plan = buildPlanFromValues({
    calories,
    proteinGrams: protein,
    fatsGrams: fats,
    waterMl: water,
    personalizationReason: String(selection.personalizationReason || "").trim(),
    source,
  });

  const macroCalories =
    plan.proteinGrams * 4 +
    plan.carbsGrams * 4 +
    plan.fatsGrams * 9;

  const calorieDifference = Math.abs(macroCalories - plan.calories);
  const carbRatio = (plan.carbsGrams * 4) / plan.calories;

  if (
    plan.carbsGrams < 0 ||
    calorieDifference > Math.max(120, plan.calories * 0.06) ||
    carbRatio < 0.35 ||
    carbRatio > 0.65
  ) {
    return null;
  }

  return plan;
}

function rebalancePlan(selection, calculation) {
  if (!selection) return null;

  const ranges = calculation.allowedRanges;

  const calories = clampNumber(
    Number(selection.calories),
    ranges.calories.min,
    ranges.calories.max
  );

  const water = clampNumber(
    Number(selection.waterMl),
    ranges.waterMl.min,
    ranges.waterMl.max
  );

  let protein = clampNumber(
    Number(selection.proteinGrams),
    ranges.proteinGrams.min,
    ranges.proteinGrams.max
  );

  let fats = clampNumber(
    Number(selection.fatsGrams),
    ranges.fatsGrams.min,
    ranges.fatsGrams.max
  );

  if (![calories, protein, fats, water].every(Number.isFinite)) {
    return null;
  }

  const baselineProtein = calculation.baseline.proteinGrams;
  const baselineFats = calculation.baseline.fatsGrams;
  const personalizationReason = String(
    selection.personalizationReason || ""
  ).trim();

  for (let attempt = 0; attempt < 6; attempt++) {
    const plan = validateAndBuildAiPlan(
      {
        calories,
        proteinGrams: protein,
        fatsGrams: fats,
        waterMl: water,
        personalizationReason,
      },
      calculation,
      "ai_rebalanced"
    );

    if (plan) return plan;

    protein += (baselineProtein - protein) * 0.5;
    fats += (baselineFats - fats) * 0.5;
  }

  return null;
}

function createGeneratePersonalizedPlanHandler(openaiApiKey) {
  return async (req, res) => {
    try {
      const userPreferences = req.body?.userPreferences;

      if (!userPreferences || typeof userPreferences !== "object") {
        return res.status(400).json({
          error: "Missing user preferences",
        });
      }

      const calculation = buildPersonalizedPlanBaseline(userPreferences);

      const fallbackPlan = buildPlanFromValues({
        calories: calculation.baseline.calories,
        proteinGrams: calculation.baseline.proteinGrams,
        fatsGrams: calculation.baseline.fatsGrams,
        waterMl: calculation.baseline.waterMl,
        personalizationReason: "Plan created from your profile and goals.",
        source: "baseline",
      });

      const client = new OpenAI({
        apiKey: openaiApiKey.value(),
      });

      let parsedSelection = null;
      let finalPlan = null;

      try {
        const response = await client.responses.create({
          model: "gpt-4o-mini",

          input: [
            {
              role: "system",
              content:
                "You are Fiteo's nutrition plan personalization engine. " +
                "A deterministic backend has already calculated safe baseline targets and allowed ranges. " +
                "Choose only calories, protein, fat, and water inside the provided ranges. " +
                "Do not choose carbohydrate grams; the backend calculates carbohydrates from the remaining calories. " +
                "Use the user's goal, nutrition preference, workout preference, target weight, and activity level only to personalize choices inside the allowed ranges. " +
                "Never output a value outside an allowed range. " +
                "Do not diagnose disease or provide medical treatment. " +
                "Keep personalizationReason to one short sentence.",
            },
            {
              role: "user",
              content:
                "User profile:\n" +
                JSON.stringify(calculation.input) +
                "\n\nBackend baseline:\n" +
                JSON.stringify(calculation.baseline) +
                "\n\nAllowed ranges:\n" +
                JSON.stringify(calculation.allowedRanges) +
                "\n\nChoose the personalized values. " +
                "High Protein, Build Muscle, and Strength Training can justify choosing protein toward the higher end of the allowed range. " +
                "Do not calculate carbohydrates.",
            },
          ],

          text: {
            format: {
              type: "json_schema",
              name: "personalized_nutrition_selection",
              strict: true,
              schema: {
                type: "object",
                additionalProperties: false,
                properties: {
                  calories: { type: "number" },
                  proteinGrams: { type: "number" },
                  fatsGrams: { type: "number" },
                  waterMl: { type: "number" },
                  personalizationReason: { type: "string" },
                },
                required: [
                  "calories",
                  "proteinGrams",
                  "fatsGrams",
                  "waterMl",
                  "personalizationReason",
                ],
              },
            },
          },
        });

        parsedSelection = JSON.parse(response.output_text);
        finalPlan = validateAndBuildAiPlan(parsedSelection, calculation);

        if (!finalPlan) {
          finalPlan = rebalancePlan(parsedSelection, calculation);
        }
      } catch (aiError) {
        console.error(
          "generatePersonalizedPlan AI error:",
          aiError
        );
      }

      const usedFallback = finalPlan == null;

      if (usedFallback) {
        finalPlan = fallbackPlan;
      }

      const expectedWeeklyWeightChangeKg =
        ((finalPlan.calories - calculation.baseline.tdee) * 7) / 7700;

      return res.status(200).json({
        plan: {
          ...finalPlan,
          tdee: calculation.baseline.tdee,
          expectedWeeklyWeightChangeKg,
        },
        debug: {
          baseline: calculation.baseline,
          allowedRanges: calculation.allowedRanges,
          aiSelection: parsedSelection,
          usedFallback,
        },
      });
    } catch (error) {
      console.error(
        "generatePersonalizedPlan error:",
        error
      );

      return res.status(500).json({
        error: "Plan generation failed",
        message: error.message,
      });
    }
  };
}

module.exports = {
  createGeneratePersonalizedPlanHandler,
  buildReviewedPlan,
};
