import { IsOptional, IsString, IsNumber } from 'class-validator';

/**
 * UpdateRequestDto
 * Mevcut bir talebi güncellemek için kullanılan veri transfer nesnesi (DTO)
 * Kullanıcı sadece gerekli alanları gönderebilir; tüm alanlar isteğe bağlıdır
 */
export class UpdateRequestDto {
  // Talebin başlığını güncellemek için, isteğe bağlı alan
  @IsOptional()
  @IsString()
  title?: string;

  // Talebin açıklamasını güncellemek için, isteğe bağlı alan
  @IsOptional()
  @IsString()
  description?: string;

  // Talep edilen toplam tutarı güncellemek için, isteğe bağlı alan
  @IsOptional()
  @IsNumber()
  totalAmount?: number;
}