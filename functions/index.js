const { onRequest } = require("firebase-functions/v2/https");
const { onDocumentWritten } = require("firebase-functions/v2/firestore");
const { defineSecret } = require("firebase-functions/params");
const OpenAI = require("openai");
const admin = require("firebase-admin");

admin.initializeApp();

const { createGeneratePersonalizedPlanHandler } = require("./personalized_plan");

const usdaApiKey = defineSecret("USDA_API_KEY");
const openaiApiKey = defineSecret("OPENAI_API_KEY");

const fatSecretClientId = defineSecret("FATSECRET_CLIENT_ID");
const fatSecretClientSecret = defineSecret("FATSECRET_CLIENT_SECRET");

async function requireAuthenticatedUser(req, res) {
  const authorization =
      String(req.headers.authorization || "").trim();

  if (!authorization.startsWith("Bearer ")) {
    res.status(401).json({
      error: "Authentication required",
    });

    return null;
  }

  const idToken =
      authorization.substring("Bearer ".length).trim();

  if (!idToken) {
    res.status(401).json({
      error: "Authentication required",
    });

    return null;
  }

  try {
    return await admin.auth().verifyIdToken(idToken);
  } catch (error) {
    console.error(
      "Firebase ID token verification failed:",
      error
    );

    res.status(401).json({
      error: "Invalid authentication token",
    });

    return null;
  }
}

const PREMIUM_CHAT_SAFETY_LIMIT = 100;
const PREMIUM_RECIPE_SAFETY_LIMIT = 20;

const FREE_CHAT_LIMIT = 2;
const FREE_RECIPE_LIMIT = 1;

const MAX_REWARDED_CHAT_CREDITS = 3;
const MAX_REWARDED_RECIPE_CREDITS = 2;

function getUtcDateKey() {
  return new Date().toISOString().slice(0, 10);
}

