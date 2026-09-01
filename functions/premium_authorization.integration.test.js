const test = require("node:test");
const assert = require("node:assert/strict");
const admin = require("firebase-admin");

const PROJECT_ID = "fiteo-app-39f91";

const AUTH_EMULATOR =
  "http://127.0.0.1:9099";

const FUNCTION_URL =
  `http://127.0.0.1:5001/${PROJECT_ID}/us-central1/calculateReviewedPlan`;

if (admin.apps.length === 0) {
  admin.initializeApp({
    projectId: PROJECT_ID,
  });
}

const db = admin.firestore();

const validPreferences = {
  age: 25,
  height: 175,
  weight: 80,
  targetWeight: 72,
  gender: "Male",
  goal: "Lose Weight",
  activityLevel: "Moderately Active",
  nutritionPreference: "Balanced",
  workoutPreference: "Mixed",
};

async function createTestUser() {
  const email =
    `test-${Date.now()}-${Math.random()}@fiteo.test`;

  const response = await fetch(
    `${AUTH_EMULATOR}/identitytoolkit.googleapis.com/v1/accounts:signUp?key=fake-key`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        email,
        password: "test-password-123",
        returnSecureToken: true,
      }),
    }
  );

  assert.equal(response.status, 200);

  const data = await response.json();

  await db
    .collection("users")
    .doc(data.localId)
    .set({
      timezone: "Europe/Istanbul",
      userPreferences: {
        ...validPreferences,
      },
      nutritionPlan: {
        dailyCalories: 2200,
      },
    });

  return {
    uid: data.localId,
    idToken: data.idToken,
  };
}

async function setMembership(
  uid,
  {
    isPremium,
    status,
  }
) {
  await db
    .collection("users")
    .doc(uid)
    .collection("membership")
    .doc("current")
    .set({
      isPremium,
      status,
    });
}

async function callReviewedPlan({
  token,
} = {}) {
  const headers = {
    "Content-Type": "application/json",
  };

  if (token) {
    headers.Authorization =
      `Bearer ${token}`;
  }

  return fetch(
    FUNCTION_URL,
    {
      method: "POST",
      headers,
      body: JSON.stringify({
        userPreferences: validPreferences,
        currentCalories: 2300,
        adjustmentDeltaKcal: -150,
      }),
    }
  );
}

async function waitFor(
  check,
  {
    timeoutMs = 8000,
    intervalMs = 200,
  } = {}
) {
  const startedAt = Date.now();

  while (
    Date.now() - startedAt <
    timeoutMs
  ) {
    if (await check()) {
      return;
    }

    await new Promise((resolve) =>
      setTimeout(resolve, intervalMs)
    );
  }

  throw new Error(
    "Timed out waiting for emulator condition"
  );
}

test(
  "calculateReviewedPlan rejects request without auth",
  async () => {
    const response =
      await callReviewedPlan();

    assert.equal(
      response.status,
      401
    );

    const body =
      await response.json();

    assert.equal(
      body.error,
      "Authentication required"
    );
  }
);

test(
  "calculateReviewedPlan rejects invalid auth token",
  async () => {
    const response =
      await callReviewedPlan({
        token: "invalid-token",
      });

    assert.equal(
      response.status,
      401
    );

    const body =
      await response.json();

    assert.equal(
      body.error,
      "Invalid authentication token"
    );
  }
);

test(
  "free user cannot calculate reviewed plan",
  async () => {
    const user =
      await createTestUser();

    await setMembership(
      user.uid,
      {
        isPremium: false,
        status: "free",
      }
    );

    const response =
      await callReviewedPlan({
        token: user.idToken,
      });

    assert.equal(
      response.status,
      403
    );

    const body =
      await response.json();

    assert.equal(
      body.error,
      "Premium membership required"
    );
  }
);

