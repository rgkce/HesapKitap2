// DTO: Yeni kullanıcı oluşturmak için kullanılan veri transfer objesi
import { IsEmail, IsNotEmpty, MinLength, IsOptional } from 'class-validator';

export class CreateUserDto {
  // Kullanıcının benzersiz e-posta adresi – geçerli e-posta formatı olmalı
  @IsEmail()
  email: string;

  // Şifre boş olamaz ve minimum 6 karakter olmalıdır
  @IsNotEmpty()
  @MinLength(6)
  password: string;

  // Kullanıcının tam adı – boş bırakılamaz
  @IsNotEmpty()
  fullName: string;

  // Opsiyonel telefon numarası – zorunlu değil
  @IsOptional()
  phoneNumber?: string;
}
