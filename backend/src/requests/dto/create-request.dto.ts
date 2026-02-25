import { IsString, IsNotEmpty, IsNumber, IsArray, ArrayNotEmpty } from 'class-validator';

/**
 * CreateRequestDto
 * Yeni bir satın alma talebi oluşturmak için kullanılan veri transfer nesnesi (DTO)
 * Kullanıcıdan alınacak veriler ve doğrulama kuralları burada tanımlanır
 */
export class CreateRequestDto {
  // Talebin başlığı, boş olamaz
  @IsString()
  @IsNotEmpty()
  title: string;

  // Talebin detaylı açıklaması, boş olamaz
  @IsString()
  @IsNotEmpty()
  description: string;

  // Talep edilen toplam tutar, sayısal olmalı
  @IsNumber()
  totalAmount: number;

  // Talebin onaycıları, boş bir dizi olamaz
  @IsArray()
  @ArrayNotEmpty()
  approvers: number[];
}