import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';

// Kullanıcıdan gelen JWT token'ı doğrulayan strateji.
// AuthGuard('jwt') tetiklendiğinde otomatik olarak çalışır.
@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private configService: ConfigService) {
    super({
      // Authorization header: Bearer <token> şeklinde token alır.
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      // Token süresi dolduysa reddedilir.
      ignoreExpiration: false,
      // Token doğrulamak için kullanılan secret.
      secretOrKey: configService.get<string>('JWT_SECRET'),
    });
  }

  // Token doğrulandıktan sonra payload içindeki bilgiler buraya gelir.
  // Döndüğün obje request.user içine otomatik olarak eklenir.
  async validate(payload: any) {
    // payload: { sub: userId, role: string } şeklindedir.
    return { userId: payload.sub, role: payload.role };
  }
}
