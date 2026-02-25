import { IsOptional, IsNumber, IsString } from 'class-validator';

// Teklifleri filtrelemek için kullanılacak DTO
// GET /offers endpointinde query parametreleri ile kullanılır
export class OfferFilterDto {

  // Belirli bir tedarikçinin tekliflerini filtreler (opsiyonel)
  @IsOptional() // Gönderilmesi zorunlu değil
  @IsNumber()   // Sayı olmalı
  supplierId?: number;

  // Belirli bir talebe ait teklifleri filtreler (opsiyonel)
  @IsOptional()
  @IsNumber()
  requestId?: number;

  // Teklif durumu ile filtreleme (pending, accepted, rejected) (opsiyonel)
  @IsOptional()
  @IsString() // String olmalı
  status?: string;
}