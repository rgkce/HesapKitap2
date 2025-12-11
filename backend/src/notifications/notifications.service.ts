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

  // Bildirim oluştur. dto içindeki userId ile relation kuruyor.
  async createNotification(dto: CreateNotificationDto | TestNotificationDto) {
    const notification = this.repo.create({
      ...dto,
      user: { id: dto.userId } as any, // sadece id set edip relation’ı kuruyor
    });

    return this.repo.save(notification);
  }

  // Gerçek zamanlı bildirim gönder (socket)
  async sendInAppNotification(notification: NotificationEntity) {
    this.gateway.sendNotificationToUser(notification.user.id, {
      title: notification.title,
      message: notification.message,
      type: notification.type,
      createdAt: notification.createdAt,
      link: notification.link,
    });
  }

  // Email gönder
  async sendEmailNotification(notification: NotificationEntity) {
    const user = await this.usersService.findById(notification.user.id);

    if (!user || !user.email) return;

    await this.emailService.sendNotificationEmail(
      user,
      notification.message,
    );
  }

  // Genel bildirim gönderme fonksiyonu.
  // en kritik kısım → her olaydan sonra burayı çağırıyorsun.
  async notifyUser(userId: number, dto: CreateNotificationDto) {
    // 1. DB kaydı
    const notification = await this.createNotification({
      ...dto,
      userId,
    });

    // 2. In-app gönder
    if (dto.channel === 'in_app' || dto.channel === 'both') {
      await this.sendInAppNotification(notification);
    }

    // 3. Email gönder
    if (dto.channel === 'email' || dto.channel === 'both') {
      await this.sendEmailNotification(notification);
    }

    return notification;
  }

  // Bildirimleri getir
  async getUserNotifications(userId: number) {
    return this.repo.find({
      where: { user: { id: userId } },
      order: { createdAt: 'DESC' },
    });
  }

  // Okundu yap (Yetki kontrolü (security))
  async markAsRead(id: number, userId: number) {
    const notification = await this.repo.findOne({
      where: { id },
      relations: ['user'],
    });

    if (!notification || notification.user.id !== userId) {
      throw new ForbiddenException('Bu bildirime erişemezsiniz.');
    }

    notification.read = true;
    return this.repo.save(notification);
  }

  // Sil (Yetki kontrolü (security))
  async delete(id: number, userId: number) {
    const notification = await this.repo.findOne({
      where: { id },
      relations: ['user'],
    });

    if (!notification || notification.user.id !== userId) {
      throw new ForbiddenException('Bu bildirime erişemezsiniz.');
    }

    return this.repo.remove(notification);
  }

  // Tüm bildirimleri temizle
  async clearAll(userId: number) {
    return this.repo.delete({
      user: { id: userId },
    });
  }
}
