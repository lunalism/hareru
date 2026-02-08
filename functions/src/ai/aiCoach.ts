import { onRequest } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import { anthropicApiKey } from "./client";
import { verifyAuth } from "../middleware/auth";
import { checkSubscription } from "../utils/subscription";
import { checkRateLimit } from "../utils/rateLimiter";

// TODO: Implement AI financial coaching
// - Accept user question/context about their finances
// - Use conversation history for context-aware responses
// - Provide personalized advice based on spending patterns
// - Support multi-turn conversations
// - Respond in user's preferred language (ja/ko/en)

export const aiCoach = onRequest(
  {
    region: "asia-northeast1",
    timeoutSeconds: 120,
    memory: "512MiB",
    secrets: [anthropicApiKey],
    cors: true,
  },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).json({ error: "Method Not Allowed" });
      return;
    }

    const uid = await verifyAuth(req, res);
    if (!uid) return;

    const { authorized, tier } = await checkSubscription(uid, "aiCoach", res);
    if (!authorized) return;

    const withinLimit = await checkRateLimit(uid, "aiCoach", tier, res);
    if (!withinLimit) return;

    // TODO: Implement AI coaching logic
    logger.info("aiCoach called", { uid });
    res.status(501).json({
      error: "Not Implemented",
      message: "AI coaching is coming soon.",
    });
  }
);
