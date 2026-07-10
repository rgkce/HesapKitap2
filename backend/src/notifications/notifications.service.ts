import { Injectable, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { NotificationEntity } from './entities/notification.entity';
import { CreateNotificationDto } from './dto/create-notification.dto';
import { TestNotificationDto } from './dto/test-notification.dto';

import { UsersService } from '../users/users.service';
import { NotificationGateway } from './notification.gateway';
import { EmailService } from './email.service';

@Injectable()
export class NotificationsService {
  constructor(
    @InjectRepository(NotificationEntity)
    private readonly repo: Repository<NotificationEntity>,
    private readonly usersService: UsersService,
    private readonly emailService: EmailService,
    private readonly gateway: NotificationGateway,
  ) {}

  // =====================================================
  // 1) Bildirim oluştur
  // =====================================================
  async createNotification(dto: (CreateNotificationDto | TestNotificationDto) & { userId: string }) {
    const notification = this.repo.create({
      ...dto,
      user: { id: dto.userId } as any,
    });

    return this.repo.save(notification);
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
    if (!user || !user.email) return;

    await this.emailService.sendNotificationEmail(user, notification.message);
  }

  // =====================================================
  // 4) Genel bildirim fonksiyonu (hem DB, hem in-app, hem email)
  // =====================================================
  async notifyUser(userId: string, dto: CreateNotificationDto) {
    const notification = await this.createNotification({
      ...dto,
      userId,
    });

    if (dto.channel === 'in_app' || dto.channel === 'both') {
      await this.sendInAppNotification(notification);
    }

    if (dto.channel === 'email' || dto.channel === 'both') {
      await this.sendEmailNotification(notification);
    }

    return notification;
  }

  // =====================================================
  // 4b) Yardımcı metodlar — offers/requests servislerinin çağırdığı isimler
  // =====================================================
  async notifyApprover(userId: string, title: string, message: string) {
    return this.notifyUser(userId, {
      title,
      message,
      channel: 'both',
    } as CreateNotificationDto);
  }

  async notifySupplier(userId: string, title: string, message: string) {
    return this.notifyUser(userId, {
      title,
      message,
      channel: 'both',
    } as CreateNotificationDto);
  }

  async notifyApprovers(userIds: string[], requestId: string) {
    return Promise.all(
      userIds.map((userId) =>
        this.notifyUser(userId, {
          title: 'Yeni onay talebi',
          message: `#${requestId} numaralı talep onayınızı bekliyor.`,
          channel: 'both',
        } as CreateNotificationDto),
      ),
    );
  }

  // =====================================================
  // 5) Kullanıcının tüm bildirimlerini getir
  // =====================================================
  async getUserNotifications(userId: string) {
    return this.repo.find({
      where: { user: { id: userId } },
      order: { createdAt: 'DESC' },
    });
  }

  // =====================================================
  // 6) Bildirimi okundu olarak işaretle
  // =====================================================
  async markAsRead(id: string, userId: string) {
    const notification = await this.repo.findOne({
      where: { id },
      relations: ['user'],
    });

    if (!notification || notification.user.id !== userId) {
      throw new ForbiddenException('Bu bildirime erişemezsiniz.');
    }

    notification.isRead = true; // 'read' değil, entity'deki gerçek alan adı
    return this.repo.save(notification);
  }

  // =====================================================
  // 7) Bildirimi sil
  // =====================================================
  async delete(id: string, userId: string) {
    const notification = await this.repo.findOne({
      where: { id },
      relations: ['user'],
    });

    if (!notification || notification.user.id !== userId) {
      throw new ForbiddenException('Bu bildirime erişemezsiniz.');
    }

    return this.repo.remove(notification);
  }

  // =====================================================
  // 8) Tüm bildirimleri temizle
  // =====================================================
  async clearAll(userId: string) {
    return this.repo.delete({
      user: { id: userId },
    });
  }
}