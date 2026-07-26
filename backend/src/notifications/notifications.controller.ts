import {
  Controller,
  Get,
  Patch,
  Delete,
  Body,
  Param,
  Req,
  Post,
  UseGuards,  // ← ekle
} from '@nestjs/common';
import { NotificationsService } from './notifications.service';
import { CreateNotificationDto } from './dto/create-notification.dto';
import { TestNotificationDto } from './dto/test-notification.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';  // ← ekle

@Controller('notifications')
export class NotificationsController {
  constructor(private readonly notificationsService: NotificationsService) {}

  @UseGuards(JwtAuthGuard)  // ← ekle
  @Get()
  async getUserNotifications(@Req() req) {
    const userId = req.user.userId;  // id → userId
    return this.notificationsService.getUserNotifications(userId);
  }

  @UseGuards(JwtAuthGuard)  // ← ekle
  @Patch(':id/read')
  async markAsRead(@Param('id') id: string, @Req() req) {
    const userId = req.user.userId;  // id → userId
    return this.notificationsService.markAsRead(id, userId);
  }

  @UseGuards(JwtAuthGuard)  // ← ekle
  @Delete(':id')
  async deleteNotification(@Param('id') id: string, @Req() req) {
    const userId = req.user.userId;  // id → userId
    return this.notificationsService.delete(id, userId);
  }

  @UseGuards(JwtAuthGuard)  // ← ekle
  @Delete()
  async clearAll(@Req() req) {
    const userId = req.user.userId;  // id → userId
    return this.notificationsService.clearAll(userId);
  }

  @Post('test')
  async testSend(@Body() dto: TestNotificationDto) {
    return this.notificationsService.createNotification(dto);
  }
}