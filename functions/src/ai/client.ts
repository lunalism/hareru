import Anthropic from "@anthropic-ai/sdk";
import { defineSecret } from "firebase-functions/params";

export const anthropicApiKey = defineSecret("ANTHROPIC_API_KEY");

let client: Anthropic | null = null;

/**
 * Returns a singleton Anthropic client instance.
 * Must be called within a function that has `anthropicApiKey` in its secrets.
 */
export function getAnthropicClient(): Anthropic {
  if (!client) {
    client = new Anthropic({
      apiKey: anthropicApiKey.value(),
    });
  }
  return client;
}

export const CLAUDE_MODEL = "claude-sonnet-4-20250514";
