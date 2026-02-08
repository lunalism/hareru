import * as admin from "firebase-admin";
import { logger } from "firebase-functions/v2";
import { Request, Response } from "express";

/**
 * Verifies the Firebase ID token from the Authorization header.
 * Returns the uid on success, or sends an error response and returns null.
 */
export async function verifyAuth(
  req: Request,
  res: Response
): Promise<string | null> {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    res.status(401).json({
      error: "Unauthorized",
      message: "Missing or invalid Authorization header. Expected: Bearer <token>",
    });
    return null;
  }

  const idToken = authHeader.split("Bearer ")[1];

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    return decodedToken.uid;
  } catch (error) {
    logger.warn("Auth token verification failed", { error });
    res.status(401).json({
      error: "Unauthorized",
      message: "Invalid or expired authentication token.",
    });
    return null;
  }
}
