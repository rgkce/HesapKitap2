// NestJS içerisinden gerekli guard arayüzü, context ve exception sınıflarını import eder
import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
} from '@nestjs/common';

// Metadata okumak için kullanılan Reflector sınıfını import eder
import { Reflector } from '@nestjs/core';

// Bu sınıfın NestJS tarafından injectable (bağımlılık olarak kullanılabilir) olduğunu belirtir
@Injectable()
export class RolesGuard implements CanActivate {
  // Reflector servisi constructor üzerinden dependency injection ile alınır
  constructor(private readonly reflector: Reflector) {}

  // Her request geldiğinde çalışacak olan metod
  canActivate(context: ExecutionContext): boolean {
    // Endpoint veya controller üzerine tanımlanan roller metadata üzerinden okunur
    const requiredRoles = this.reflector.getAllAndOverride<string[]>(
      'roles',
      [context.getHandler(), context.getClass()],
    );

    // Eğer endpoint için herhangi bir rol tanımı yoksa, erişime izin verilir
    if (!requiredRoles || requiredRoles.length === 0) {
      return true;
    }

    // HTTP isteğine ait request nesnesi alınır
    const request = context.switchToHttp().getRequest();

    // JwtAuthGuard tarafından request içine eklenen user bilgisi alınır
    const user = request.user;

    // Eğer kullanıcı bilgisi veya rol bilgisi yoksa erişim reddedilir
    if (!user || !user.role) {
      throw new ForbiddenException('Rol bilgisi bulunamadı');
    }

    // Kullanıcının rolünün, izin verilen roller listesinde olup olmadığı kontrol edilir
    const hasRole = requiredRoles.includes(user.role);

    // Kullanıcının rolü uygun değilse yetkisiz işlem hatası fırlatılır
    if (!hasRole) {
      throw new ForbiddenException(
        'Bu işlem için yetkiniz bulunmamaktadır',
      );
    }

    // Tüm kontroller başarılıysa endpoint'e erişime izin verilir
    return true;
  }
}