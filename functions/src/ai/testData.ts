import { InsightPromptData } from "./prompts";

// ============================================================
// Test scenarios for insight prompt development.
// These are used by testPrompt.ts for local testing.
// ============================================================

/** Scenario 1: Healthy spending pattern (expected healthScore 80+) */
export const SCENARIO_HEALTHY: InsightPromptData = {
  locale: "ja",
  yearMonth: "2025-01",
  totalSpending: 185000,
  categoryBreakdown: {
    "食費": 45000,
    "住居費": 70000,
    "趣味・娯楽": 15000,
    "交通費": 12000,
    "日用品": 10000,
    "通信費": 8000,
    "衣服": 5000,
    "その他": 20000,
  },
  previousMonthTotal: 195000,
  previousCategoryBreakdown: {
    "食費": 50000,
    "住居費": 70000,
    "趣味・娯楽": 18000,
    "交通費": 13000,
    "日用品": 11000,
    "通信費": 8000,
    "衣服": 8000,
    "その他": 17000,
  },
  weeklyData: {
    "Week 1 (1/1-1/7)": 42000,
    "Week 2 (1/8-1/14)": 48000,
    "Week 3 (1/15-1/21)": 50000,
    "Week 4 (1/22-1/31)": 45000,
  },
  transactionCount: 52,
};

/** Scenario 2: Needs attention pattern (expected healthScore 50-60) */
export const SCENARIO_WARNING: InsightPromptData = {
  locale: "ja",
  yearMonth: "2025-01",
  totalSpending: 280000,
  categoryBreakdown: {
    "食費": 85000,
    "住居費": 70000,
    "趣味・娯楽": 45000,
    "外食": 32000,
    "交通費": 15000,
    "衣服": 15000,
    "通信費": 8000,
    "その他": 10000,
  },
  previousMonthTotal: 220000,
  previousCategoryBreakdown: {
    "食費": 55000,
    "住居費": 70000,
    "趣味・娯楽": 25000,
    "外食": 20000,
    "交通費": 14000,
    "衣服": 10000,
    "通信費": 8000,
    "その他": 18000,
  },
  weeklyData: {
    "Week 1 (1/1-1/7)": 45000,
    "Week 2 (1/8-1/14)": 55000,
    "Week 3 (1/15-1/21)": 95000,
    "Week 4 (1/22-1/31)": 85000,
  },
  transactionCount: 78,
};

/** Scenario 3: Insufficient data / first month (expected healthScore ~60-70) */
export const SCENARIO_NEW_USER: InsightPromptData = {
  locale: "ja",
  yearMonth: "2025-01",
  totalSpending: 45000,
  categoryBreakdown: {
    "食費": 20000,
    "交通費": 5000,
    "その他": 20000,
  },
  previousMonthTotal: null,
  previousCategoryBreakdown: null,
  weeklyData: {
    "Week 1 (1/1-1/7)": 45000,
    "Week 2 (1/8-1/14)": 0,
    "Week 3 (1/15-1/21)": 0,
    "Week 4 (1/22-1/31)": 0,
  },
  transactionCount: 8,
};

/** All scenarios for batch testing */
export const ALL_SCENARIOS = [
  { name: "Healthy spending", data: SCENARIO_HEALTHY },
  { name: "Needs attention", data: SCENARIO_WARNING },
  { name: "New user (sparse data)", data: SCENARIO_NEW_USER },
] as const;

export const TEST_LOCALES = ["ja", "ko", "en"] as const;
