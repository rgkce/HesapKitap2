import { IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class TestNotificationDto {
  // =====================================================
  // 1) Hedef kullanıcı ID'si (test amaçlı)
  // =====================================================
  @IsString()       // Sadece string tip kabul edilir
  @IsNotEmpty()     // Boş bırakılamaz
  userId: string;   // Test bildirimin gönderileceği kullanıcı ID

  // =====================================================
  // 2) Bildirim başlığı (test)
  // =====================================================
  @IsString()       // Sadece string tip kabul edilir
  @IsNotEmpty()     // Boş bırakılamaz
  title: string;    // Test bildirimin başlığı

  // =====================================================
  // 3) Bildirim mesajı (test)
  // =====================================================
  @IsString()       // Sadece string tip kabul edilir
  @IsNotEmpty()     // Boş bırakılamaz
  message: string;  // Test bildirimin mesaj içeriği

  // =====================================================
  // 4) Bildirim türü (opsiyonel)
  // =====================================================
  @IsString()       // String tip kabul edilir
  @IsOptional()     // Opsiyonel alan
  type?: string = 'TEST'; 
  // Varsayılan olarak 'TEST' → test bildirimleri için
}