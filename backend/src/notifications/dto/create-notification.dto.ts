import {
  IsEnum,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
} from 'class-validator';

export class CreateNotificationDto {
  // =====================================================
  // 1) Bildirim gönderilecek kullanıcı ID'si
  // =====================================================
  @IsNumber() // Sadece sayısal değer kabul eder
  @IsNotEmpty() // Boş bırakılamaz
  userId: number; 

  // =====================================================
  // 2) Bildirim başlığı
  // =====================================================
  @IsString() // Metin olmalı
  @IsNotEmpty() // Boş bırakılamaz
  title: string;

  // =====================================================
  // 3) Bildirim mesajı
  // =====================================================
  @IsString() // Metin olmalı
  @IsNotEmpty() // Boş bırakılamaz
  message: string;

  // =====================================================
  // 4) Bildirim türü
  // =====================================================
  @IsEnum(['info', 'success', 'warning', 'error'], {
    message: 'type must be one of: info, success, warning, error',
  }) // Sadece enum değerleri kabul edilir
  @IsOptional() // Opsiyonel alan
  type?: 'info' | 'success' | 'warning' | 'error' = 'info'; 
  // Varsayılan: 'info'

  // =====================================================
  // 5) Opsiyonel link (bildirim tıklanabilir linki)
  // =====================================================
  @IsString() // Metin olmalı
  @IsOptional() // Opsiyonel
  link?: string;

  // =====================================================
  // 6) Gönderim kanalı
  // =====================================================
  @IsEnum(['in_app', 'email', 'both'], {
    message: 'channel must be one of: in_app, email, both',
  }) // Sadece enum değerleri kabul edilir
  @IsOptional() // Opsiyonel
  channel?: 'in_app' | 'email' | 'both' = 'both'; 
  // Varsayılan: her iki kanal da (in-app + email)
}