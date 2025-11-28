import { Body, Controller, Post, Req, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { JwtAuthGuard } from './guards/jwt-auth.guard';

// Bu controller, kayıt, giriş, çıkış ve token yenileme işlemlerini yönetir.
// Tüm endpointler "auth/..." ile başlar.
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  // Kullanıcı kayıt endpoint'i.
  // Gelen veriler RegisterDto ile doğrulanır.
  @Post('register')
  async register(@Body() dto: RegisterDto) {
    return this.authService.register(dto);
  }

  // Kullanıcı giriş endpoint'i.
  // LoginDto ile email ve şifre doğrulanır.
  @Post('login')
  async login(@Body() dto: LoginDto) {
    return this.authService.login(dto);
  }

  // Kullanıcı çıkış endpoint'i.
  // JWT doğrulaması zorunludur, bu yüzden JwtAuthGuard kullanılır.
  @UseGuards(JwtAuthGuard)
  @Post('logout')
  async logout(@Req() req) {
    await this.authService.logout(req.user.sub);
    return { message: 'Logged out successfully' };
  }

  // Access token yenileme endpoint'i.
  // Gelen refresh token çözülerek içerisindeki userId (sub) alınır.
  @Post('refresh')
  async refresh(@Body() dto: RefreshTokenDto) {
    const payload = this.decodeToken(dto.refreshToken);
    return this.authService.refreshToken(payload.sub, dto.refreshToken);
  }

  // Refresh token içerisindeki payload'ı decode eden yardımcı fonksiyon.
  // Güvenlik amacıyla sadece decode işlemi yapılır, doğrulama yapılmaz.
  private decodeToken(token: string) {
    const [, payload] = token.split('.');
    return JSON.parse(Buffer.from(payload, 'base64').toString('utf-8'));
  }
}
