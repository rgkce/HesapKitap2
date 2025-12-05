// DTO: Kullanıcı bilgilerini güncellemek için kullanılan veri transfer objesi
import { IsOptional, MinLength, IsString } from 'class-validator';

export class UpdateUserDto {
  // Şifre güncelleme isteğe bağlıdır ve minimum 6 karakter olmalıdır
  @IsOptional()
  @MinLength(6)
  password?: string;

  // Kullanıcının tam adını güncellemek isteğe bağlıdır
  @IsOptional()
  @IsString()
  fullName?: string;

  // Opsiyonel telefon numarası (zorunlu değil)
  @IsOptional()
  phoneNumber?: string;
}
