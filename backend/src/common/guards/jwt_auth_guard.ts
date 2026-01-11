import {
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  /**
   * JWT doğrulama sürecini başlatır
   */
  canActivate(context: ExecutionContext) {
    return super.canActivate(context);
  }

  /**
   * Passport tarafından dönen sonucu kontrol eder
   */
  handleRequest(
    err: any,
    user: any,
    info: any,
    context: ExecutionContext,
  ) {
    if (err || !user) {
      throw new UnauthorizedException(
        'Geçersiz veya süresi dolmuş token',
      );
    }

    return user;
  }
}
