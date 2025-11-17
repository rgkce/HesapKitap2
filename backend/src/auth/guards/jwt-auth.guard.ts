import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

// JWT token doğrulaması yapan guard.
// Burada AuthGuard('jwt'), JWT Strategy'i otomatik olarak tetikler.
// Eğer token geçersiz, süresi dolmuş veya yoksa otomatik olarak 401 döner.
@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {}
