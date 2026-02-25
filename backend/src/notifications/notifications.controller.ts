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
// Bu class, /notifications route’u altında tüm endpointleri sağlar
export class NotificationsController {
  constructor(private readonly notificationsService: NotificationsService) {}
  // Notification servisini inject ediyoruz → iş mantığı burada

  // =====================================================
  // Kullanıcının tüm bildirimlerini getir
  // =====================================================
  @Get()
  async getUserNotifications(@Req() req) {
    const userId = req.user.id; 
    // JWT doğrulama sonrası request objesinde user bilgisi gelir
    return this.notificationsService.getUserNotifications(userId);
    // Kullanıcının tüm bildirimlerini servis aracılığıyla döndür
  }

  // =====================================================
  // Bir bildirimi okundu olarak işaretle
  // =====================================================
  @Patch(':id/read')
  async markAsRead(@Param('id') id: number, @Req() req) {
    const userId = req.user.id;
    // Sadece kendi bildirimlerini okuyabilir → servis içinde kontrol edilir
    return this.notificationsService.markAsRead(id, userId);
  }

  // =====================================================
  // Bir bildirimi sil
  // =====================================================
  @Delete(':id')
  async deleteNotification(@Param('id') id: number, @Req() req) {
    const userId = req.user.id;
    // Kullanıcı kendi bildirimlerini silebilir → servis içinde kontrol edilir
    return this.notificationsService.delete(id, userId);
  }

  // =====================================================
  // Tüm bildirimleri temizle
  // =====================================================
  @Delete()
  async clearAll(@Req() req) {
    const userId = req.user.id;
    // Kullanıcının tüm bildirimlerini sil
    return this.notificationsService.clearAll(userId);
  }

  // =====================================================
  // Admin test amaçlı bildirim gönder
  // =====================================================
  @Post('test')
  async testSend(@Body() dto: TestNotificationDto) {
    // TestNotificationDto ile manuel bildirim oluşturur
    return this.notificationsService.createNotification(dto);
  }
}