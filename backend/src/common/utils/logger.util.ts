const isProduction = process.env.NODE_ENV === 'production';

/**
 * Bilgilendirme logları
 */
export function logInfo(message: string): void {
  console.log(`[INFO] ${message}`);
}

/**
 * Hata logları
 */
export function logError(
  message: string,
  trace?: string,
): void {
  console.error(`[ERROR] ${message}`);
  if (!isProduction && trace) {
    console.error(trace);
  }
}

/**
 * Debug logları (sadece development)
 */
export function logDebug(message: string): void {
  if (!isProduction) {
    console.debug(`[DEBUG] ${message}`);
  }
}
