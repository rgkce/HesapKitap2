import { IsNumber, IsOptional, IsPositive, IsInt, IsString } from 'class-validator';

// Teklif güncelleme sırasında kullanılacak DTO
// Sadece gönderilen alanlar güncellenir (opsiyonel)
export class UpdateOfferDto {

  // Teklif fiyatını güncelleme (opsiyonel)
  @IsOptional()   // Gönderilmesi zorunlu değil
  @IsNumber()     // Sayı olmalı
  @IsPositive()   // Pozitif olmalı
  price?: number;

  // Teslim süresini güncelleme (gün cinsinden) (opsiyonel)
  @IsOptional()
  @IsInt()        // Tam sayı olmalı
  @IsPositive()   // Pozitif olmalı
  deliveryDays?: number;

  // Teklif açıklamasını güncelleme (opsiyonel)
  @IsOptional()
  @IsString()     // String olmalı
  description?: string;
}