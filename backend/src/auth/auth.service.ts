import { Injectable, UnauthorizedException } from '@nestjs/common'; // NestJS servis tanımı ve yetkisiz erişim istisnası
import { JwtService } from '@nestjs/jwt'; // JWT token üretimi ve doğrulama servisi
import * as bcrypt from 'bcrypt'; // Şifreleme ve şifre karşılaştırma işlemleri için bcrypt kütüphanesi
import { UsersService } from '../users/users.service'; // Kullanıcı işlemleri için servis
import { RegisterDto } from './dto/register.dto'; // Kayıt işlemi için veri transfer objesi
import { LoginDto } from './dto/login.dto'; // Giriş işlemi için veri transfer objesi
import { UserEntity } from '../users/entities/user.entity'; // Kullanıcı veri modeli

// Authentication işlemlerinin tüm iş mantığını barındırır.
// Kayıt, giriş, çıkış, token üretimi, refresh token doğrulama vb. işlemler burada yapılır.
@Injectable()
export class AuthService {
  constructor(
    private readonly usersService: UsersService, // Kullanıcı servisi bağımlılığı
    private readonly jwtService: JwtService, // JWT servisi bağımlılığı
  ) {}

  // Yeni kullanıcı kayıt eder.
  // Şifre bcrypt ile hashlenir ve refresh token oluşturulur.
  async register(dto: RegisterDto) {
    const hashedPassword = await bcrypt.hash(dto.password, 10);
    // Kullanıcı oluşturulurken hashlenmiş şifre kaydedilir.
    const user = await this.usersService.create({
      ...dto,
      password: hashedPassword,
    });
    // Access + Refresh token üretilir.
    const tokens = await this.getTokens(user.id, user.role);
    // Refresh token kullanıcıya ait olarak db'de saklanır.
    await this.updateRefreshToken(user.id, tokens.refreshToken);
    return tokens;
  }

  // Kullanıcı giriş işlemi.
  // Email ve şifre doğrulanır, token üretilir.
  async login(dto: LoginDto) {
    const user = await this.usersService.findByEmail(dto.email);
    if (!user) throw new UnauthorizedException('Invalid credentials');

    const isValid = await bcrypt.compare(dto.password, user.password);
    if (!isValid) throw new UnauthorizedException('Invalid credentials');

    const tokens = await this.getTokens(user.id, user.role);
    await this.updateRefreshToken(user.id, tokens.refreshToken);
    return tokens;
  }

  // Çıkış işlemi.
  // Kullanıcıya ait refresh token db'den silinir.
  async logout(userId: number) {
    await this.usersService.update(userId, { refreshToken: null });
  }

  // Refresh token ile yeni access token oluşturur.
  async refreshToken(userId: number, refreshToken: string) {
    const user = await this.usersService.findById(userId);
    // Kullanıcıda refresh token yoksa işlem reddedilir.
    if (!user?.refreshToken) throw new UnauthorizedException();

    // Gönderilen refresh token hash karşılaştırması yapılır.
    const isValid = await bcrypt.compare(refreshToken, user.refreshToken);
    if (!isValid) throw new UnauthorizedException('Invalid refresh token');
    // Yeni token seti üretilir.
    const tokens = await this.getTokens(user.id, user.role);
    // Yeni refresh token hashlenip kaydedilir.
    await this.updateRefreshToken(user.id, tokens.refreshToken);
    return tokens;
  }

  // LocalStrategy için email + şifre doğrulama yöntemi.
  async validateUser(email: string, password: string): Promise<UserEntity | null> {
    const user = await this.usersService.findByEmail(email);
    if (!user) return null;
    const isValid = await bcrypt.compare(password, user.password);
    return isValid ? user : null;
  }

  // Access token (15m) + Refresh token (7d) üretir.
  private async getTokens(userId: number, role: string) {
    const payload = { sub: userId, role };
    // Paralel token üretimi performansı artırır.
    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(payload, { expiresIn: '15' }),
      this.jwtService.signAsync(payload, { expiresIn: '7d' }),
    ]);
    return { accessToken, refreshToken };
  }

  // Refresh token veritabanında hashlenmiş şekilde saklanır.
  private async updateRefreshToken(userId: number, refreshToken: string) {
    const hashedRefresh = await bcrypt.hash(refreshToken, 10);
    await this.usersService.update(userId, { refreshToken: hashedRefresh });
  }
}
