import * as admin from "firebase-admin";
import { logger } from "firebase-functions/v2";
import { Response } from "express";

export type SubscriptionTier = "free" | "clear" | "clearPro";

type FeatureName = "generateInsights" | "parseReceipt" | "aiCoach";

const featureAccess: Record<FeatureName, SubscriptionTier[]> = {
  generateInsights: ["clear", "clearPro"],
  parseReceipt: ["clearPro"],
  aiCoach: ["clearPro"],
};

/**
 * Fetches the user's subscription tier from Firestore.
 */
export async function getSubscriptionTier(
  uid: string
): Promise<SubscriptionTier> {
  try {
    const userDoc = await admin
      .firestore()
      .collection("users")
      .doc(uid)
      .get();

    if (!userDoc.exists) {
      return "free";
    }

    const tier = userDoc.data()?.subscriptionTier as SubscriptionTier | undefined;
    return tier ?? "free";
  } catch (error) {
    logger.error("Failed to fetch subscription tier", { uid, error });
    return "free";
  }
}

/**
 * Checks if the user's subscription allows access to the given feature.
 * Sends a 403 response if not authorized, returns false.
 * Returns true if authorized.
 */
export async function checkSubscription(
  uid: string,
  feature: FeatureName,
  res: Response
): Promise<{ authorized: boolean; tier: SubscriptionTier }> {
  const tier = await getSubscriptionTier(uid);
  const allowedTiers = featureAccess[feature];

  if (!allowedTiers.includes(tier)) {
    res.status(403).json({
      error: "Forbidden",
      message: `This feature requires a ${allowedTiers.join(" or ")} subscription.`,
      currentTier: tier,
      requiredTiers: allowedTiers,
      upgradeUrl: "https://hareru.app/pricing",
    });
    return { authorized: false, tier };
  }

  return { authorized: true, tier };
}
