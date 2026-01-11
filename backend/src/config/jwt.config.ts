import { logError } from '../common/utils/logger.util';

interface JwtConfig {
  secret: string;
  expiresIn: string;
  refreshExpiresIn: string;
}

/**
 * JWT yapılandırmasını döner
 */
export function getJwtConfig(): JwtConfig {
  validateJwtEnv();

  return {
    secret: process.env.JWT_SECRET as string,
    expiresIn: process.env.JWT_EXPIRES_IN as string,
    refreshExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN as string,
  };
}

/**
 * Gerekli JWT env değişkenlerini kontrol eder
 */
export function validateJwtEnv(): void {
  const requiredEnvs = [
    'JWT_SECRET',
    'JWT_EXPIRES_IN',
    'JWT_REFRESH_EXPIRES_IN',
  ];

  const missingEnvs = requiredEnvs.filter(
    (env) => !process.env[env],
  );

  if (missingEnvs.length > 0) {
    logError(
      `JWT configuration error. Missing env variables: ${missingEnvs.join(
        ', ',
      )}`,
    );
    process.exit(1);
  }
}
