import { IsNumber, IsString, IsOptional, IsPositive, IsInt } from 'class-validator';

// Teklif oluşturma sırasında kullanılacak veri transfer objesi (DTO)
// Frontend → Backend arası veri sözleşmesini sağlar
export class CreateOfferDto {

  // Teklifin hangi talebe ait olduğunu belirtir
  @IsNumber() // Sayı olmalı
  requestId: number;

  // Teklif fiyatı
  @IsNumber() // Sayı olmalı
  @IsPositive() // Pozitif olmalı
  price: number;

  // Para birimi (örn: USD, EUR, TRY)
  @IsString() // String olmalı
  currency: string;

  // Teslim süresi (gün olarak)
  @IsInt() // Tam sayı olmalı
  @IsPositive() // Pozitif olmalı
  deliveryDays: number;

  // Teklif açıklaması (opsiyonel)
  @IsOptional() // Zorunlu değil
  @IsString() // String olmalı
  description?: string;
}