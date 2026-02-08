import * as admin from "firebase-admin";

admin.initializeApp();

export { generateInsights } from "./ai/insights";
export { parseReceipt } from "./ai/receiptParser";
export { aiCoach } from "./ai/aiCoach";
