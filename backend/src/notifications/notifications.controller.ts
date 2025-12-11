import {
  Controller,
  Get,
  Patch,
  Delete,
  Body,
  Param,
  Req,
  Post,
} from '@nestjs/common';
import { NotificationsService } from './notifications.service';
import { CreateNotificationDto } from './dto/create-notification.dto';
import { TestNotificationDto } from './dto/test-notification.dto';

@Controller('notifications')
export class NotificationsController {
  constructor(private readonly notificationsService: NotificationsService) {}

  // Kullanıcının tüm bildirimlerini getir
  // Gelen JWT'den user.id alır → o user’ın bildirimlerini döndürür.
  @Get()
  async getUserNotifications(@Req() req) {
    const userId = req.user.id;
    return this.notificationsService.getUserNotifications(userId);
  }

  // Bir bildirimi okundu yap
  // Bildirimin id’si route param'ından alınır. Yetki kontrolü NotificationsService içinde yapılır.
  @Patch(':id/read')
  async markAsRead(@Param('id') id: number, @Req() req) {
    const userId = req.user.id;
    return this.notificationsService.markAsRead(id, userId);
  }

  // Bir bildirimi sil
  // Kullanıcı kendine ait olmayan bildirimi silemez (servis içinde kontrol var).
  @Delete(':id')
  async deleteNotification(@Param('id') id: number, @Req() req) {
    const userId = req.user.id;
    return this.notificationsService.delete(id, userId);
  }

  // Tüm bildirimleri temizle
  // Kullanıcının tüm bildirimleri silinir.
  @Delete()
  async clearAll(@Req() req) {
    const userId = req.user.id;
    return this.notificationsService.clearAll(userId);
  }

  // Admin test için bildirim gönder
  @Post('test')
  async testSend(@Body() dto: TestNotificationDto) {
    return this.notificationsService.createNotification(dto);
  }
}
