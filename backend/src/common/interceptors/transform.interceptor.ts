// NestJS içerisinden interceptor için gerekli sınıflar import edilir
import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';

// RxJS Observable yapısını kullanmak için import edilir
import { Observable } from 'rxjs';

// RxJS operatörlerinden map, response verisini dönüştürmek için kullanılır
import { map } from 'rxjs/operators';

// Bu sınıfın NestJS tarafından injectable olduğunu belirtir
@Injectable()
export class TransformInterceptor implements NestInterceptor {
  // Her HTTP isteğinde response döndürülmeden önce çalışan metod
  intercept(
    context: ExecutionContext,
    next: CallHandler,
  ): Observable<any> {
    // Controller'dan dönen veriyi yakalar ve yeni bir formata dönüştürür
    return next.handle().pipe(
      // map operatörü ile response verisi standart bir JSON yapısına çevrilir
      map((data) => ({
        // İşlemin başarılı olduğunu belirtir
        success: true,

        // Controller'dan dönen asıl veri burada yer alır
        data,

        // Response'un oluşturulduğu zamanı ISO formatında ekler
        timestamp: new Date().toISOString(),
      })),
    );
  }
}