const { onRequest } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const OpenAI = require("openai");

const usdaApiKey = defineSecret("USDA_API_KEY");
const openaiApiKey = defineSecret("OPENAI_API_KEY");

exports.searchFoodCalories = onRequest(
  {
    secrets: [usdaApiKey],
    cors: true,
  },
  async (req, res) => {
    try {
      const query = req.query.q;
      const foodType = String(req.query.foodType || "unknown").toLowerCase();

      if (!query || typeof query !== "string") {
        return res.status(400).json({
          error: "Missing query",
        });
      }

      const dataTypeParam = "";

      const url =
        "https://api.nal.usda.gov/fdc/v1/foods/search" +
        `?api_key=${usdaApiKey.value()}` +
        `&query=${encodeURIComponent(query)}` +
        "&pageSize=25" +
        dataTypeParam;

      const response = await fetch(url);

      if (!response.ok) {
        const errorText = await response.text();

        return res.status(500).json({
          error: "USDA request failed",
          status: response.status,
          details: errorText,
        });
      }

const data = await response.json();
const foods = data.foods || [];

function normalizeWord(word) {
  if (word.endsWith("ies")) {
    return word.slice(0, -3) + "y";
  }

  if (word.endsWith("s") && word.length > 3) {
    return word.slice(0, -1);
  }

  return word;
}

function scoreFood(food) {
  const description = String(food.description || "").toLowerCase();
  const dataType = String(food.dataType || "").toLowerCase();
  const brandOwner = String(food.brandOwner || "").toLowerCase();
  const queryText = String(query).toLowerCase();

  const normalizedQuery = queryText
    .replace(/&/g, " and ")
    .replace(/[^a-z0-9\s]/g, " ");

  let score = 0;

  const stopWords = ["and", "with", "of", "the", "a", "an"];

  const queryWords = normalizedQuery
    .split(/\s+/)
    .map((w) => w.trim())
    .filter(Boolean)
    .filter((w) => !stopWords.includes(w))
    .map(normalizeWord);

  const normalizedDescription = description
    .replace(/&/g, " and ")
    .replace(/[^a-z0-9\s]/g, " ")
    .split(/\s+/)
    .map((w) => w.trim())
    .filter(Boolean)
    .map(normalizeWord)
    .join(" ");

  const normalizedQueryText = queryWords.join(" ");

  if (normalizedDescription === normalizedQueryText) score += 80;
  if (normalizedDescription.includes(normalizedQueryText)) score += 50;

  const phraseDistance = normalizedDescription.indexOf(
    normalizedQueryText
  );

  if (phraseDistance >= 0) {
    score += 80;
  }

  const firstQueryWord = queryWords[0];

  if (firstQueryWord && !normalizedDescription.includes(firstQueryWord)) {
    score -= 60;
  }

  let matchedWords = 0;

  const descriptionWords = normalizedDescription
    .split(/\s+/)
    .filter(Boolean);

  const uniqueDescriptionWords = new Set(descriptionWords);

  const allQueryWordsPresent =
    queryWords.length > 0 &&
    queryWords.every((word) => uniqueDescriptionWords.has(word));

  if (allQueryWordsPresent) {
    score += 120;
  }

  for (const word of queryWords) {
    if (uniqueDescriptionWords.has(word)) {
      matchedWords++;
      score += 10;
    }
  }

  const coverage =
    queryWords.length === 0 ? 0 : matchedWords / queryWords.length;

  if (coverage === 1) score += 70;
  if (coverage >= 0.5) score += 20;
  if (queryWords.length > 1 && coverage < 1) score -= 60;

  const processedWords = [
    "topping",
    "syrup",
    "dessert",
    "cake",
    "pie",
    "jam",
    "jelly",
    "candy",
    "sweetened",
    "dried",
    "chips",
    "cookie",
    "cookies",
    "ice cream",
    "mix",
    "filling",
    "preserve",
    "preserves",
    "beverage",
    "drink",
    "gelatin",
    "snack",
    "bar",
    "cereal",
    "yogurt",
    "flavored",
    "juice",
    "smoothie",
    "sauce",
    "cocktail",
    "spread",
  ];

  const hasProcessedWord = processedWords.some((word) =>
    normalizedDescription.includes(word)
  );

  if (foodType === "basic") {
    if (
      queryWords.length === 1 &&
      firstQueryWord &&
      !normalizedDescription.startsWith(firstQueryWord)
    ) {
    score -= 100;
    }

    if (dataType.includes("foundation")) score += 100;
    if (dataType.includes("sr legacy")) score += 80;
    if (dataType.includes("survey")) score -= 30;
    if (dataType.includes("branded")) score -= 80;

    if (hasProcessedWord) score -= 120;
    if (
      normalizedDescription.includes("milk") ||
      normalizedDescription.includes("juice")
    ) {
      score -= 200;
    }
    if (normalizedDescription.includes("raw")) score += 60;
    if (normalizedDescription.includes("fresh")) score += 40;
    if (normalizedDescription.includes("cooked")) score += 15;

    if (brandOwner) score -= 60;
  } else if (foodType === "prepared") {
    if (coverage === 1) score += 80;

    if (allQueryWordsPresent) {
      score += 80;
    }

    if (phraseDistance >= 0) {
      score += 50;
    }

    if (
      queryWords.length === 1 &&
      firstQueryWord &&
      normalizedDescription.includes(firstQueryWord)
    ) {
      score += 80;
    }

    if (dataType.includes("foundation")) score += 90;
    if (dataType.includes("sr legacy")) score += 80;
    if (dataType.includes("survey")) score += 55;
    if (dataType.includes("branded")) score -= 20;

    if (normalizedDescription.includes("prepared")) score += 25;
    if (normalizedDescription.includes("cooked")) score += 15;

    if (normalizedDescription.includes("unprepared")) score -= 180;

    if (
      !normalizedQueryText.includes("veggie") &&
      !normalizedQueryText.includes("soy") &&
      !normalizedQueryText.includes("vegetarian") &&
      (
        normalizedDescription.includes("veggie") ||
        normalizedDescription.includes("soyburger") ||
        normalizedDescription.includes("soy") ||
        normalizedDescription.includes("vegetarian") ||
        normalizedDescription.includes("meatless")
      )
    ) {
      score -= 220;
    }
  } else if (foodType === "branded") {
    if (brandOwner) score += 80;
    if (dataType.includes("branded")) score += 80;
  } else {
    if (coverage === 1) score += 40;
    if (dataType.includes("foundation")) score += 20;
    if (dataType.includes("sr legacy")) score += 15;
    if (dataType.includes("survey")) score += 10;
  }

  return score;
}

async function getCaloriesFromFood(food) {
  const energy = food.foodNutrients?.find((n) => {
    const name = String(n.nutrientName || n.nutrient?.name || "").toLowerCase();
    const unit = String(n.unitName || n.nutrient?.unitName || "").toLowerCase();

    return (
      name.includes("energy") &&
      unit.includes("kcal") &&
      (n.value != null ||
        n.amount != null ||
        n.nutrientValue != null)
    );
  });

  const caloriesValue =
    energy?.value ??
    energy?.amount ??
    energy?.nutrientValue;

  if (caloriesValue != null) {
    return caloriesValue;
  }

  const fdcId = food.fdcId;

  if (!fdcId) return null;

  const detailUrl =
    `https://api.nal.usda.gov/fdc/v1/food/${fdcId}` +
    `?api_key=${usdaApiKey.value()}`;

  const detailResponse = await fetch(detailUrl);

  if (!detailResponse.ok) return null;

  const detailData = await detailResponse.json();

  const detailEnergy = detailData.foodNutrients?.find((n) => {
    const name = String(n.nutrient?.name || n.nutrientName || "").toLowerCase();
    const unit = String(n.nutrient?.unitName || n.unitName || "").toLowerCase();

    return (
      name.includes("energy") &&
      unit.includes("kcal") &&
      (n.amount != null ||
        n.value != null ||
        n.nutrientValue != null)
    );
  });

  return (
    detailEnergy?.amount ??
    detailEnergy?.value ??
    detailEnergy?.nutrientValue ??
    null
  );
}

const rankedFoods = foods
  .map((item) => ({
    item,
    score: scoreFood(item),
  }))
  .sort((a, b) => b.score - a.score);

let selectedFood = null;
let selectedCalories = null;

for (const ranked of rankedFoods) {
  const candidate = ranked.item;

  const caloriesValue = await getCaloriesFromFood(candidate);

  if (caloriesValue != null) {
    if (
      foodType === "prepared" &&
      queryWords.length > 1 &&
      ranked.score < 0
    ) {
      continue;
    }

    selectedFood = candidate;
    selectedCalories = caloriesValue;
    break;
  }
}

if (!selectedFood || selectedCalories == null) {
  return res.status(404).json({
    error: "Calories not found",
  });
}

      return res.status(200).json({
        name: selectedFood.description || query,
        caloriesPer100g: selectedCalories,
        source: "usda",
        foodType: foodType,
        dataType: selectedFood.dataType || null,
      });
    } catch (error) {
      return res.status(500).json({
        error: "Server error",
      });
    }
  }
);

