import { onRequest } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import { anthropicApiKey } from "./client";
import { verifyAuth } from "../middleware/auth";
import { checkSubscription } from "../utils/subscription";
import { checkRateLimit } from "../utils/rateLimiter";

// TODO: Implement receipt parsing with Claude Vision API
// - Accept base64-encoded receipt image
// - Use Claude's vision capability to extract:
//   - Store name
//   - Date
//   - Line items (name, quantity, price)
//   - Total amount
//   - Tax amount
//   - Payment method
// - Return structured JSON for auto-filling transaction form
// - Support Japanese receipts (vertical text, kanji)

export const parseReceipt = onRequest(
  {
    region: "asia-northeast1",
    timeoutSeconds: 60,
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

    const { authorized, tier } = await checkSubscription(
      uid,
      "parseReceipt",
      res
    );
    if (!authorized) return;

    const withinLimit = await checkRateLimit(uid, "parseReceipt", tier, res);
    if (!withinLimit) return;

    // TODO: Implement receipt parsing logic in phase ⑤-3
    logger.info("parseReceipt called", { uid });
    res.status(501).json({
      error: "Not Implemented",
      message: "Receipt parsing is coming soon.",
    });
  }
);
