// Uygulamanın production ortamında çalışıp çalışmadığını kontrol eder
// NODE_ENV değeri 'production' ise true olur
const isProduction = process.env.NODE_ENV === 'production';

/**
 * Bilgilendirme logları
 * Uygulamanın normal çalışma akışı ile ilgili mesajları yazdırmak için kullanılır
 */
export function logInfo(message: string): void {
  // Konsola INFO seviyesinde log yazar
  console.log(`[INFO] ${message}`);
}

/**
 * Hata logları
 * Sistem içerisinde oluşan hataları konsola yazdırmak için kullanılır
 */
export function logError(
  // Loglanacak hata mesajı
  message: string,

  // Opsiyonel olarak hata detayını (stack trace) alır
  trace?: string,
): void {
  // Konsola ERROR seviyesinde hata mesajını yazar
  console.error(`[ERROR] ${message}`);

  // Production ortamında değilse ve trace bilgisi varsa, detaylı hata bilgisini de yazdırır
  if (!isProduction && trace) {
    console.error(trace);
  }
}

/**
 * Debug logları (sadece development)
 * Geliştirme aşamasında detaylı bilgi almak için kullanılır
 */
export function logDebug(message: string): void {
  // Eğer ortam production değilse debug mesajı yazdırılır
  if (!isProduction) {
    console.debug(`[DEBUG] ${message}`);
  }
}