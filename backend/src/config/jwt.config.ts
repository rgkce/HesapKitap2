// Uygulama genelinde kullanılan log fonksiyonunu import eder
import { logError } from '../common/utils/logger.util';

// JWT konfigürasyonunu tip güvenliği ile tanımlar
interface JwtConfig {
  // Token oluşturmak için kullanılacak gizli anahtar
  secret: string;

  // Access token'ın geçerlilik süresi
  expiresIn: string;

  // Refresh token'ın geçerlilik süresi
  refreshExpiresIn: string;
}

/**
 * JWT yapılandırmasını döner
 * .env dosyasındaki JWT_* değerlerini alır ve tip güvenliği sağlar
 */
export function getJwtConfig(): JwtConfig {
  // Gerekli environment değişkenlerinin varlığı kontrol edilir
  validateJwtEnv();

  return {
    // JWT token için gizli anahtar
    secret: process.env.JWT_SECRET as string,

    // Access token'ın süresi
    expiresIn: process.env.JWT_EXPIRES_IN as string,

    // Refresh token süresi
    refreshExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN as string,
  };
}

/**
 * Gerekli JWT env değişkenlerini kontrol eder
 * Eğer herhangi bir değişken eksikse uygulamayı durdurur
 */
export function validateJwtEnv(): void {
  // Kontrol edilecek env değişkenleri listesi
  const requiredEnvs = [
    'JWT_SECRET',
    'JWT_EXPIRES_IN',
    'JWT_REFRESH_EXPIRES_IN',
  ];

  // Eksik env değişkenlerini filtreler
  const missingEnvs = requiredEnvs.filter(
    (env) => !process.env[env],
  );

  // Eğer eksik değişken varsa hata logu ve uygulama kapanışı
  if (missingEnvs.length > 0) {
    logError(
      `JWT configuration error. Missing env variables: ${missingEnvs.join(
        ', ',
      )}`,
    );
    process.exit(1);
  }
}