import {
  createParamDecorator,
  ExecutionContext,
} from '@nestjs/common';

/**
 * Request içerisindeki kullanıcı bilgisini döner
 */
export const User = createParamDecorator(
  (_data: unknown, context: ExecutionContext) => {
    const request = context.switchToHttp().getRequest();
    return request.user;
  },
);
