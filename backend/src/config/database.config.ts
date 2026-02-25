// TypeORM kütüphanesinden DataSourceOptions tipi import edilir
// Veritabanı konfigürasyonu için tip güvenliği sağlar
import { DataSourceOptions } from 'typeorm';

// Uygulama genelinde kullanılan log fonksiyonları import edilir
import { logError, logInfo } from '../common/utils/logger.util';

/**
 * Ortam değişkenlerinden veritabanı konfigürasyonunu döner
 * .env dosyasındaki DB_* değerlerini kullanır
 */
export function getDatabaseConfig(): DataSourceOptions {
  return {
    // Kullanılacak veritabanı tipi (PostgreSQL)
    type: 'postgres',

    // Host bilgisi (örn: localhost veya uzak sunucu)
    host: process.env.DB_HOST,

    // Port bilgisi, stringten number'a çevrilir
    port: Number(process.env.DB_PORT),

    // Veritabanı kullanıcı adı
    username: process.env.DB_USER,

    // Veritabanı şifresi
    password: process.env.DB_PASSWORD,

    // Veritabanı adı
    database: process.env.DB_NAME,

    // TypeORM'un entity değişikliklerini otomatik senkronize etmesini kapatır
    synchronize: false,

    // SQL loglamayı kapatır
    logging: false,

    // Entity dosyalarının yolu (compiled JS dosyaları)
    entities: ['dist/**/*.entity.js'],

    // Migration dosyalarının yolu
    migrations: ['dist/migrations/*.js'],
  };
}

/**
 * Veritabanı bağlantısını başlatır
 * DataSource veya benzeri initialize fonksiyonuna sahip obje alır
 */
export async function connectDatabase(
  // Veritabanı bağlantısını başlatacak dataSource objesi
  dataSource: { initialize: () => Promise<any> },
): Promise<void> {
  try {
    // Bağlantıyı başlat
    await dataSource.initialize();

    // Başarılı bağlantı logu
    logInfo('Database connection established');
  } catch (error: any) {
    // Bağlantı hatası durumunda hata logu ve detay stack trace
    logError('Database connection failed', error.stack);

    // Uygulamayı hata ile durdur
    process.exit(1);
  }
}