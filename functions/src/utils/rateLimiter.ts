import * as admin from "firebase-admin";
import { logger } from "firebase-functions/v2";
import { Response } from "express";
import { SubscriptionTier } from "./subscription";

type FeatureName = "generateInsights" | "parseReceipt" | "aiCoach";

/** Daily limits per subscription tier and feature */
const dailyLimits: Record<SubscriptionTier, Partial<Record<FeatureName, number>>> = {
  free: {},
  clear: {
    generateInsights: 3,
  },
  clearPro: {
    generateInsights: 5,
    parseReceipt: 20,
    aiCoach: 10,
  },
};

function getTodayKey(): string {
  const now = new Date();
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}-${String(now.getDate()).padStart(2, "0")}`;
}

function getYearMonthKey(): string {
  const now = new Date();
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}`;
}

/**
 * Checks and increments the rate limit for a user/feature combination.
 * Uses Firestore: users/{uid}/apiUsage/{yearMonth}
 *
 * Returns true if within limits, false if limit exceeded (sends 429 response).
 */
export async function checkRateLimit(
  uid: string,
  feature: FeatureName,
  tier: SubscriptionTier,
  res: Response
): Promise<boolean> {
  const limit = dailyLimits[tier]?.[feature];

  if (limit === undefined) {
    // No limit defined means the feature isn't available for this tier
    // (should be caught by subscription check first)
    res.status(403).json({
      error: "Forbidden",
      message: "Feature not available for your subscription tier.",
    });
    return false;
  }

  const yearMonth = getYearMonthKey();
  const todayKey = getTodayKey();
  const usageRef = admin
    .firestore()
    .collection("users")
    .doc(uid)
    .collection("apiUsage")
    .doc(yearMonth);

  try {
    const result = await admin.firestore().runTransaction(async (tx) => {
      const doc = await tx.get(usageRef);
      const data = doc.data() || {};

      const featureUsage = data[feature] || {};
      const currentCount: number = featureUsage[todayKey] || 0;

      if (currentCount >= limit) {
        return { allowed: false, currentCount, limit };
      }

      tx.set(
        usageRef,
        {
          [feature]: {
            [todayKey]: currentCount + 1,
          },
        },
        { merge: true }
      );

      return { allowed: true, currentCount: currentCount + 1, limit };
    });

    if (!result.allowed) {
      res.status(429).json({
        error: "Too Many Requests",
        message: `Daily limit of ${limit} reached for ${feature}. Resets at midnight (JST).`,
        usage: {
          current: result.currentCount,
          limit: result.limit,
        },
      });
      return false;
    }

    return true;
  } catch (error) {
    logger.error("Rate limiter error", { uid, feature, error });
    // Fail open: allow the request if rate limiting fails
    return true;
  }
}
