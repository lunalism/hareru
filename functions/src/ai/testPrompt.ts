/**
 * Local prompt testing script.
 *
 * Tests all 3 scenarios × 3 locales = 9 Claude API calls.
 * Validates that each response is valid JSON matching InsightResponse.
 *
 * Usage:
 *   1. Set your API key:  export ANTHROPIC_API_KEY="sk-ant-..."
 *   2. Run:               npx ts-node src/ai/testPrompt.ts
 *
 * ⚠️ This makes real API calls and will consume credits.
 *    Uncomment the main() call at the bottom to enable.
 */

import Anthropic from "@anthropic-ai/sdk";
import {
  INSIGHT_SYSTEM_PROMPT,
  buildInsightUserPrompt,
  InsightResponse,
  InsightPromptData,
} from "./prompts";
import { ALL_SCENARIOS, TEST_LOCALES } from "./testData";
import { CLAUDE_MODEL } from "./client";

const REQUIRED_FIELDS: (keyof InsightResponse)[] = [
  "healthScore",
  "healthLabel",
  "healthDescription",
  "savingsPotential",
  "savingsDescription",
  "topInsight",
  "categoryHighlight",
  "weeklyTrend",
  "suggestions",
  "encouragement",
];

async function testScenario(
  client: Anthropic,
  scenarioName: string,
  data: InsightPromptData,
  locale: string
): Promise<{ success: boolean; error?: string }> {
  const localizedData = { ...data, locale };
  const userPrompt = buildInsightUserPrompt(localizedData);

  console.log(`\n${"=".repeat(60)}`);
  console.log(`📊 ${scenarioName} | locale: ${locale}`);
  console.log("=".repeat(60));

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
      return { success: false, error: "No text block in response" };
    }

    const raw = textBlock.text;
    console.log("\n--- Raw Response ---");
    console.log(raw);

    // Validate JSON
    const parsed = JSON.parse(raw) as InsightResponse;
    console.log("\n--- Parsed JSON ---");
    console.log(JSON.stringify(parsed, null, 2));

    // Check required fields
    const missing = REQUIRED_FIELDS.filter(
      (f) => parsed[f] === undefined
    );
    if (missing.length > 0) {
      return { success: false, error: `Missing fields: ${missing.join(", ")}` };
    }

    // Validate healthScore range
    if (parsed.healthScore < 0 || parsed.healthScore > 100) {
      return { success: false, error: `healthScore out of range: ${parsed.healthScore}` };
    }

    // Validate suggestions array
    if (!Array.isArray(parsed.suggestions) || parsed.suggestions.length !== 3) {
      return { success: false, error: `Expected 3 suggestions, got ${parsed.suggestions?.length}` };
    }

    console.log("\n✅ PASS — Valid JSON, all fields present");
    console.log(`   healthScore: ${parsed.healthScore} (${parsed.healthLabel})`);
    console.log(`   savingsPotential: ¥${parsed.savingsPotential.toLocaleString()}`);
    console.log(`   suggestions: ${parsed.suggestions.length} items`);

    return { success: true };
  } catch (err) {
    const msg = err instanceof SyntaxError
      ? `JSON parse error: ${err.message}`
      : `API error: ${err}`;
    console.log(`\n❌ FAIL — ${msg}`);
    return { success: false, error: msg };
  }
}

async function main() {
  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) {
    console.error("❌ ANTHROPIC_API_KEY environment variable is not set.");
    console.error("   Run: export ANTHROPIC_API_KEY=\"sk-ant-...\"");
    process.exit(1);
  }

  const client = new Anthropic({ apiKey });

  console.log("🚀 Hareru AI Insight Prompt Tester");
  console.log(`   Model: ${CLAUDE_MODEL}`);
  console.log(`   Scenarios: ${ALL_SCENARIOS.length}`);
  console.log(`   Locales: ${TEST_LOCALES.join(", ")}`);
  console.log(`   Total calls: ${ALL_SCENARIOS.length * TEST_LOCALES.length}`);

  const results: { name: string; locale: string; success: boolean; error?: string }[] = [];

  for (const scenario of ALL_SCENARIOS) {
    for (const locale of TEST_LOCALES) {
      const result = await testScenario(
        client,
        scenario.name,
        scenario.data,
        locale
      );
      results.push({
        name: scenario.name,
        locale,
        ...result,
      });
    }
  }

  // Summary
  console.log(`\n${"=".repeat(60)}`);
  console.log("📋 SUMMARY");
  console.log("=".repeat(60));

  const passed = results.filter((r) => r.success).length;
  const failed = results.filter((r) => !r.success).length;

  for (const r of results) {
    const icon = r.success ? "✅" : "❌";
    const detail = r.error ? ` — ${r.error}` : "";
    console.log(`  ${icon} ${r.name} [${r.locale}]${detail}`);
  }

  console.log(`\n  Total: ${passed} passed, ${failed} failed out of ${results.length}`);

  if (failed > 0) process.exit(1);
}

// ⚠️ To run tests (makes real API calls), execute:
//   npx ts-node -e "require('./src/ai/testPrompt').runTests()"
export { main as runTests };
