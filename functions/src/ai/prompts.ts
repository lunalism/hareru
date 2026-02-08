// ============================================================
// Hareru AI Insight Prompts
// All prompts are written in English for Claude API stability.
// Response language is controlled via the {locale} variable.
// ============================================================

/** TypeScript interface for the insight response JSON */
export interface InsightResponse {
  healthScore: number;
  healthLabel: string;
  healthDescription: string;
  savingsPotential: number;
  savingsDescription: string;
  topInsight: string;
  categoryHighlight: {
    category: string;
    amount: number;
    message: string;
  } | null;
  weeklyTrend: string;
  suggestions: [string, string, string];
  encouragement: string;
  generatedAt: string;
}

/** Data shape passed into the user prompt template */
export interface InsightPromptData {
  locale: string;
  yearMonth: string;
  totalSpending: number;
  categoryBreakdown: Record<string, number>;
  previousMonthTotal: number | null;
  previousCategoryBreakdown: Record<string, number> | null;
  weeklyData: Record<string, number>;
  transactionCount: number;
}

// ============================================================
// SYSTEM PROMPT
// ============================================================

export const INSIGHT_SYSTEM_PROMPT = `You are a household finance analysis advisor built into Hareru, a Japanese kakeibo (household account book) app whose brand message is "making household finances clear" (가계를 맑게 / 家計を晴れやかに).

## Your Role
You analyze monthly spending data and provide warm, encouraging financial insights. You never reveal your name — you simply deliver analysis naturally as part of the app experience.

## Core Principles

1. **Clean data awareness**: The data you receive excludes internal transfers (振替) and includes only genuine income and expense transactions. Mention this naturally once — e.g., "Looking at your actual spending (transfers excluded)..." — so the user understands the data quality.

2. **Positive framing only**: NEVER use negative words like 無駄遣い (waste), 浪費 (extravagance), 使いすぎ (overspending), or 낭비. Instead, frame everything as opportunity:
   - "節約のチャンス" (savings opportunity)
   - "見直しポイント" (review point)
   - "余裕を作れるところ" (where you can create breathing room)
   - "절약 기회" / "savings opportunity" for ko/en

3. **Japanese kakeibo culture**: Naturally weave in Japanese household budgeting concepts when relevant:
   - 袋分け (envelope budgeting)
   - 先取り貯金 (pay-yourself-first savings)
   - やりくり (making ends meet skillfully)
   - 固定費の見直し (reviewing fixed costs)
   - Use equivalent cultural references for ko/en locales

4. **Concrete amounts**: Always show specific yen amounts when suggesting savings — e.g., "月に約3,000円の余裕が生まれます" instead of vague advice.

5. **Seasonal awareness**: Consider the time of year in your analysis:
   - Jan: New Year spending recovery, 初売り aftermath
   - Mar-Apr: 新学期 (new school term) preparation, 引っ越し season
   - Jul-Aug: お盆, summer vacation expenses
   - Nov-Dec: 年末 bonus season, クリスマス, 忘年会
   - Adjust cultural references based on locale

## Strictly Prohibited
- Investment advice of any kind
- Insurance or financial product recommendations
- Judgments about income level or earnings
- Mentioning other apps, services, or competitors
- Markdown formatting in your response

## Health Score Criteria
- **90-100**: Very healthy — spending decreased vs. last month AND well-balanced across categories
- **70-89**: Good — stable spending patterns with minor optimization opportunities
- **50-69**: Needs attention — significant increase in specific categories or overall spending
- **0-49**: Room for improvement — broad overspending across multiple categories
- If no previous month data is available, base the score purely on category balance and absolute amounts relative to typical Japanese household benchmarks

## Health Labels by Locale
Use these EXACT labels based on healthScore range:

Japanese (ja):
- 90-100: "とても健全"
- 70-89: "良好"
- 50-69: "要注意"
- 0-49: "改善しましょう"

Korean (ko):
- 90-100: "매우 건강"
- 70-89: "양호"
- 50-69: "주의 필요"
- 0-49: "개선이 필요해요"

English (en):
- 90-100: "Excellent"
- 70-89: "Good"
- 50-69: "Needs Attention"
- 0-49: "Let's Improve"

## Response Format
You MUST respond with a single valid JSON object. No markdown code fences, no extra text before or after. The JSON schema is:

{
  "healthScore": <number 0-100>,
  "healthLabel": "<exact label from the table above matching score and locale>",
  "healthDescription": "<1-2 sentence description of the health score>",
  "savingsPotential": <number in JPY, realistic estimate>,
  "savingsDescription": "<1 sentence explaining how to achieve the savings>",
  "topInsight": "<the single most important finding, 1-2 sentences>",
  "categoryHighlight": {
    "category": "<category name in the user's locale>",
    "amount": <number in JPY>,
    "message": "<1 sentence about this category>"
  },
  "weeklyTrend": "<1 sentence about weekly spending pattern>",
  "suggestions": ["<concrete tip 1>", "<concrete tip 2>", "<concrete tip 3>"],
  "encouragement": "<1 sentence warm closing message>"
}

All string values must be in the language specified by the locale parameter.`;

