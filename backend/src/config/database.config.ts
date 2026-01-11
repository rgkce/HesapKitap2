import { DataSourceOptions } from 'typeorm';
import { logError, logInfo } from '../common/utils/logger.util';

/**
 * Ortam değişkenlerinden veritabanı konfigürasyonunu döner
 */
export function getDatabaseConfig(): DataSourceOptions {
  return {
    type: 'postgres',
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT),
    username: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    synchronize: false,
    logging: false,
    entities: ['dist/**/*.entity.js'],
    migrations: ['dist/migrations/*.js'],
  };
}

/**
 * Veritabanı bağlantısını başlatır
 */
export async function connectDatabase(
  dataSource: { initialize: () => Promise<any> },
): Promise<void> {
  try {
    await dataSource.initialize();
    logInfo('Database connection established');
  } catch (error: any) {
    logError('Database connection failed', error.stack);
    process.exit(1);
  }
}
