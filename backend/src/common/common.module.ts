// NestJS içerisinden Global ve Module decorator'larını import eder.
// Global: Bu modülün tüm uygulamada geçerli olmasını sağlar.
// Module: Bu dosyanın bir NestJS modülü olduğunu belirtir.
import { Global, Module } from '@nestjs/common';

// NestJS çekirdeğinden global guard ve interceptor tanımlamak için kullanılan token'lar
import { APP_GUARD, APP_INTERCEPTOR } from '@nestjs/core';

// JWT doğrulaması yapan Guard sınıfı
import { JwtAuthGuard } from './guards/jwt_auth_guard';

// Kullanıcının rolüne göre yetkilendirme yapan Guard sınıfı
import { RolesGuard } from './guards/roles_guard';

// Gelen istekleri ve yanıt sürelerini loglayan Interceptor
import { LoggingInterceptor } from './interceptors/logging.interceptor';

// API cevaplarını standart JSON formatına dönüştüren Interceptor
import { TransformInterceptor } from './interceptors/transform.interceptor';

// Bu modülün global (tüm projede geçerli) olacağını belirtir
@Global()
@Module({
  // providers: Bu modül tarafından sağlanan servisler, guard'lar ve interceptor'lar burada tanımlanır
  providers: [
    /**
     * GLOBAL GUARDS
     * Aşağıda tanımlanan guard'lar tüm uygulamada otomatik olarak çalışır
     */

    {
      // APP_GUARD: Guard'ın global olarak çalışacağını belirtir
      provide: APP_GUARD,

      // JwtAuthGuard sınıfını global guard olarak tanımlar
      // Her istekte JWT token kontrolü yapılmasını sağlar
      useClass: JwtAuthGuard,
    },
    {
      // Rol bazlı yetkilendirme guard'ının global olarak çalışmasını sağlar
      provide: APP_GUARD,

      // Kullanıcının rolüne göre endpoint erişimini kontrol eder
      useClass: RolesGuard,
    },

    /**
     * GLOBAL INTERCEPTORS
     * Aşağıda tanımlanan interceptor'lar tüm request ve response işlemlerinde devreye girer
     */

    {
      // APP_INTERCEPTOR: Interceptor'ın global olarak çalışacağını belirtir
      provide: APP_INTERCEPTOR,

      // LoggingInterceptor tüm HTTP isteklerini ve yanıt sürelerini loglar
      useClass: LoggingInterceptor,
    },
    {
      // Response verisini standart JSON formatına dönüştüren interceptor
      provide: APP_INTERCEPTOR,

      // Controller'dan dönen veriyi { success, data, timestamp } yapısına çevirir
      useClass: TransformInterceptor,
    },
  ],
})

// CommonModule sınıfı, guard ve interceptor'ları merkezi olarak yöneten modüldür
export class CommonModule {}