function normalizeFatSecretQuery(value) {
  return String(value || "")
    .toLowerCase()
    .replace(/&/g, " and ")
    .replace(/['’]/g, "")
    .replace(/[^a-z0-9]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function normalizeFatSecretBarcode(value) {
  const digits =
      String(value || "")
        .replace(/\D/g, "");

  if (digits.length === 13) {
    return digits;
  }

  if (
    digits.length === 12 ||
    digits.length === 8
  ) {
    return digits.padStart(13, "0");
  }

  return null;
}

async function reserveAiUsage({
  uid,
  type,
  isPremium,
}) {
  const isChat = type === "chat";

  const countField =
      isChat ? "chatCount" : "recipeCount";

  const rewardedCreditsField =
      isChat
        ? "rewardedChatCredits"
        : "rewardedRecipeCredits";

  const freeBaseLimit =
      isChat
        ? FREE_CHAT_LIMIT
        : FREE_RECIPE_LIMIT;

  const maxRewardedCredits =
      isChat
        ? MAX_REWARDED_CHAT_CREDITS
        : MAX_REWARDED_RECIPE_CREDITS;

  const premiumSafetyLimit =
      isChat
        ? PREMIUM_CHAT_SAFETY_LIMIT
        : PREMIUM_RECIPE_SAFETY_LIMIT;

  const today = getUtcDateKey();

  const usageRef = admin
    .firestore()
    .collection("users")
    .doc(uid)
    .collection("aiUsage")
    .doc(today);

  return admin.firestore().runTransaction(
    async (transaction) => {
      const snapshot =
          await transaction.get(usageRef);

      const data = snapshot.data() || {};

      const currentCount =
          Number(data[countField]) || 0;

      let allowedCount;

      if (isPremium) {
        allowedCount =
            premiumSafetyLimit;
      } else {
        const rawRewardedCredits =
            Number(
              data[rewardedCreditsField]
            ) || 0;

        const rewardedCredits = Math.min(
          Math.max(rawRewardedCredits, 0),
          maxRewardedCredits
        );

        allowedCount =
            freeBaseLimit +
            rewardedCredits;
      }

      if (currentCount >= allowedCount) {
        return false;
      }

      transaction.set(
        usageRef,
        {
          [countField]:
              currentCount + 1,
          updatedAt:
              admin.firestore.FieldValue
                .serverTimestamp(),
        },
        {
          merge: true,
        },
      );

      return true;
    },
  );
}

async function getUserMembership(uid) {
  const membershipRef = admin
    .firestore()
    .collection("users")
    .doc(uid)
    .collection("membership")
    .doc("current");

  const snapshot =
      await membershipRef.get();

  const data = snapshot.data();

  return {
    isPremium:
      data?.isPremium === true &&
      data?.status === "active",
  };
}

const PLAN_TRACKING_SCHEMA_VERSION = 1;

function isActivePremiumMembership(data) {
  return (
    data?.isPremium === true &&
    data?.status === "active"
  );
}

function getDateKey(date) {
  return date.toISOString().slice(0, 10);
}

function getDateKeyInTimezone(date, timezone) {
  try {
    const formatter =
        new Intl.DateTimeFormat(
          "en-US",
          {
            timeZone: timezone,
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
          }
        );

    const parts =
        formatter.formatToParts(date);

    const year =
        parts.find(
          (part) => part.type === "year"
        )?.value;

    const month =
        parts.find(
          (part) => part.type === "month"
        )?.value;

    const day =
        parts.find(
          (part) => part.type === "day"
        )?.value;

    if (!year || !month || !day) {
      throw new Error(
        "Unable to resolve local date"
      );
    }

    return `${year}-${month}-${day}`;
  } catch (error) {
    console.error(
      `Invalid timezone "${timezone}":`,
      error
    );

    return getDateKey(date);
  }
}

function calculateExpectedWeeklyWeightChange({
  calorieGoal,
  tdee,
}) {
  if (tdee <= 0 || calorieGoal <= 0) {
    return 0;
  }

  const dailyEnergyDifference =
      calorieGoal - tdee;

  return dailyEnergyDifference * 7 / 7700;
}

function calculateInitialEstimatedGoalDate({
  planStartWeight,
  targetWeight,
  expectedWeeklyWeightChangeKg,
  planActivatedAt,
}) {
  const remainingWeight =
      targetWeight - planStartWeight;

  if (Math.abs(remainingWeight) < 0.05) {
    return planActivatedAt;
  }

  if (
    Math.abs(expectedWeeklyWeightChangeKg) <
    0.01
  ) {
    return null;
  }

  const movingTowardGoal =
      Math.sign(remainingWeight) ===
      Math.sign(expectedWeeklyWeightChangeKg);

  if (!movingTowardGoal) {
    return null;
  }

  const weeks =
      Math.abs(remainingWeight) /
      Math.abs(expectedWeeklyWeightChangeKg);

  if (!Number.isFinite(weeks) || weeks < 0) {
    return null;
  }

  const estimatedGoalDate =
      new Date(planActivatedAt);

  estimatedGoalDate.setUTCDate(
    estimatedGoalDate.getUTCDate() +
      Math.round(weeks * 7)
  );

  return estimatedGoalDate;
}

function calculatePremiumPlanTrackingStart(
  userData
) {
  const userPreferences =
      userData?.userPreferences || {};

  const nutritionPlan =
      userData?.nutritionPlan || {};

  const age =
      Number(userPreferences.age);

  const height =
      Number(userPreferences.height);

  const currentWeight =
      Number(userPreferences.weight);

  const targetWeight =
      Number(userPreferences.targetWeight);

  const gender =
      String(
        userPreferences.gender || ""
      );

  const activityLevel =
      String(
        userPreferences.activityLevel || ""
      );

  const calorieGoal =
      Number(
        nutritionPlan.dailyCalories ??
        userPreferences.calorieGoal
      );

  if (
    !Number.isFinite(age) ||
    !Number.isFinite(height) ||
    !Number.isFinite(currentWeight) ||
    !Number.isFinite(targetWeight) ||
    !Number.isFinite(calorieGoal) ||
    age <= 0 ||
    height <= 0 ||
    currentWeight <= 0 ||
    targetWeight <= 0 ||
    calorieGoal <= 0 ||
    !gender ||
    !activityLevel
  ) {
    throw new Error(
      "Missing data required to initialize Plan Tracking"
    );
  }

  const isMale =
      gender.toLowerCase() === "male";

  const bmr = isMale
    ? 10 * currentWeight +
      6.25 * height -
      5 * age +
      5
    : 10 * currentWeight +
      6.25 * height -
      5 * age -
      161;

  const activityMultipliers = {
    Sedentary: 1.2,
    "Lightly Active": 1.375,
    "Moderately Active": 1.55,
    "Very Active": 1.725,
  };

  const activityMultiplier =
      activityMultipliers[activityLevel];

  if (!activityMultiplier) {
    throw new Error(
      "Unsupported activity level for Plan Tracking"
    );
  }

  const tdee =
      bmr * activityMultiplier;

  const expectedWeeklyWeightChangeKg =
      calculateExpectedWeeklyWeightChange({
        calorieGoal,
        tdee,
      });

  return {
    currentWeight,
    targetWeight,
    expectedWeeklyWeightChangeKg,
  };
}

function createInitialPlanTrackingCache({
  currentWeight,
  targetWeight,
  expectedWeeklyWeightChangeKg,
  planActivatedAt,
  timezone,
}) {
  const estimatedGoalDate =
      calculateInitialEstimatedGoalDate({
        planStartWeight: currentWeight,
        targetWeight,
        expectedWeeklyWeightChangeKg,
        planActivatedAt,
      });

  return {
    schemaVersion:
      PLAN_TRACKING_SCHEMA_VERSION,

    planActivatedAt:
      getDateKeyInTimezone(
        planActivatedAt,
        timezone
      ),

    lastProcessedDate: null,

    planStartWeight:
      currentWeight,

    expectedWeeklyWeightChangeKg,

    planEligibleDays: 0,
    calorieTrackedDays: 0,
    calorieAdherenceSum: 0,

    weightEntryCount: 0,
    latestWeight: null,
    latestWeightDate: null,
    actualWeeklyWeightChangeKg: null,
    weightPoints: [],

    progressRatio: null,

    estimatedGoalDate:
      estimatedGoalDate == null
        ? null
        : getDateKeyInTimezone(
            estimatedGoalDate,
            timezone
          ),

    projectionDifferenceDays: null,

    planStatus: "notEnoughData",

    aiNote: null,
    aiNoteDate: null,

    updatedAt:
      admin.firestore.FieldValue
        .serverTimestamp(),
  };
}

exports.initializePlanTrackingOnPremium =
  onDocumentWritten(
    "users/{uid}/membership/current",
    async (event) => {
      const uid = event.params.uid;

      const beforeData =
          event.data?.before.exists
            ? event.data.before.data()
            : null;

      const afterData =
          event.data?.after.exists
            ? event.data.after.data()
            : null;

      const wasPremium =
          isActivePremiumMembership(
            beforeData
          );

      const isPremium =
          isActivePremiumMembership(
            afterData
          );

      if (wasPremium || !isPremium) {
        return;
      }

      const userRef = admin
        .firestore()
        .collection("users")
        .doc(uid);

      const trackingRef = userRef
        .collection("planTracking")
        .doc("current");

      await admin.firestore().runTransaction(
        async (transaction) => {
          const userSnapshot =
              await transaction.get(userRef);

          if (!userSnapshot.exists) {
            throw new Error(
              `User ${uid} does not exist`
            );
          }

          const userData =
              userSnapshot.data() || {};

          const timezone =
              String(
                userData.timezone || "UTC"
              ).trim();

          const {
            currentWeight,
            targetWeight,
            expectedWeeklyWeightChangeKg,
          } =
              calculatePremiumPlanTrackingStart(
                userData
              );

          const planActivatedAt =
              new Date();

          const cache =
              createInitialPlanTrackingCache({
                currentWeight,
                targetWeight,
                expectedWeeklyWeightChangeKg,
                planActivatedAt,
                timezone,
              });

          transaction.set(
            trackingRef,
            cache
          );

          console.log(
            `Plan Tracking initialized for premium user ${uid}`
          );
        }
      );
    }
  );

let fatSecretCachedAccessToken = null;
let fatSecretAccessTokenExpiresAt = 0;
let fatSecretTokenRequestPromise = null;

const FATSECRET_TOKEN_EXPIRY_BUFFER_MS =
  5 * 60 * 1000;

async function requestNewFatSecretAccessToken() {
   const credentials = Buffer.from(
     `${fatSecretClientId.value()}:${fatSecretClientSecret.value()}`
   ).toString("base64");

   const response = await fetch(
     "https://oauth.fatsecret.com/connect/token",
     {
       method: "POST",
       headers: {
         Authorization: `Basic ${credentials}`,
         "Content-Type":
           "application/x-www-form-urlencoded",
       },
       body: new URLSearchParams({
         grant_type: "client_credentials",
         scope: "premier barcode",
       }),
     }
   );

   if (!response.ok) {
     const errorText = await response.text();

     throw new Error(
       `FatSecret token request failed: ${response.status} ${errorText}`
     );
   }

   const data = await response.json();

   const accessToken = data.access_token;
   const expiresInSeconds =
     Number(data.expires_in) || 3600;

   if (!accessToken) {
     throw new Error(
       "FatSecret token response did not include access_token"
     );
   }

   fatSecretCachedAccessToken = accessToken;

   fatSecretAccessTokenExpiresAt =
     Date.now() +
     expiresInSeconds * 1000;

   console.log(
     `FATSECRET TOKEN: new token cached for ${expiresInSeconds}s`
   );

   return accessToken;
 }

 async function getFatSecretAccessToken() {
   const now = Date.now();

   const hasValidCachedToken =
     fatSecretCachedAccessToken &&
     now <
       fatSecretAccessTokenExpiresAt -
         FATSECRET_TOKEN_EXPIRY_BUFFER_MS;

   if (hasValidCachedToken) {
     console.log(
       "FATSECRET TOKEN: using cached token"
     );

     return fatSecretCachedAccessToken;
   }

   if (fatSecretTokenRequestPromise) {
     console.log(
       "FATSECRET TOKEN: waiting for existing token request"
     );

     return fatSecretTokenRequestPromise;
   }

   fatSecretTokenRequestPromise =
     requestNewFatSecretAccessToken();

   try {
     return await fatSecretTokenRequestPromise;
   } finally {
     fatSecretTokenRequestPromise = null;
   }
 }

 exports.fatSecretFoodAlias = onRequest(
   {
     cors: true,
   },
   async (req, res) => {
     try {
       const decodedToken =
           await requireAuthenticatedUser(
             req,
             res
           );

       if (!decodedToken) {
         return;
       }

       if (req.method === "GET") {
         const query =
             normalizeFatSecretQuery(
               req.query.q
             );

         if (!query) {
           return res.status(400).json({
             error: "Missing query",
           });
         }

         const aliasRef = admin
           .firestore()
           .collection(
             "fatSecretFoodAliases"
           )
           .doc(query);

         const snapshot =
             await aliasRef.get();

         const foodId =
             snapshot
               .data()
               ?.foodId
               ?.toString()
               .trim();

         return res.status(200).json({
           foodId:
               foodId && foodId.length > 0
                 ? foodId
                 : null,
         });
       }

       if (req.method === "POST") {
         const query =
             normalizeFatSecretQuery(
               req.body?.query
             );

         const foodId =
             String(
               req.body?.foodId || ""
             ).trim();

         if (!query || !foodId) {
           return res.status(400).json({
             error:
                 "Missing query or foodId",
           });
         }

         await admin
           .firestore()
           .collection(
             "fatSecretFoodAliases"
           )
           .doc(query)
           .set({
             foodId,
             updatedAt:
                 admin.firestore.FieldValue
                   .serverTimestamp(),
           });

         return res.status(200).json({
           success: true,
         });
       }

       return res.status(405).json({
         error: "Method not allowed",
       });
     } catch (error) {
       console.error(
         "fatSecretFoodAlias error:",
         error
       );

       return res.status(500).json({
         error:
             "FatSecret food alias request failed",
       });
     }
   }
 );

 exports.fatSecretBarcodeAlias = onRequest(
   {
     cors: true,
   },
   async (req, res) => {
     try {
       const decodedToken =
           await requireAuthenticatedUser(
             req,
             res
           );

       if (!decodedToken) {
         return;
       }

       if (req.method === "GET") {
         const barcode =
             normalizeFatSecretBarcode(
               req.query.barcode
             );

         if (!barcode) {
           return res.status(400).json({
             error: "Invalid barcode",
           });
         }

         const aliasRef = admin
           .firestore()
           .collection(
             "fatSecretBarcodeAliases"
           )
           .doc(barcode);

         const snapshot =
             await aliasRef.get();

         const foodId =
             snapshot
               .data()
               ?.foodId
               ?.toString()
               .trim();

         return res.status(200).json({
           foodId:
               foodId && foodId.length > 0
                 ? foodId
                 : null,
         });
       }

       if (req.method === "POST") {
         const barcode =
             normalizeFatSecretBarcode(
               req.body?.barcode
             );

         const foodId =
             String(
               req.body?.foodId || ""
             ).trim();

         if (!barcode || !foodId) {
           return res.status(400).json({
             error:
                 "Missing barcode or foodId",
           });
         }

         await admin
           .firestore()
           .collection(
             "fatSecretBarcodeAliases"
           )
           .doc(barcode)
           .set({
             foodId,
             updatedAt:
                 admin.firestore.FieldValue
                   .serverTimestamp(),
           });

         return res.status(200).json({
           success: true,
         });
       }

       return res.status(405).json({
         error: "Method not allowed",
       });
     } catch (error) {
       console.error(
         "fatSecretBarcodeAlias error:",
         error
       );

       return res.status(500).json({
         error:
             "FatSecret barcode alias request failed",
       });
     }
   }
 );

exports.searchFatSecretFoods = onRequest(
  {
    secrets: [
      fatSecretClientId,
      fatSecretClientSecret,
    ],
    cors: true,
  },
  async (req, res) => {
    try {
          const decodedToken =
              await requireAuthenticatedUser(
                req,
                res
              );

          if (!decodedToken) {
            return;
          }

      const query = String(
        req.query.q || ""
      ).trim();

      if (!query) {
        return res.status(400).json({
          error: "Missing query",
        });
      }

      const accessToken =
        await getFatSecretAccessToken();

      const url = new URL(
        "https://platform.fatsecret.com/rest/foods/search/v5"
      );

      url.searchParams.set(
        "search_expression",
        query
      );

      url.searchParams.set(
        "region",
        "US"
      );

      url.searchParams.set(
        "language",
        "en"
      );

      url.searchParams.set(
        "format",
        "json"
      );

      url.searchParams.set(
        "max_results",
        "20"
      );

      url.searchParams.set(
        "flag_default_serving",
        "true"
      );

      const response = await fetch(
        url.toString(),
        {
          method: "GET",
          headers: {
            Authorization:
              `Bearer ${accessToken}`,
          },
        }
      );

      if (!response.ok) {
        const errorText =
          await response.text();

        return res.status(500).json({
          error:
            "FatSecret search failed",
          status: response.status,
          details: errorText,
        });
      }

      const data =
        await response.json();

      return res.status(200).json(data);
    } catch (error) {
      console.error(
        "searchFatSecretFoods error:",
        error
      );

      return res.status(500).json({
        error:
          "FatSecret request failed",
      });
    }
  }
);

exports.findFatSecretFoodByBarcode = onRequest(
  {
    secrets: [
      fatSecretClientId,
      fatSecretClientSecret,
    ],
    cors: true,
  },
  async (req, res) => {
    try {
          const decodedToken =
              await requireAuthenticatedUser(
                req,
                res
              );

          if (!decodedToken) {
            return;
          }

      const rawBarcode = String(
        req.query.barcode || ""
      ).trim();

      const digits = rawBarcode.replace(/\D/g, "");

      let barcode;

      if (digits.length === 13) {
        barcode = digits;
      } else if (
        digits.length === 12 ||
        digits.length === 8
      ) {
        barcode = digits.padStart(13, "0");
      } else {
        return res.status(400).json({
          error: "Barcode must be EAN-8, UPC-A or EAN-13",
        });
      }

      const accessToken =
          await getFatSecretAccessToken();

      const url = new URL(
        "https://platform.fatsecret.com/rest/food/barcode/find-by-id/v1"
      );

      url.searchParams.set(
        "barcode",
        barcode
      );

      url.searchParams.set(
        "region",
        "US"
      );

      url.searchParams.set(
        "language",
        "en"
      );

      url.searchParams.set(
        "format",
        "json"
      );



      const response = await fetch(
        url.toString(),
        {
          method: "GET",
          headers: {
            Authorization:
              `Bearer ${accessToken}`,
          },
        }
      );

      if (!response.ok) {
        const errorText =
            await response.text();

        return res.status(response.status).json({
          error:
            "FatSecret barcode request failed",
          status: response.status,
          details: errorText,
        });
      }

      const data = await response.json();

      const foodId =
          data?.food_id?.value?.toString();

      if (!foodId) {
        return res.status(404).json({
          error: "Food not found for barcode",
        });
      }

      return res.status(200).json({
        foodId,
        barcode,
      });
    } catch (error) {
      console.error(
        "findFatSecretFoodByBarcode error:",
        error
      );

      return res.status(500).json({
        error:
          "FatSecret barcode request failed",
      });
    }
  }
);

exports.getFatSecretFood = onRequest(
  {
    secrets: [
      fatSecretClientId,
      fatSecretClientSecret,
    ],
    cors: true,
  },
  async (req, res) => {
    try {
          const decodedToken =
              await requireAuthenticatedUser(
                req,
                res
              );

          if (!decodedToken) {
            return;
          }

      const foodId = String(
        req.query.foodId || ""
      ).trim();

      if (!foodId) {
        return res.status(400).json({
          error: "Missing foodId",
        });
      }

      const accessToken =
          await getFatSecretAccessToken();

      const url = new URL(
        "https://platform.fatsecret.com/rest/food/v5"
      );

      url.searchParams.set(
        "food_id",
        foodId
      );

      url.searchParams.set(
        "region",
        "US"
      );

      url.searchParams.set(
        "language",
        "en"
      );

      url.searchParams.set(
        "format",
        "json"
      );

      url.searchParams.set(
        "flag_default_serving",
        "true"
      );

      const response = await fetch(
        url.toString(),
        {
          method: "GET",
          headers: {
            Authorization:
              `Bearer ${accessToken}`,
          },
        }
      );

      if (!response.ok) {
        const errorText =
            await response.text();

        return res.status(500).json({
          error:
              "FatSecret food request failed",
          status: response.status,
          details: errorText,
        });
      }

      const data =
          await response.json();

      return res.status(200).json(data);
    } catch (error) {
      console.error(
        "getFatSecretFood error:",
        error
      );

      return res.status(500).json({
        error:
            "FatSecret request failed",
      });
    }
  }
);

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
    const decodedToken =
        await requireAuthenticatedUser(req, res);

    if (!decodedToken) {
      return;
    }

    const uid = decodedToken.uid;

    const membership =
        await getUserMembership(uid);

    const isPremium =
        membership.isPremium;

    const hasChatCapacity =
        await reserveAiUsage({
          uid,
          type: "chat",
          isPremium,
        });

    if (!hasChatCapacity) {
      return res.status(429).json({
        error: isPremium
          ? "AI chat safety limit reached"
          : "Daily AI chat limit reached",
      });
    }

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
    const decodedToken =
        await requireAuthenticatedUser(req, res);

    if (!decodedToken) {
      return;
    }

    const uid = decodedToken.uid;

    const membership =
        await getUserMembership(uid);

    const isPremium =
        membership.isPremium;

    const hasRecipeCapacity =
        await reserveAiUsage({
          uid,
          type: "recipe",
          isPremium,
        });

    if (!hasRecipeCapacity) {
      return res.status(429).json({
        error: isPremium
          ? "AI recipe safety limit reached"
          : "Daily AI recipe limit reached",
      });
    }

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

exports.generatePersonalizedPlan = onRequest(
  {
    secrets: [openaiApiKey],
    cors: true,
  },
  createGeneratePersonalizedPlanHandler(openaiApiKey)
);