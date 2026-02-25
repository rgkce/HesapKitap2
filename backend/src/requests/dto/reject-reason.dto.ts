import { IsString, IsNotEmpty } from 'class-validator';

/**
 * RejectReasonDto
 * Bir talebin reddedilme sebebini tutan veri transfer nesnesi (DTO)
 * Onaycı, talebi reddederken bu alanı doldurmalıdır
 */
export class RejectReasonDto {
  // Reddetme sebebi, boş olamaz ve string olmalı
  @IsString()
  @IsNotEmpty()
  reason: string;
}