exports.normalizeFoodName = onRequest(
  {
    secrets: [openaiApiKey],
    cors: true,
  },
  async (req, res) => {
    try {
      const input = req.query.q;

      if (!input || typeof input !== "string") {
        return res.status(400).json({ error: "Missing query" });
      }

      const client = new OpenAI({
        apiKey: openaiApiKey.value(),
      });

      const response = await client.chat.completions.create({
        model: "gpt-4o-mini",
        temperature: 0.1,
        response_format: {
          type: "json_object",
        },
        messages: [
          {
            role: "system",
            content:
              "You normalize food names for a calorie tracking app. Return only valid JSON.",
          },
          {
            role: "user",
            content:
              `Normalize this food input for a calorie tracking app: "${input}". ` +
              "Fix typos. Use English food names. " +
              "Assume foods are in their commonly consumed form unless the user specifies raw, uncooked, dry, or frozen. " +
              "For example: rice usually means cooked rice, strawberry means strawberry, chicken breast usually means cooked chicken breast. " +
              "Classify foodType as one of: basic, prepared, branded, unknown. " +
              "basic = single generic whole food like apple, banana, rice, egg, chicken. " +
              "prepared = cooked dish, recipe, mixed food, dessert, beverage, juice, smoothie, soup, sandwich, burger, pizza, cake, cheesecake. " +
              "branded = packaged/brand item, unknown = unclear. " +
              "searchQuery must be the best USDA search phrase. For prepared foods, use the main dish name first. " +
              "For example, lemon cheesecake should use searchQuery cheesecake lemon, fish and chips should use searchQuery fish chips. " +
              "searchQuery should usually match normalizedName for simple basic foods. " +
              "Do not simplify cooked chicken to chicken, cooked rice to rice, or cooked broccoli to broccoli. " +
              "Return JSON with exactly these fields: normalizedName, searchQuery, foodType.",
          },
        ],
      });

      const text = response.choices?.[0]?.message?.content;

      if (!text) {
        return res.status(500).json({
          error: "OpenAI returned empty response",
        });
      }

      const result = JSON.parse(text);

      return res.status(200).json(result);
    } catch (error) {
      return res.status(500).json({
        error: "AI normalize failed",
        message: error.message,
      });
    }
  }
);

