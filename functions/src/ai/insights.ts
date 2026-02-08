import { onRequest } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import * as admin from "firebase-admin";
import { anthropicApiKey, getAnthropicClient, CLAUDE_MODEL } from "./client";
import { verifyAuth } from "../middleware/auth";
import { checkSubscription } from "../utils/subscription";
import { checkRateLimit } from "../utils/rateLimiter";

const SYSTEM_PROMPT = `You are a financial advisor AI for Hareru, a Japanese household account book app.
Analyze the user's monthly spending data and provide actionable insights.

You MUST respond with valid JSON only, no markdown or extra text.

Response format:
{
  "healthScore": <number 0-100>,
  "healthLabel": "<short label>",
  "savingsPotential": <number in JPY>,
  "topInsight": "<most important insight, 1-2 sentences>",
  "weeklyTrend": "<spending pattern observation>",
  "suggestions": ["<suggestion 1>", "<suggestion 2>", "<suggestion 3>"],
  "generatedAt": "<ISO 8601 timestamp>"
}

Guidelines:
- healthScore: 0-30 = needs attention, 31-60 = fair, 61-80 = good, 81-100 = excellent
- healthLabel: match the user's locale (e.g. 良好, 좋음, Good)
- savingsPotential: realistic monthly savings estimate in JPY
- suggestions: 2-4 concrete, actionable tips
- Respond in the language matching the user's locale setting
- Consider Japanese living costs and spending patterns
- Be encouraging but honest`;

interface InsightsResponse {
  healthScore: number;
  healthLabel: string;
  savingsPotential: number;
  topInsight: string;
  weeklyTrend: string;
  suggestions: string[];
  generatedAt: string;
}

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
    // Only allow POST
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

      const targetMonth =
        yearMonth || getCurrentYearMonth();

      // 5. Check for cached insights
      const cachedInsights = await getCachedInsights(uid, targetMonth);
      if (cachedInsights) {
        logger.info("Returning cached insights", { uid, targetMonth });
        res.status(200).json(cachedInsights);
        return;
      }

      // 6. Fetch spending data from Firestore
      const transactions = await fetchMonthlyTransactions(uid, targetMonth);

      if (transactions.length === 0) {
        res.status(200).json({
          healthScore: 0,
          healthLabel: getNoDataLabel(locale),
          savingsPotential: 0,
          topInsight: getNoDataMessage(locale),
          weeklyTrend: "",
          suggestions: [],
          generatedAt: new Date().toISOString(),
        });
        return;
      }

      // 7. Call Claude API
      const client = getAnthropicClient();
      const userPrompt = buildUserPrompt(transactions, targetMonth, locale);

      const message = await client.messages.create({
        model: CLAUDE_MODEL,
        max_tokens: 1024,
        system: SYSTEM_PROMPT,
        messages: [{ role: "user", content: userPrompt }],
      });

      // 8. Parse response
      const textBlock = message.content.find((block) => block.type === "text");
      if (!textBlock || textBlock.type !== "text") {
        throw new Error("No text response from Claude API");
      }

      const insights: InsightsResponse = JSON.parse(textBlock.text);
      insights.generatedAt = new Date().toISOString();

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

function getCurrentYearMonth(): string {
  const now = new Date();
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}`;
}

async function getCachedInsights(
  uid: string,
  yearMonth: string
): Promise<InsightsResponse | null> {
  try {
    const doc = await admin
      .firestore()
      .collection("users")
      .doc(uid)
      .collection("insights")
      .doc(yearMonth)
      .get();

    if (!doc.exists) return null;

    const data = doc.data() as InsightsResponse & { cachedAt?: string };
    if (!data.cachedAt) return null;

    // Cache is valid for 24 hours
    const cachedAt = new Date(data.cachedAt);
    const now = new Date();
    const hoursSinceCache =
      (now.getTime() - cachedAt.getTime()) / (1000 * 60 * 60);

    if (hoursSinceCache > 24) return null;

    return data;
  } catch {
    return null;
  }
}

async function cacheInsights(
  uid: string,
  yearMonth: string,
  insights: InsightsResponse
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

function buildUserPrompt(
  transactions: TransactionData[],
  yearMonth: string,
  locale: string
): string {
  const expenses = transactions.filter((t) => t.type === "expense");
  const incomes = transactions.filter((t) => t.type === "income");

  const totalExpense = expenses.reduce((sum, t) => sum + t.amount, 0);
  const totalIncome = incomes.reduce((sum, t) => sum + t.amount, 0);

  // Group expenses by category
  const byCategory: Record<string, number> = {};
  for (const t of expenses) {
    byCategory[t.category] = (byCategory[t.category] || 0) + t.amount;
  }

  const categorySummary = Object.entries(byCategory)
    .sort(([, a], [, b]) => b - a)
    .map(([cat, amount]) => `  ${cat}: ¥${amount.toLocaleString()}`)
    .join("\n");

  const localeInstruction =
    locale === "ko"
      ? "한국어로 응답해주세요."
      : locale === "en"
        ? "Respond in English."
        : "日本語で応答してください。";

  return `${localeInstruction}

Analyze this spending data for ${yearMonth}:

Total Income: ¥${totalIncome.toLocaleString()}
Total Expenses: ¥${totalExpense.toLocaleString()}
Number of transactions: ${transactions.length}

Expense breakdown by category:
${categorySummary}

Please provide financial insights and actionable suggestions.`;
}

function getNoDataLabel(locale: string): string {
  if (locale === "ko") return "데이터 없음";
  if (locale === "en") return "No data";
  return "データなし";
}

function getNoDataMessage(locale: string): string {
  if (locale === "ko") return "이번 달 거래 내역이 없습니다. 지출을 기록해 주세요.";
  if (locale === "en") return "No transactions found for this month. Start recording your expenses.";
  return "今月の取引データがありません。支出を記録してください。";
}