// ============================================================
// USER PROMPT TEMPLATE
// ============================================================

export const INSIGHT_USER_PROMPT_TEMPLATE = `Analyze the following monthly spending data and generate financial insights.

**Response language**: {locale_instruction}

**Analysis period**: {yearMonth}
**Total spending**: ¥{totalSpending}
**Transaction count**: {transactionCount}

**Spending by category** (descending by amount):
{categoryBreakdown}

**Previous month comparison**:
{previousMonthSection}

**Weekly spending breakdown**:
{weeklyData}

Generate the insight JSON response following the system prompt schema exactly.`;

// ============================================================
// TEMPLATE BUILDER
// ============================================================

export function buildInsightUserPrompt(data: InsightPromptData): string {
  const localeInstruction =
    data.locale === "ko"
      ? "Respond in Korean (한국어)"
      : data.locale === "en"
        ? "Respond in English"
        : "Respond in Japanese (日本語)";

  const categoryLines = Object.entries(data.categoryBreakdown)
    .sort(([, a], [, b]) => b - a)
    .map(([cat, amount]) => `  - ${cat}: ¥${amount.toLocaleString()}`)
    .join("\n");

  let previousMonthSection: string;
  if (data.previousMonthTotal !== null && data.previousCategoryBreakdown !== null) {
    const diff = data.totalSpending - data.previousMonthTotal;
    const diffSign = diff >= 0 ? "+" : "";
    const prevCategoryLines = Object.entries(data.previousCategoryBreakdown)
      .sort(([, a], [, b]) => b - a)
      .map(([cat, amount]) => `  - ${cat}: ¥${amount.toLocaleString()}`)
      .join("\n");
    previousMonthSection =
      `Previous month total: ¥${data.previousMonthTotal.toLocaleString()} (${diffSign}¥${diff.toLocaleString()} change)\n` +
      `Previous month by category:\n${prevCategoryLines}`;
  } else {
    previousMonthSection = "No previous month data available (first month of usage).";
  }

  const weeklyLines = Object.entries(data.weeklyData)
    .map(([week, amount]) => `  - ${week}: ¥${amount.toLocaleString()}`)
    .join("\n");

  return INSIGHT_USER_PROMPT_TEMPLATE
    .replace("{locale_instruction}", localeInstruction)
    .replace("{yearMonth}", data.yearMonth)
    .replace("{totalSpending}", data.totalSpending.toLocaleString())
    .replace("{transactionCount}", String(data.transactionCount))
    .replace("{categoryBreakdown}", categoryLines)
    .replace("{previousMonthSection}", previousMonthSection)
    .replace("{weeklyData}", weeklyLines || "  Insufficient data for weekly breakdown.");
}

// ============================================================
// FALLBACK INSIGHTS (when Claude API fails)
// ============================================================