exports.estimateFoodCalories = onRequest(
  {
    secrets: [openaiApiKey],
    cors: true,
  },
  async (req, res) => {
    try {
      const foodName = req.query.food;

      if (!foodName || typeof foodName !== "string") {
        return res.status(400).json({
          error: "Missing food name",
        });
      }

      const client = new OpenAI({
        apiKey: openaiApiKey.value(),
      });

      const response = await client.responses.create({
        model: "gpt-4o-mini",
        input: [
          {
            role: "system",
            content:
              "You estimate calories for foods. Return only JSON.",
          },
          {
            role: "user",
            content:
              `Estimate calories per 100g for: "${foodName}". ` +
              "Return JSON with caloriesPer100g and confidence. " +
              "confidence must be low, medium, or high.",
          },
        ],
        text: {
          format: {
            type: "json_schema",
            name: "food_calorie_estimate",
            schema: {
              type: "object",
              additionalProperties: false,
              properties: {
                caloriesPer100g: {
                  type: "number",
                },
                confidence: {
                  type: "string",
                  enum: ["low", "medium", "high"],
                },
              },
              required: [
                "caloriesPer100g",
                "confidence",
              ],
            },
          },
        },
      });

      const result =
        JSON.parse(response.output_text);

      return res.status(200).json(result);
    } catch (error) {
      return res.status(500).json({
        error: "AI estimate failed",
        message: error.message,
      });
    }
  }
);

