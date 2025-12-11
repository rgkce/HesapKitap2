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
  imports: [
    // NotificationEntity'yi TypeORM'a tanıtıyoruz
    TypeOrmModule.forFeature([NotificationEntity]),

    // Kullanıcı bilgileri için
    UsersModule,

    // E-posta gönderimi için
    MailerModule,

    // WebSocket bildirimleri için
    SocketModule,
  ],
  controllers: [NotificationsController],
  providers: [
    NotificationsService,
    NotificationGateway,
    EmailService,
  ],
  exports: [
    NotificationsService, // Diğer modüller de bu servisi kullanabilsin
  ],
})
export class NotificationsModule {}
