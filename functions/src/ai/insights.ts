import { onRequest } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import * as admin from "firebase-admin";
import { anthropicApiKey, getAnthropicClient, CLAUDE_MODEL } from "./client";
import { verifyAuth } from "../middleware/auth";
import { checkSubscription } from "../utils/subscription";
import { checkRateLimit } from "../utils/rateLimiter";
import {
  INSIGHT_SYSTEM_PROMPT,
  buildInsightUserPrompt,
  getFallbackInsight,
  getNoDataInsight,
  InsightResponse,
  InsightPromptData,
} from "./prompts";

interface TransactionData {
  amount: number;
  category: string;
  date: string;
  memo?: string;
  type: "income" | "expense";
}

export const generateInsights = onRequest(
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

    // 1. Auth verification
    const uid = await verifyAuth(req, res);
    if (!uid) return;

    // 2. Subscription check
    const { authorized, tier } = await checkSubscription(
      uid,
      "generateInsights",
      res
    );
    if (!authorized) return;

    // 3. Rate limit check
    const withinLimit = await checkRateLimit(
      uid,
      "generateInsights",
      tier,
      res
    );
    if (!withinLimit) return;

    try {
      // 4. Parse request body
      const { yearMonth, locale = "ja" } = req.body as {
        yearMonth?: string;
        locale?: string;
      };

      const targetMonth = yearMonth || getCurrentYearMonth();

      // 5. Check for cached insights
      const cachedInsights = await getCachedInsights(uid, targetMonth);
      if (cachedInsights) {
        logger.info("Returning cached insights", { uid, targetMonth });
        res.status(200).json(cachedInsights);
        return;
      }

      // 6. Fetch spending data
      const transactions = await fetchMonthlyTransactions(uid, targetMonth);

      if (transactions.length === 0) {
        res.status(200).json(getNoDataInsight(locale));
        return;
      }

      // 7. Build prompt data (current + previous month)
      const promptData = await buildPromptData(
        uid,
        targetMonth,
        locale,
        transactions
      );

      // 8. Call Claude API with retry
      const insights = await callClaudeWithRetry(promptData, locale);

      // 9. Cache to Firestore
      await cacheInsights(uid, targetMonth, insights);

      // 10. Return response
      logger.info("Generated new insights", { uid, targetMonth });
      res.status(200).json(insights);
    } catch (error) {
      logger.error("Failed to generate insights", { uid, error });
      res.status(500).json({
        error: "Internal Server Error",
        message: "Failed to generate insights. Please try again later.",
      });
    }
  }
);

// ============================================================
// Claude API call with 1 retry + fallback
// ============================================================

async function callClaudeWithRetry(
  promptData: InsightPromptData,
  locale: string
): Promise<InsightResponse> {
  const client = getAnthropicClient();
  const userPrompt = buildInsightUserPrompt(promptData);

  for (let attempt = 0; attempt < 2; attempt++) {
    try {
      const message = await client.messages.create({
        model: CLAUDE_MODEL,
        max_tokens: 1500,
        temperature: 0.3,
        system: INSIGHT_SYSTEM_PROMPT,
        messages: [{ role: "user", content: userPrompt }],
      });

      const textBlock = message.content.find((b) => b.type === "text");
      if (!textBlock || textBlock.type !== "text") {
        throw new Error("No text block in Claude response");
      }

      const insights: InsightResponse = JSON.parse(textBlock.text);
      insights.generatedAt = new Date().toISOString();
      return insights;
    } catch (error) {
      if (attempt === 0) {
        logger.warn("Claude API call failed, retrying...", { error });
      } else {
        logger.error("Claude API call failed after retry", { error });
      }
    }
  }

  // Both attempts failed — return fallback
  logger.warn("Returning fallback insight", { locale });
  return getFallbackInsight(locale);
}

// ============================================================
// Prompt data builder
// ============================================================

