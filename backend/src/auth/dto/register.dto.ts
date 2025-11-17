import { IsEmail, IsNotEmpty, MinLength } from 'class-validator';

// Yeni kullanıcı kaydı sırasında gelen verileri doğrulamak için kullanılan DTO.
// Kayıt işleminin güvenli ve hatasız yapılması için zorunlu alanlar kontrol edilir.
export class RegisterDto {
  // Kullanıcının tam adı boş bırakılamaz.
  @IsNotEmpty()
  fullName: string;

  // Kullanıcının email adresi email formatında olmalıdır.
  @IsEmail()
  email: string;

  // Şifre en az 6 karakter olmalıdır. Daha güçlü bir doğrulama istenirse eklenebilir.
  @MinLength(6)
  password: string;

  // Kullanıcı rolü (örn: USER, ADMIN). Boş olamaz.
  @IsNotEmpty()
  role: string;
}
