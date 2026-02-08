import { onRequest } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import { getAnthropicClient, CLAUDE_MODEL, anthropicApiKey } from "./client";
import { verifyAuth } from "../middleware/auth";
import { checkSubscription } from "../utils/subscription";
import { checkRateLimit } from "../utils/rateLimiter";
import {
  RECEIPT_SYSTEM_PROMPT,
  buildReceiptUserPrompt,
  ReceiptParseResponse,
} from "./prompts";

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

    const { rawText, locale = "ja" } = req.body;
    if (!rawText || typeof rawText !== "string" || rawText.trim().length === 0) {
      res.status(400).json({ error: "rawText is required" });
      return;
    }

    try {
      const result = await callClaudeForReceipt(rawText, locale);
      logger.info("parseReceipt success", { uid, storeName: result.storeName });
      res.status(200).json(result);
    } catch (error) {
      logger.error("parseReceipt error", { uid, error });
      res.status(500).json({
        error: "Internal Server Error",
        message: "Failed to parse receipt. Please try again.",
      });
    }
  }
);

async function callClaudeForReceipt(
  rawText: string,
  locale: string
): Promise<ReceiptParseResponse> {
  const client = getAnthropicClient();
  const userPrompt = buildReceiptUserPrompt(rawText, locale);

  const response = await client.messages.create({
    model: CLAUDE_MODEL,
    max_tokens: 1000,
    temperature: 0.1,
    system: RECEIPT_SYSTEM_PROMPT,
    messages: [{ role: "user", content: userPrompt }],
  });

  const text =
    response.content[0].type === "text" ? response.content[0].text : "";

  // Parse and validate JSON response
  const parsed = JSON.parse(text) as ReceiptParseResponse;

  return {
    amount: typeof parsed.amount === "number" ? Math.round(parsed.amount) : 0,
    storeName: parsed.storeName || "",
    date: parsed.date || "",
    category: parsed.category || "other",
    categoryConfidence:
      typeof parsed.categoryConfidence === "number"
        ? parsed.categoryConfidence
        : 0.5,
    items: Array.isArray(parsed.items)
      ? parsed.items.map((item) => ({
          name: item.name || "",
          price: typeof item.price === "number" ? Math.round(item.price) : 0,
          quantity:
            typeof item.quantity === "number" ? Math.round(item.quantity) : 1,
        }))
      : [],
    tax: typeof parsed.tax === "number" ? Math.round(parsed.tax) : 0,
    discount:
      typeof parsed.discount === "number" ? Math.round(parsed.discount) : 0,
    paymentMethod: parsed.paymentMethod || null,
    memo: parsed.memo || null,
  };
}
