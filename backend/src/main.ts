import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';

/**
 * Uygulamanın başlangıç noktası
 * NestJS sunucusunu başlatır ve global ayarları yapılandırır
 */
async function bootstrap() {
  // NestJS uygulamasını başlat ve AppModule'ü yükle
  const app = await NestFactory.create(AppModule);

  // Global ValidationPipe
  // - DTO’larda tanımlanan kurallara göre otomatik doğrulama yapılır
  // - whitelist: sadece DTO’daki alanlar kabul edilir, ekstra alanlar atılır
  // - forbidNonWhitelisted: DTO’da olmayan alan varsa hata fırlatır
  // - transform: gelen veriyi otomatik olarak DTO tipine dönüştürür
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  // Tüm rotalara global prefix ekle (örn: /api/requests)
  app.setGlobalPrefix('api');

  // CORS'u etkinleştir (frontend uygulamaları için)
  app.enableCors();

  // Sunucunun dinleyeceği port
  const port = 3000;
  await app.listen(port);

  console.log(`🚀 Server running on http://localhost:${port}/api`);
}

// Bootstrap fonksiyonunu çalıştır
bootstrap();