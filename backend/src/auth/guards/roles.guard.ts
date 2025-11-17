import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ROLES_KEY } from '../decorators/roles.decorator';

// Role-based access control (RBAC) için kullanılan guard.
// @Roles() decorator'ında belirtilen rolleri kontrol eder.
@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  // Bir route'a erişilip erişilemeyeceğini belirleyen ana fonksiyon.
  canActivate(context: ExecutionContext): boolean {
    // Hem class hem handler üzerinden rol metadata'sını okur.
    const requiredRoles = this.reflector.getAllAndOverride<string[]>(ROLES_KEY, [
      context.getHandler(), // route seviyesi
      context.getClass(), // controller seviyesi
    ]);

    // Eğer endpoint üzerinde rol belirtilmemişse herkese izin verilir.
    if (!requiredRoles) return true;

    // Request üzerinden user objesini alır (JwtStrategy tarafından eklenir).
    const { user } = context.switchToHttp().getRequest();
    // Kullanıcının rolü gerekli roller arasında değilse erişim reddedilir.
    if (!requiredRoles.includes(user.role)) {
      throw new ForbiddenException('Access denied for this role');
    }
    return true;
  }
}