exports.classifyExercise = onRequest(
  {
    secrets: [openaiApiKey],
    cors: true,
  },
  async (req, res) => {
    try {
      const input = req.body?.input;
      const exercises = req.body?.exercises;

      if (!input || typeof input !== "string") {
        return res.status(400).json({
          error: "Missing input",
        });
      }

      if (!Array.isArray(exercises) || exercises.length === 0) {
        return res.status(400).json({
          error: "Missing exercises",
        });
      }

      const compactExercises = exercises.map((exercise) => ({
        id: exercise.id,
        name: exercise.name,
        aliases: exercise.aliases || [],
      }));

      const client = new OpenAI({
        apiKey: openaiApiKey.value(),
      });

      const response = await client.chat.completions.create({
        model: "gpt-4o-mini",
        temperature: 0,
        response_format: {
          type: "json_object",
        },
        messages: [
          {
            role: "system",
            content:
              "You classify user workout text into exactly one exercise from the provided list. Return only valid JSON. Never invent an exercise.",
          },
          {
            role: "user",
            content:
              `User workout input: "${input}". ` +
              `Available exercises: ${JSON.stringify(compactExercises)}. ` +
              "Pick the closest exercise from the list. " +
              "Return JSON with exactly these fields: exerciseId, exerciseName, confidence. " +
              "confidence must be low, medium, or high. " +
              "If unsure, still choose the closest available exercise.",
          },
        ],
      });

      const text = response.choices?.[0]?.message?.content;

      if (!text) {
        return res.status(500).json({
          error: "OpenAI returned empty response",
        });
      }

      const result = JSON.parse(text);

      const exists = compactExercises.some(
        (exercise) => exercise.id === result.exerciseId
      );

      if (!exists) {
        return res.status(422).json({
          error: "Invalid exercise match",
        });
      }

      return res.status(200).json(result);
    } catch (error) {
      return res.status(500).json({
        error: "Exercise classification failed",
        message: error.message,
      });
    }
  }
);

exports.chatWithCoach = onRequest(
  {
    secrets: [openaiApiKey],
    cors: true,
  },
  async (req, res) => {
    try {
      const message = req.body?.message;
      const userPreferences = req.body?.userPreferences || {};
      const dailySummary = req.body?.dailySummary || {};
      const last7Summaries = req.body?.last7Summaries || [];
      const recentMessages = req.body?.recentMessages || [];

      if (!message || typeof message !== "string") {
        return res.status(400).json({
          error: "Missing message",
        });
      }

      const client = new OpenAI({
        apiKey: openaiApiKey.value(),
      });

      const response = await client.chat.completions.create({
        model: "gpt-4o-mini",
        temperature: 0.6,
        max_tokens: 130,
        messages: [
          {
            role: "system",
            content:
              "You are Fiteo, a friendly AI fitness and nutrition coach inside a diet and workout app. " +
              "Give short, clear, practical and motivational answers. " +
              "Use the user's preferences, today's summary, last 7 daily summaries, and recent messages when available. " +
              "You can comment on daily calories, goals, workouts, meal ideas, and general fitness advice. " +
              "Do not give exact macro analysis if macro data is missing. " +
              "Do not diagnose medical conditions or give medical treatment advice. " +
              "For serious health issues, tell the user to consult a qualified healthcare professional. " +
              "Keep answers concise, under 80 words. Use short, clear sentences. ",
          },
          {
            role: "user",
            content:
              "User preferences: " +
              JSON.stringify(userPreferences) +
              "\nToday summary: " +
              JSON.stringify(dailySummary) +
              "\nLast 7 daily summaries: " +
              JSON.stringify(last7Summaries) +
              "\nRecent messages: " +
              JSON.stringify(recentMessages) +
              "\nCurrent message: " +
              message,
          },
        ],
      });

      const reply = response.choices?.[0]?.message?.content?.trim();

      if (!reply) {
        return res.status(500).json({
          error: "OpenAI returned empty response",
        });
      }

      return res.status(200).json({
        reply,
      });
    } catch (error) {
      return res.status(500).json({
        error: "AI chat failed",
        message: error.message,
      });
    }
  }
);

