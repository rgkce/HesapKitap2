// NestJS içerisinden gerekli decorator ve exception sınıflarını import eder
import {
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';

// Passport kütüphanesinin JWT stratejisini kullanmak için AuthGuard import edilir
import { AuthGuard } from '@nestjs/passport';

// Bu sınıfın bir injectable (bağımlılık olarak kullanılabilir) olduğunu belirtir
@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  /**
   * JWT doğrulama sürecini başlatır
   * Her gelen istekte Authorization header içindeki token'ın doğrulanmasını sağlar
   */
  canActivate(context: ExecutionContext) {
    // Üst sınıftaki (AuthGuard) JWT doğrulama mekanizmasını çalıştırır
    return super.canActivate(context);
  }

  /**
   * Passport tarafından dönen sonucu kontrol eder
   * Token doğrulama sonucunda oluşan hata veya kullanıcı bilgisi burada değerlendirilir
   */
  handleRequest(
    err: any,
    user: any,
    info: any,
    context: ExecutionContext,
  ) {
    // Eğer hata varsa veya kullanıcı bilgisi bulunamazsa yetkisiz erişim hatası fırlatılır
    if (err || !user) {
      throw new UnauthorizedException(
        'Geçersiz veya süresi dolmuş token',
      );
    }

    // Token geçerliyse kullanıcı bilgisi request.user içine eklenir ve controller'a iletilir
    return user;
  }
}