interface AppConfig {
  port: number;
  environment: 'development' | 'production' | 'test';
  baseUrl: string;
}

/**
 * Uygulama genel konfigürasyonunu döner
 */
export function getAppConfig(): AppConfig {
  return {
    port: Number(process.env.PORT) || 3000,
    environment:
      (process.env.NODE_ENV as AppConfig['environment']) ||
      'development',
    baseUrl: process.env.BASE_URL || 'http://localhost:3000',
  };
}
