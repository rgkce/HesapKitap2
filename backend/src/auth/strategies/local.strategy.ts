import { Strategy } from 'passport-local';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { AuthService } from '../auth.service';
import { UserEntity } from '../../users/entities/user.entity';

// Kullanıcı login işlemi için kullanılan local strateji.
// Email + password doğrulaması içindir.
@Injectable()
export class LocalStrategy extends PassportStrategy(Strategy) {
  // Varsayılan olarak Passport "username" bekler.
  // Biz email ile login yaptığımız için alanı değiştiriyoruz.
  constructor(private authService: AuthService) {
    super({ usernameField: 'email' });
  }

  // Kullanıcıyı doğrulayan fonksiyon.
  // Eğer email veya parola yanlışsa UnauthorizedException fırlatılır.
  async validate(email: string, password: string): Promise<UserEntity> {
    const user = await this.authService.validateUser(email, password);
    if (!user) {
      throw new UnauthorizedException('Invalid email or password');
    }
    // Kullanıcı geçerliyse controller seviyesinde request.user'a eklenir.
    return user;
  }
}
