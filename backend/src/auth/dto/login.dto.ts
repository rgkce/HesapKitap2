import { IsEmail, IsNotEmpty } from 'class-validator';

// Login sırasında gelen email ve password bilgilerini doğrulamak için kullanılan DTO.
// class-validator sayesinde gelen alanlar otomatik olarak kontrol edilir.
export class LoginDto {
  // Email formatında olmalıdır. Boş olmasına izin verilmez.
  @IsEmail()
  email: string;

  // Boş olmasına izin verilmez.
  @IsNotEmpty()
  password: string;
}
