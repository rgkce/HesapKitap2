import { IsNotEmpty } from 'class-validator';

// Access token yenileme işlemi için gerekli olan refresh token bilgisini doğrular.
// Refresh token'ın formatı değişken olabileceği için sadece dolu olması yeterlidir.
export class RefreshTokenDto {
  // Refresh token mutlaka gönderilmelidir. Boş olmasına izin verilmez.
  @IsNotEmpty()
  refreshToken: string;
}