exports.generateRecipeFromIngredients = onRequest(
  {
    secrets: [openaiApiKey],
    cors: true,
  },
  async (req, res) => {
    try {
      const ingredients = req.body?.ingredients;
      const preferences = req.body?.preferences || {};

      if (!ingredients || typeof ingredients !== "string") {
        return res.status(400).json({
          error: "Missing ingredients",
        });
      }

      const compactPreferences = {
        goal: preferences.goal || null,
        nutritionPreference: preferences.nutritionPreference || null,
      };

      const client = new OpenAI({
        apiKey: openaiApiKey.value(),
      });

      const response = await client.responses.create({
        model: "gpt-4o-mini",
        max_output_tokens: 450,
        input: [
          {
            role: "system",
            content:
              "You are Fiteo Cook Mode, an AI recipe assistant inside a fitness and diet app. " +
              "Create one simple recipe using only the user's main ingredients. " +
              "The user provides ingredients they have available. You do not have to use every ingredient. Use only the ingredients that make sense for one simple recipe. " +
              "Parse ingredient input flexibly. Ingredients may be separated by commas, spaces, slashes, dashes, or new lines. Multi-word ingredients such as ground beef, olive oil, or red pepper should be treated as single ingredients when appropriate. " +
              "You may add only basic pantry items such as salt, black pepper, water, and a small amount of oil. " +
              "Do not add new main ingredients such as rice, pasta, meat, fish, cheese, tomato, lettuce, vegetables, fruits, dairy, eggs, or grains unless the user provided them. " +
              "The user's goal or nutrition preference is only a light preference. Never add new main ingredients just to match the goal. " +
              "Estimate calories by summing ingredient calories. Cooking usually changes weight, not total calories, unless oil or another ingredient is added. " +
              "Also estimate protein, fat, and carbohydrates for the full recipe and return the values per serving. " +
              "If you add allowed pantry items such as oil, include their estimated calories in the ingredients list and totalCalories. Salt, pepper, and water should be 0 kcal. " +
              "Keep recipes practical and concise. Do not generate unnecessarily long instructions. " +
              "Return only valid JSON.",
          },
          {
            role: "user",
            content:
              "User ingredients: " +
              ingredients +
              "\nUser preferences: " +
              JSON.stringify(compactPreferences) +
              "\nCreate a recipe using only these ingredients and allowed pantry items.",
          },
        ],
        text: {
          format: {
            type: "json_schema",
            name: "recipe_result",
            schema: {
              type: "object",
              additionalProperties: false,
              properties: {
                recipeName: {
                  type: "string",
                },
                ingredients: {
                  type: "array",
                  items: {
                    type: "object",
                    additionalProperties: false,
                    properties: {
                      name: {
                        type: "string",
                      },
                      amount: {
                        type: "string",
                      },
                      calories: {
                        type: "number",
                      },
                    },
                    required: ["name", "amount", "calories"],
                  },
                },
                instructions: {
                  type: "array",
                  items: {
                    type: "string",
                  },
                },
                totalCalories: {
                  type: "number",
                },
                servings: {
                  type: "number",
                },
                caloriesPerServing: {
                  type: "number",
                },
                proteinPerServing: {
                  type: "number",
                },
                fatPerServing: {
                  type: "number",
                },
                carbsPerServing: {
                  type: "number",
                },
              },
              required: [
                "recipeName",
                "ingredients",
                "instructions",
                "totalCalories",
                "servings",
                "caloriesPerServing",
                "proteinPerServing",
                "fatPerServing",
                "carbsPerServing",
              ],
            },
          },
        },
      });

      const result = JSON.parse(response.output_text);

      return res.status(200).json(result);
    } catch (error) {
      return res.status(500).json({
        error: "Recipe generation failed",
        message: error.message,
      });
    }
  }
);