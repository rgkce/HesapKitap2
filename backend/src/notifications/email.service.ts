import { Injectable, Logger } from '@nestjs/common';
import { MailerService } from '@nestjs-modules/mailer';
import { User } from '../users/entities/user.entity';

@Injectable() // Bu servis diğer sınıflar tarafından dependency injection ile kullanılabilir
export class EmailService {
  private readonly logger = new Logger(EmailService.name); 
  // Logger, işlemlerin konsola veya log sistemine yazılmasını sağlar

  constructor(private readonly mailerService: MailerService) {}
  // NestJS MailerService servisini inject ediyoruz, asenkron mail gönderimi için

  // =====================================================
  // Genel amaçlı mail gönderimi
  // =====================================================
  async sendMail(
    to: string,       // Alıcının e-posta adresi
    subject: string,  // E-posta konusu
    template: string, // E-posta şablon adı (templates/ dizini altında)
    context: any,     // Şablonda kullanılacak değişkenler
  ): Promise<void> {
    try {
      await this.mailerService.sendMail({
        to,
        subject,
        template: `./${template}`, // Şablon dosyasının yolu
        context,                   // Şablon için veri bağlamı
      });

      this.logger.log(`Email gönderildi → ${to}`); 
      // Başarılı gönderim loglanır
    } catch (error) {
      this.logger.error(
        `Email gönderilemedi: ${to} | Error: ${error.message}`,
      ); 
      // Hata oluşursa loglanır
    }
  }

  // =====================================================
  // Bildirim türü e-posta gönderimi
  // =====================================================
  // Her bildirim e-posta gerektirmediği için NotificationService içerisinden çağrılır.
  async sendNotificationEmail(
    user: UserEntity, // Hedef kullanıcı
    message: string,  // Gönderilecek mesaj
  ): Promise<void> {
    if (!user?.email) {
      // Kullanıcının e-posta adresi yoksa uyarı loglanır ve fonksiyon sonlanır
      this.logger.warn(
        `Kullanıcının e-posta adresi yok. userId: ${user?.id}`,
      );
      return;
    }

    // sendMail fonksiyonunu kullanarak bildirim e-postasını gönder
    await this.sendMail(
      user.email,                  // Alıcı
      'Yeni Bildiriminiz Var',     // Konu
      'notification-email',        // Şablon adı
      {
        name: user.fullName || user.email, // Şablon için kullanıcı adı
        message,                           // Mesaj içeriği
      },
    );
  }

  // =====================================================
  // Toplu mail gönderimi
  // =====================================================
  // recipients dizisindeki tüm e-posta adreslerine tek tek mail gönderir
  async sendBulkEmails(
    recipients: string[], // Alıcı listesi
    subject: string,      // E-posta konusu
    template: string,     // Kullanılacak şablon
    commonContext: any = {}, // Şablon için ortak veri bağlamı
  ): Promise<void> {
    for (const email of recipients) {
      // Her bir alıcıya sendMail fonksiyonu ile mail gönder
      await this.sendMail(email, subject, template, commonContext);
    }
  }

  // =====================================================
  // Şablon hazırlama (opsiyonel yardımcı fonksiyon)
  // =====================================================
  // Template adı ve context ile nesne döner, NotificationService içinde kullanılabilir
  buildTemplate(templateName: string, context: any) {
    return {
      template: `./${templateName}`, // Şablon dosya yolu
      context,                       // Şablon için veri bağlamı
    };
  }
}