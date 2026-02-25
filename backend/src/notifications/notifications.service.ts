import { Injectable, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { NotificationEntity } from './entities/notification.entity';
import { CreateNotificationDto } from './dto/create-notification.dto';
import { TestNotificationDto } from './dto/test-notification.dto';

import { UsersService } from '../users/users.service';
import { NotificationGateway } from './notification.gateway';
import { EmailService } from './email.service';

@Injectable() // Bu servis diğer sınıflara inject edilebilir
export class NotificationsService {
  constructor(
    @InjectRepository(NotificationEntity)
    private readonly repo: Repository<NotificationEntity>, 
    // NotificationEntity için TypeORM repository’si → DB işlemleri burada yapılır

    private readonly usersService: UsersService, 
    // Kullanıcı bilgilerine erişim için UsersService

    private readonly emailService: EmailService, 
    // E-posta gönderimi için EmailService

    private readonly gateway: NotificationGateway, 
    // WebSocket üzerinden gerçek zamanlı bildirim göndermek için gateway
  ) {}

  // =====================================================
  // 1) Bildirim oluştur
  // =====================================================
  // DTO içindeki userId ile kullanıcı ile ilişki kurar
  async createNotification(dto: CreateNotificationDto | TestNotificationDto) {
    const notification = this.repo.create({
      ...dto,
      user: { id: dto.userId } as any, 
      // TypeORM relation için sadece id set ediliyor, diğer alanlara gerek yok
    });

    return this.repo.save(notification); 
    // DB’ye kaydet ve kaydı geri döndür
  }

  // =====================================================
  // 2) Gerçek zamanlı bildirim gönder (WebSocket)
  // =====================================================
  async sendInAppNotification(notification: NotificationEntity) {
    this.gateway.sendNotificationToUser(notification.user.id, {
      title: notification.title,
      message: notification.message,
      type: notification.type,
      createdAt: notification.createdAt,
      link: notification.link,
    });
  }

  // =====================================================
  // 3) E-posta bildirim gönder
  // =====================================================
  async sendEmailNotification(notification: NotificationEntity) {
    const user = await this.usersService.findById(notification.user.id);
    // Kullanıcı bilgilerini al

    if (!user || !user.email) return; 
    // Kullanıcı yoksa veya e-posta adresi yoksa fonksiyondan çık

    await this.emailService.sendNotificationEmail(
      user,
      notification.message, 
      // E-posta servisine mesajı gönder
    );
  }

  // =====================================================
  // 4) Genel bildirim fonksiyonu (hem DB, hem in-app, hem email)
  // =====================================================
  async notifyUser(userId: number, dto: CreateNotificationDto) {
    // 1. DB kaydı
    const notification = await this.createNotification({
      ...dto,
      userId,
    });

    // 2. In-app bildirim gönder
    if (dto.channel === 'in_app' || dto.channel === 'both') {
      await this.sendInAppNotification(notification);
    }

    // 3. E-posta gönder
    if (dto.channel === 'email' || dto.channel === 'both') {
      await this.sendEmailNotification(notification);
    }

    return notification; 
    // Oluşturulan bildirimi döndür
  }

  // =====================================================
  // 5) Kullanıcının tüm bildirimlerini getir
  // =====================================================
  async getUserNotifications(userId: number) {
    return this.repo.find({
      where: { user: { id: userId } },
      order: { createdAt: 'DESC' }, 
      // Yeni bildirimler önce gelsin
    });
  }

  // =====================================================
  // 6) Bildirimi okundu olarak işaretle
  // =====================================================
  async markAsRead(id: number, userId: number) {
    const notification = await this.repo.findOne({
      where: { id },
      relations: ['user'], 
      // User relation’ını al → yetki kontrolü için
    });

    if (!notification || notification.user.id !== userId) {
      // Kullanıcı bu bildirime erişemezse
      throw new ForbiddenException('Bu bildirime erişemezsiniz.');
    }

    notification.read = true; 
    return this.repo.save(notification); 
    // Güncelle ve geri döndür
  }

  // =====================================================
  // 7) Bildirimi sil
  // =====================================================
  async delete(id: number, userId: number) {
    const notification = await this.repo.findOne({
      where: { id },
      relations: ['user'], 
      // User relation’ı ile yetki kontrolü yapılır
    });

    if (!notification || notification.user.id !== userId) {
      throw new ForbiddenException('Bu bildirime erişemezsiniz.');
    }

    return this.repo.remove(notification); 
    // Bildirimi DB’den sil
  }

  // =====================================================
  // 8) Tüm bildirimleri temizle
  // =====================================================
  async clearAll(userId: number) {
    return this.repo.delete({
      user: { id: userId }, 
      // Kullanıcının tüm bildirimlerini sil
    });
  }
}