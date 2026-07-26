import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { UsersModule } from '../users/users.module';
import { JwtStrategy } from './strategies/jwt.strategy';
import { LocalStrategy } from './strategies/local.strategy';
import { ConfigModule, ConfigService } from '@nestjs/config';

// AuthModule, authentication için gerekli olan servisleri, stratejileri ve controller'ı içerir.
@Module({
  imports: [
    PassportModule, // Local ve JWT stratejileri için gerekli.

    // JWT modülü dinamik olarak config üzerinden yapılandırılır.
    JwtModule.registerAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (config: ConfigService) => {
        const secret = config.get<string>('JWT_SECRET') ?? 'supersecretkey123';
        console.log('JWT_SECRET:', secret);
        return {
          secret,
          signOptions: { expiresIn: '15m' as any },  // ← as any ekle
        };
      },
    }),
    UsersModule, // Kullanıcı işlemleri AuthService tarafından kullanılacağı için import edilir.
  ],
  controllers: [AuthController], // Auth endpoint'leri için controller.
  providers: [AuthService, JwtStrategy, LocalStrategy], // JWT doğrulama stratejisi
  exports: [AuthService], // Diğer modüllerde AuthService'in kullanılabilmesi için export edilir.
})
export class AuthModule {}

