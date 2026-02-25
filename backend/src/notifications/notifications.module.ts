import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { NotificationEntity } from './entities/notification.entity';

import { NotificationsController } from './notifications.controller';
import { NotificationsService } from './notifications.service';
import { NotificationGateway } from './notification.gateway';
import { EmailService } from './email.service';

// Dış modüller
import { UsersModule } from '../users/users.module';
import { MailerModule } from '@nestjs-modules/mailer';
import { SocketModule } from '../socket/socket.module';

@Module({
  // =====================================================
  // 1) Modülün importları
  // =====================================================
  imports: [
    // NotificationEntity'yi TypeORM'a tanıtıyoruz
    TypeOrmModule.forFeature([NotificationEntity]),

    // Kullanıcı bilgilerini almak için UsersModule
    UsersModule,

    // E-posta göndermek için MailerModule
    MailerModule,

    // WebSocket bildirimleri için SocketModule
    SocketModule,
  ],

  // =====================================================
  // 2) Controller
  // =====================================================
  controllers: [NotificationsController],
  // NotificationsController → endpointleri yönetir (HTTP istekleri)

  // =====================================================
  // 3) Provider’lar
  // =====================================================
  providers: [
    NotificationsService,  // Bildirimlerin iş mantığını yönetir
    NotificationGateway,   // WebSocket üzerinden gerçek zamanlı bildirim gönderir
    EmailService,          // E-posta gönderim servisidir
  ],

  // =====================================================
  // 4) Export edilenler
  // =====================================================
  exports: [
    NotificationsService, // Diğer modüller NotificationsService'i kullanabilir
  ],
})
export class NotificationsModule {}