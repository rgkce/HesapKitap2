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
      useFactory: (config: ConfigService) => ({
        // JWT token imzalama için kullanılan secret.
        secret: config.get<string>('JWT_SECRET'),
        // Token süresi config'ten alınır, yoksa varsayılan 15 dakika.
        signOptions: { expiresIn: config.get<string>('JWT_EXPIRES_IN', '15m') },
      }),
    }),
    UsersModule, // Kullanıcı işlemleri AuthService tarafından kullanılacağı için import edilir.
  ],
  controllers: [AuthController], // Auth endpoint'leri için controller.
  providers: [AuthService, JwtStrategy, LocalStrategy], // JWT doğrulama stratejisi
  exports: [AuthService], // Diğer modüllerde AuthService'in kullanılabilmesi için export edilir.
})
export class AuthModule {}
