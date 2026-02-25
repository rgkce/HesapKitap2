// NestJS içerisinden interceptor için gerekli sınıflar import edilir
import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';

// RxJS Observable yapısını kullanmak için import edilir
import { Observable } from 'rxjs';

// RxJS operatörlerinden tap, response tamamlandıktan sonra işlem yapmak için kullanılır
import { tap } from 'rxjs/operators';

// Uygulama genelinde kullanılan loglama fonksiyonunu import eder
import { logInfo } from '../utils/logger.util';

// Bu sınıfın NestJS tarafından injectable olduğunu belirtir
@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  // Her HTTP isteğinde otomatik olarak çalışacak olan metod
  intercept(
    context: ExecutionContext,
    next: CallHandler,
  ): Observable<any> {
    // HTTP isteğine ait request nesnesi alınır
    const request = context.switchToHttp().getRequest();

    // İsteğin method bilgisi (GET, POST, vb.) ve URL adresi alınır
    const { method, originalUrl } = request;

    // İstek başlangıç zamanı kaydedilir (performans ölçümü için)
    const startTime = Date.now();

    // Controller çalıştırılır ve response akışı başlatılır
    return next.handle().pipe(
      // Response tamamlandıktan sonra çalışacak işlemler tanımlanır
      tap(() => {
        // İşlemin ne kadar sürdüğü hesaplanır
        const duration = Date.now() - startTime;

        // İstek bilgileri ve süre loglanır
        logInfo(
          `[${method}] ${originalUrl} - ${duration}ms`,
        );
      }),
    );
  }
}