async function buildPromptData(
  uid: string,
  targetMonth: string,
  locale: string,
  transactions: TransactionData[]
): Promise<InsightPromptData> {
  const expenses = transactions.filter((t) => t.type === "expense");
  const totalSpending = expenses.reduce((sum, t) => sum + t.amount, 0);

  // Category breakdown
  const categoryBreakdown: Record<string, number> = {};
  for (const t of expenses) {
    categoryBreakdown[t.category] = (categoryBreakdown[t.category] || 0) + t.amount;
  }

  // Weekly breakdown
  const weeklyData = buildWeeklyData(expenses, targetMonth);

  // Previous month data
  const prevMonth = getPreviousMonth(targetMonth);
  const prevTransactions = await fetchMonthlyTransactions(uid, prevMonth);
  let previousMonthTotal: number | null = null;
  let previousCategoryBreakdown: Record<string, number> | null = null;

  if (prevTransactions.length > 0) {
    const prevExpenses = prevTransactions.filter((t) => t.type === "expense");
    previousMonthTotal = prevExpenses.reduce((sum, t) => sum + t.amount, 0);
    previousCategoryBreakdown = {};
    for (const t of prevExpenses) {
      previousCategoryBreakdown[t.category] =
        (previousCategoryBreakdown[t.category] || 0) + t.amount;
    }
  }

  return {
    locale,
    yearMonth: targetMonth,
    totalSpending,
    categoryBreakdown,
    previousMonthTotal,
    previousCategoryBreakdown,
    weeklyData,
    transactionCount: transactions.length,
  };
}

function buildWeeklyData(
  expenses: TransactionData[],
  yearMonth: string
): Record<string, number> {
  const [year, month] = yearMonth.split("-").map(Number);
  const lastDay = new Date(year, month, 0).getDate();

  // Define week boundaries
  const weeks: { label: string; start: number; end: number }[] = [
    { label: `Week 1 (${month}/1-${month}/7)`, start: 1, end: 7 },
    { label: `Week 2 (${month}/8-${month}/14)`, start: 8, end: 14 },
    { label: `Week 3 (${month}/15-${month}/21)`, start: 15, end: 21 },
    { label: `Week 4 (${month}/22-${month}/${lastDay})`, start: 22, end: lastDay },
  ];

  const result: Record<string, number> = {};
  for (const week of weeks) {
    result[week.label] = 0;
  }

  for (const t of expenses) {
    const date = new Date(t.date);
    const day = date.getDate();
    const week = weeks.find((w) => day >= w.start && day <= w.end);
    if (week) {
      result[week.label] += t.amount;
    }
  }

  return result;
}

// ============================================================
// Firestore helpers
// ============================================================

function getCurrentYearMonth(): string {
  const now = new Date();
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}`;
}

function getPreviousMonth(yearMonth: string): string {
  const [year, month] = yearMonth.split("-").map(Number);
  if (month === 1) {
    return `${year - 1}-12`;
  }
  return `${year}-${String(month - 1).padStart(2, "0")}`;
}

async function getCachedInsights(
  uid: string,
  yearMonth: string
): Promise<InsightResponse | null> {
  try {
    const doc = await admin
      .firestore()
      .collection("users")
      .doc(uid)
      .collection("insights")
      .doc(yearMonth)
      .get();

    if (!doc.exists) return null;

    const data = doc.data() as InsightResponse & { cachedAt?: string };
    if (!data.cachedAt) return null;

    // Cache is valid for 24 hours
    const cachedAt = new Date(data.cachedAt);
    const hoursSinceCache =
      (Date.now() - cachedAt.getTime()) / (1000 * 60 * 60);

    if (hoursSinceCache > 24) return null;

    return data;
  } catch {
    return null;
  }
}

async function cacheInsights(
  uid: string,
  yearMonth: string,
  insights: InsightResponse
): Promise<void> {
  try {
    await admin
      .firestore()
      .collection("users")
      .doc(uid)
      .collection("insights")
      .doc(yearMonth)
      .set(
        {
          ...insights,
          cachedAt: new Date().toISOString(),
        },
        { merge: true }
      );
  } catch (error) {
    logger.warn("Failed to cache insights", { uid, yearMonth, error });
  }
}

async function fetchMonthlyTransactions(
  uid: string,
  yearMonth: string
): Promise<TransactionData[]> {
  const [year, month] = yearMonth.split("-").map(Number);
  const startDate = new Date(year, month - 1, 1);
  const endDate = new Date(year, month, 0, 23, 59, 59);

  const snapshot = await admin
    .firestore()
    .collection("users")
    .doc(uid)
    .collection("transactions")
    .where("date", ">=", startDate.toISOString())
    .where("date", "<=", endDate.toISOString())
    .orderBy("date")
    .get();

  return snapshot.docs.map((doc) => doc.data() as TransactionData);
}