export function getFallbackInsight(locale: string): InsightResponse {
  if (locale === "ko") {
    return {
      healthScore: 50,
      healthLabel: "주의 필요",
      healthDescription: "분석 데이터를 준비 중입니다.",
      savingsPotential: 0,
      savingsDescription: "다음 분석에서 절약 포인트를 찾아드릴게요.",
      topInsight: "이번 달 지출 기록을 확인해주세요.",
      categoryHighlight: null,
      weeklyTrend: "데이터를 모으는 중입니다.",
      suggestions: [
        "매일 지출을 기록하는 습관을 만들어 보세요.",
        "고정비를 먼저 정리하면 전체 흐름이 보여요.",
        "일주일 단위로 예산을 세워보는 것도 좋아요.",
      ],
      encouragement: "기록을 계속하면 더 정확한 분석을 받을 수 있어요!",
      generatedAt: new Date().toISOString(),
    };
  }

  if (locale === "en") {
    return {
      healthScore: 50,
      healthLabel: "Needs Attention",
      healthDescription: "We're preparing your analysis data.",
      savingsPotential: 0,
      savingsDescription: "We'll find savings opportunities in your next analysis.",
      topInsight: "Please review your spending records for this month.",
      categoryHighlight: null,
      weeklyTrend: "Still gathering data.",
      suggestions: [
        "Try building a habit of recording daily expenses.",
        "Start by organizing your fixed costs for a clearer picture.",
        "Setting a weekly budget can help you stay on track.",
      ],
      encouragement: "Keep recording — the more data we have, the better insights you'll get!",
      generatedAt: new Date().toISOString(),
    };
  }

  // Default: Japanese
  return {
    healthScore: 50,
    healthLabel: "要注意",
    healthDescription: "分析データを準備中です。",
    savingsPotential: 0,
    savingsDescription: "次の分析で節約ポイントをお探しします。",
    topInsight: "今月の支出記録をご確認ください。",
    categoryHighlight: null,
    weeklyTrend: "データを収集中です。",
    suggestions: [
      "毎日の支出を記録する習慣をつけてみましょう。",
      "まずは固定費を整理すると、全体の流れが見えてきます。",
      "一週間単位で予算を立ててみるのもおすすめです。",
    ],
    encouragement: "記録を続けると、より正確な分析ができるようになりますよ！",
    generatedAt: new Date().toISOString(),
  };
}

// ============================================================
// RECEIPT PARSING PROMPTS
// ============================================================

export interface ReceiptParseResponse {
  amount: number;
  storeName: string;
  date: string;
  category: string;
  categoryConfidence: number;
  items: Array<{ name: string; price: number; quantity: number }>;
  tax: number;
  discount: number;
  paymentMethod: string | null;
  memo: string | null;
}

export const RECEIPT_SYSTEM_PROMPT = `You are a Japanese receipt parser built into Hareru, a household account book app. Your job is to extract structured data from OCR-recognized receipt text.

## Your Capabilities
- Parse Japanese receipts including convenience stores, supermarkets, restaurants, drugstores, transit, and general retail
- Handle imperfect OCR text (missing characters, line breaks, garbled text)
- Recognize Japanese date formats (yyyy/mm/dd, yyyy年mm月dd日, 令和yy年mm月dd日)
- Identify common Japanese store names and categorize purchases

## Category Mapping
Assign one of these exact category keys:
- "food" — Supermarkets, grocery stores, convenience store food items
- "cafe" — Restaurants, cafes, fast food, izakaya, delivery food
- "transport" — Train, bus, taxi, parking, gas station, IC card charge
- "shopping" — Drugstores, 100-yen shops, home centers, clothing, general retail
- "medical" — Hospitals, clinics, pharmacies (調剤), dental
- "entertainment" — Books, games, cinema, electronics, beauty salons, sports
- "other" — Anything that doesn't fit above

## categoryConfidence
- 0.95: Store name clearly matches a known category (e.g. セブンイレブン → food)
- 0.8: Strong keyword evidence in receipt text
- 0.6: Weak or ambiguous evidence
- 0.3: Best guess with little evidence

## Response Format
Respond with a single valid JSON object. No markdown, no extra text:

{
  "amount": <total amount in JPY as integer>,
  "storeName": "<store name or empty string>",
  "date": "<ISO date yyyy-MM-dd or empty string>",
  "category": "<category key from list above>",
  "categoryConfidence": <0.0-1.0>,
  "items": [{"name": "<item>", "price": <JPY int>, "quantity": <int>}],
  "tax": <tax amount in JPY or 0>,
  "discount": <discount amount in JPY or 0>,
  "paymentMethod": "<cash/card/IC card/QR pay or null>",
  "memo": "<brief note about the purchase or null>"
}

## Rules
- If a field cannot be determined, use the default (0 for numbers, "" for strings, null for optional)
- Amount should be the final total (税込 / total after tax)
- Items list should include individual line items if visible; omit if not readable
- Date should be in ISO format (yyyy-MM-dd)
- paymentMethod: look for keywords like 現金, クレジット, カード, Suica, PayPay, etc.
- memo: generate a brief 1-line summary of what was purchased (in the user's locale)`;

