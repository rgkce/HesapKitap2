import { Injectable, UnauthorizedException } from '@nestjs/common'; // NestJS servis tanımı ve yetkisiz erişim istisnası
import { JwtService } from '@nestjs/jwt'; // JWT token üretimi ve doğrulama servisi
import * as bcrypt from 'bcrypt'; // Şifreleme ve şifre karşılaştırma işlemleri için bcrypt kütüphanesi
import { UsersService } from '../users/users.service'; // Kullanıcı işlemleri için servis
import { RegisterDto } from './dto/register.dto'; // Kayıt işlemi için veri transfer objesi
import { LoginDto } from './dto/login.dto'; // Giriş işlemi için veri transfer objesi
import { UserEntity } from '../users/entities/user.entity'; // Kullanıcı veri modeli

@Injectable()
export class AuthService {
  constructor(
    private readonly usersService: UsersService, // Kullanıcı servisi bağımlılığı
    private readonly jwtService: JwtService, // JWT servisi bağımlılığı
  ) {}

  async register(dto: RegisterDto) {
    const hashedPassword = await bcrypt.hash(dto.password, 10);
    const user = await this.usersService.create({
      ...dto,
      password: hashedPassword,
    });
    const tokens = await this.getTokens(user.id, user.role);
    await this.updateRefreshToken(user.id, tokens.refreshToken);
    return tokens;
  }

  async login(dto: LoginDto) {
    const user = await this.usersService.findByEmail(dto.email);
    if (!user) throw new UnauthorizedException('Invalid credentials');

    const isValid = await bcrypt.compare(dto.password, user.password);
    if (!isValid) throw new UnauthorizedException('Invalid credentials');

    const tokens = await this.getTokens(user.id, user.role);
    await this.updateRefreshToken(user.id, tokens.refreshToken);
    return tokens;
  }

  async logout(userId: number) {
    await this.usersService.update(userId, { refreshToken: null });
  }

  async refreshToken(userId: number, refreshToken: string) {
    const user = await this.usersService.findById(userId);
    if (!user?.refreshToken) throw new UnauthorizedException();

    const isValid = await bcrypt.compare(refreshToken, user.refreshToken);
    if (!isValid) throw new UnauthorizedException('Invalid refresh token');

    const tokens = await this.getTokens(user.id, user.role);
    await this.updateRefreshToken(user.id, tokens.refreshToken);
    return tokens;
  }

  async validateUser(email: string, password: string): Promise<UserEntity | null> {
    const user = await this.usersService.findByEmail(email);
    if (!user) return null;
    const isValid = await bcrypt.compare(password, user.password);
    return isValid ? user : null;
  }

  private async getTokens(userId: number, role: string) {
    const payload = { sub: userId, role };
    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(payload, { expiresIn: '15m' }),
      this.jwtService.signAsync(payload, { expiresIn: '7d' }),
    ]);
    return { accessToken, refreshToken };
  }

  private async updateRefreshToken(userId: number, refreshToken: string) {
    const hashedRefresh = await bcrypt.hash(refreshToken, 10);
    await this.usersService.update(userId, { refreshToken: hashedRefresh });
  }
}
