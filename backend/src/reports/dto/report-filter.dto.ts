import { IsOptional, IsDateString, IsNumber, IsString } from 'class-validator';
import { Type } from 'class-transformer';

// Rapor filtreleme DTO'su
// API'de query parametreleriyle gelen filtreleri doğrulamak için kullanılır
export class ReportFilterDto {
  // Talep / teklif durumu (örn: "pending", "approved", "rejected")
  @IsOptional()       // Bu alan opsiyonel
  @IsString()         // String tipinde olmalı
  status?: string;

  // Başlangıç tarihi filtrelemesi (ISO tarih formatı)
  @IsOptional()
  @IsDateString()     // Geçerli bir tarih string olmalı
  dateFrom?: Date;

  // Bitiş tarihi filtrelemesi (ISO tarih formatı)
  @IsOptional()
  @IsDateString()
  dateTo?: Date;

  // Tedarikçi ID filtrelemesi
  @IsOptional()
  @Type(() => Number) // Class-transformer ile number tipine çevrilir
  @IsNumber()         // Sayı olmalı
  supplierId?: number;

  // Raporu oluşturan kullanıcı ID filtrelemesi
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  createdBy?: number;
}