export const RECEIPT_USER_PROMPT_TEMPLATE = `Parse the following OCR text from a Japanese receipt and extract structured data.

**Response language for memo field**: {locale_instruction}

**OCR Text**:
{rawText}

Generate the receipt JSON response following the system prompt schema exactly.`;

export function buildReceiptUserPrompt(rawText: string, locale: string): string {
  const localeInstruction =
    locale === "ko"
      ? "Korean (한국어)"
      : locale === "en"
        ? "English"
        : "Japanese (日本語)";

  return RECEIPT_USER_PROMPT_TEMPLATE
    .replace("{locale_instruction}", localeInstruction)
    .replace("{rawText}", rawText);
}

// ============================================================
// NO-DATA RESPONSE (zero transactions)
// ============================================================

export function getNoDataInsight(locale: string): InsightResponse {
  if (locale === "ko") {
    return {
      healthScore: 0,
      healthLabel: "데이터 없음",
      healthDescription: "이번 달 거래 내역이 없습니다.",
      savingsPotential: 0,
      savingsDescription: "",
      topInsight: "지출을 기록하면 맞춤 인사이트를 받을 수 있어요.",
      categoryHighlight: null,
      weeklyTrend: "",
      suggestions: [
        "첫 지출을 기록해 보세요!",
        "고정비(월세, 통신비 등)부터 입력하면 편해요.",
        "영수증이 있다면 바로 기록해 보세요.",
      ],
      encouragement: "첫 기록이 가장 중요한 한 걸음이에요!",
      generatedAt: new Date().toISOString(),
    };
  }

  if (locale === "en") {
    return {
      healthScore: 0,
      healthLabel: "No Data",
      healthDescription: "No transactions found for this month.",
      savingsPotential: 0,
      savingsDescription: "",
      topInsight: "Start recording your expenses to get personalized insights.",
      categoryHighlight: null,
      weeklyTrend: "",
      suggestions: [
        "Record your first expense to get started!",
        "Start with fixed costs like rent and utilities.",
        "If you have a receipt handy, log it now.",
      ],
      encouragement: "Your first record is the most important step!",
      generatedAt: new Date().toISOString(),
    };
  }

  return {
    healthScore: 0,
    healthLabel: "データなし",
    healthDescription: "今月の取引データがありません。",
    savingsPotential: 0,
    savingsDescription: "",
    topInsight: "支出を記録すると、あなたに合ったインサイトが届きます。",
    categoryHighlight: null,
    weeklyTrend: "",
    suggestions: [
      "最初の支出を記録してみましょう！",
      "家賃や通信費などの固定費から入力すると楽ですよ。",
      "レシートがあれば、今すぐ記録してみてください。",
    ],
    encouragement: "最初の一歩が一番大切です！",
    generatedAt: new Date().toISOString(),
  };
}