test(
  "inactive premium membership cannot calculate reviewed plan",
  async () => {
    const user =
      await createTestUser();

    await setMembership(
      user.uid,
      {
        isPremium: true,
        status: "inactive",
      }
    );

    const response =
      await callReviewedPlan({
        token: user.idToken,
      });

    assert.equal(
      response.status,
      403
    );
  }
);

test(
  "active premium user can calculate reviewed plan",
  async () => {
    const user =
      await createTestUser();

    await setMembership(
      user.uid,
      {
        isPremium: true,
        status: "active",
      }
    );

    const response =
      await callReviewedPlan({
        token: user.idToken,
      });

    assert.equal(
      response.status,
      200
    );

    const body =
      await response.json();

    assert.ok(body.plan);
    assert.ok(
      Number.isFinite(
        body.plan.calories
      )
    );
  }
);

test(
  "free membership does not initialize plan tracking",
  async () => {
    const user =
      await createTestUser();

    const userRef =
      db.collection("users")
        .doc(user.uid);

    await userRef.set({
      timezone: "Europe/Istanbul",
      userPreferences: {
        ...validPreferences,
      },
      nutritionPlan: {
        dailyCalories: 2200,
      },
    });

    await setMembership(
      user.uid,
      {
        isPremium: false,
        status: "free",
      }
    );

    await new Promise((resolve) =>
      setTimeout(resolve, 1500)
    );

    const tracking =
      await userRef
        .collection("planTracking")
        .doc("current")
        .get();

    assert.equal(
      tracking.exists,
      false
    );
  }
);

test(
  "free to active premium initializes plan tracking",
  async () => {
    const user =
      await createTestUser();

    const userRef =
      db.collection("users")
        .doc(user.uid);

    await userRef.set({
      timezone: "Europe/Istanbul",
      userPreferences: {
        ...validPreferences,
      },
      nutritionPlan: {
        dailyCalories: 2200,
      },
    });

    await setMembership(
      user.uid,
      {
        isPremium: false,
        status: "free",
      }
    );

    await setMembership(
      user.uid,
      {
        isPremium: true,
        status: "active",
      }
    );

    const trackingRef =
      userRef
        .collection("planTracking")
        .doc("current");

    await waitFor(async () => {
      const snapshot =
        await trackingRef.get();

      return snapshot.exists;
    });

    const snapshot =
      await trackingRef.get();

    const data =
      snapshot.data();

    assert.equal(
      data.schemaVersion,
      1
    );

    assert.equal(
      data.planStartWeight,
      80
    );

    assert.equal(
      data.planStatus,
      "notEnoughData"
    );

    assert.equal(
      data.planEligibleDays,
      0
    );

    assert.equal(
      data.calorieTrackedDays,
      0
    );

    assert.deepEqual(
      data.weightPoints,
      []
    );
  }
);

test(
  "already premium membership update does not reinitialize tracking",
  async () => {
    const user =
      await createTestUser();

    const userRef =
      db.collection("users")
        .doc(user.uid);

    await userRef.set({
      timezone: "Europe/Istanbul",
      userPreferences: {
        ...validPreferences,
      },
      nutritionPlan: {
        dailyCalories: 2200,
      },
    });

    await setMembership(
      user.uid,
      {
        isPremium: false,
        status: "free",
      }
    );

    await setMembership(
      user.uid,
      {
        isPremium: true,
        status: "active",
      }
    );

    const trackingRef =
      userRef
        .collection("planTracking")
        .doc("current");

    await waitFor(async () => {
      const snapshot =
        await trackingRef.get();

      return snapshot.exists;
    });

    await trackingRef.set(
      {
        testMarker:
          "must-survive",
      },
      {
        merge: true,
      }
    );

    await setMembership(
      user.uid,
      {
        isPremium: true,
        status: "active",
      }
    );

    await new Promise((resolve) =>
      setTimeout(resolve, 1500)
    );

    const snapshot =
      await trackingRef.get();

    assert.equal(
      snapshot.data().testMarker,
      "must-survive"
    );
  }
);