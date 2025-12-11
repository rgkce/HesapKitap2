import { Injectable, Logger } from '@nestjs/common';
import { MailerService } from '@nestjs-modules/mailer';
import { User } from '../users/entities/user.entity';

@Injectable()
export class EmailService {
  private readonly logger = new Logger(EmailService.name);

  constructor(private readonly mailerService: MailerService) {}

  // Genel amaçlı mail gönderimi
  async sendMail(
    to: string,
    subject: string,
    template: string,
    context: any,
  ): Promise<void> {
    try {
      await this.mailerService.sendMail({
        to,
        subject,
        template: `./${template}`, // örn: templates/notification-email.hbs
        context,
      });

      this.logger.log(`Email gönderildi → ${to}`);
    } catch (error) {
      this.logger.error(
        `Email gönderilemedi: ${to} | Error: ${error.message}`,
      );
    }
  }

  // Bildirim türü e-posta
 // Her bildirim e-posta gerektirmediği için NotificationService içerisinden çağrılır.
  async sendNotificationEmail(
    user: UserEntity,
    message: string,
  ): Promise<void> {
    if (!user?.email) {
      this.logger.warn(
        `Kullanıcının e-posta adresi yok. userId: ${user?.id}`,
      );
      return;
    }

    await this.sendMail(
      user.email,
      'Yeni Bildiriminiz Var',
      'notification-email',
      {
        name: user.fullName || user.email,
        message,
      },
    );
  }

  // Toplu mail gönderimi
  // Senkron çalışır.
  async sendBulkEmails(
    recipients: string[],
    subject: string,
    template: string,
    commonContext: any = {},
  ): Promise<void> {
    for (const email of recipients) {
      await this.sendMail(email, subject, template, commonContext);
    }
  }

  // Şablon hazırlama (opsiyonel yardımcı fonksiyon)
  buildTemplate(templateName: string, context: any) {
    return {
      template: `./${templateName}`,
      context,
    };
  }
}
