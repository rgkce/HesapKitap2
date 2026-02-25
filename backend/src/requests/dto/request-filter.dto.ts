import { IsOptional, IsString, IsNumber, IsDateString } from 'class-validator';

/**
 * RequestFilterDto
 * Talepleri filtrelemek için kullanılan veri transfer nesnesi (DTO)
 * Kullanıcı, durum, tarih aralığı gibi kriterlere göre talepleri sorgulamak için kullanılır
 */
export class RequestFilterDto {
  // Talep durumu ile filtreleme (ör: 'pending', 'approved'), isteğe bağlı
  @IsOptional()
  @IsString()
  status?: string;

  // Talebi oluşturan kullanıcı ID'si ile filtreleme, isteğe bağlı
  @IsOptional()
  @IsNumber()
  createdBy?: number;

  // Başlangıç tarihi ile filtreleme, isteğe bağlı
  @IsOptional()
  @IsDateString()
  dateFrom?: Date;

  // Bitiş tarihi ile filtreleme, isteğe bağlı
  @IsOptional()
  @IsDateString()
  dateTo?: Date;
}