// NestJS içerisinden custom param decorator oluşturmak için kullanılan fonksiyonları import eder
import {
  createParamDecorator,
  ExecutionContext,
} from '@nestjs/common';

/**
 * Request içerisindeki kullanıcı bilgisini döner
 * Bu decorator sayesinde controller metodlarında doğrudan @User() kullanılarak
 * request.user nesnesine kolayca erişilebilir
 */
export const User = createParamDecorator(
  // _data parametresi şu anda kullanılmamaktadır, ileride genişletilebilir
  (_data: unknown, context: ExecutionContext) => {
    // HTTP isteğine ait request nesnesine erişilir
    const request = context.switchToHttp().getRequest();

    // JwtAuthGuard tarafından request içine eklenen user bilgisini döndürür
    return request.user;
  },
);