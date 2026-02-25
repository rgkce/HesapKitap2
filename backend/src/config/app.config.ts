// Uygulamanın genel konfigürasyonunu tip güvenliği ile tanımlayan interface
interface AppConfig {
  // Uygulamanın çalışacağı port numarası
  port: number;

  // Çalışma ortamı: development, production veya test
  environment: 'development' | 'production' | 'test';

  // API veya frontend base URL adresi
  baseUrl: string;
}

/**
 * Uygulama genel konfigürasyonunu döner
 * .env dosyasından değerleri alır veya varsayılan değerleri kullanır
 */
export function getAppConfig(): AppConfig {
  return {
    // PORT environment değişkeni varsa kullan, yoksa 3000 portunu kullan
    port: Number(process.env.PORT) || 3000,

    // NODE_ENV environment değişkenini al, yoksa 'development' olarak ayarla
    environment:
      (process.env.NODE_ENV as AppConfig['environment']) ||
      'development',

    // BASE_URL environment değişkenini al, yoksa localhost kullan
    baseUrl: process.env.BASE_URL || 'http://localhost:3000',
  };
}