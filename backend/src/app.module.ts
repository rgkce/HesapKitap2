import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MailerModule } from '@nestjs-modules/mailer';

import { RequestsModule } from './requests/requests.module';
import { UsersModule } from './users/users.module';
import { RolesModule } from './roles/roles.module';
import { NotificationsModule } from './notifications/notifications.module';
import { SuppliersModule } from './suppliers/suppliers.module';
import { Role } from './roles/entities/role.entity';
import { NotificationEntity } from './notifications/entities/notification.entity';
import { ReportLogEntity } from './reports/entities/report-log.entity';
import { OfferEntity } from './offers/entities/offer.entity';
import { AuthModule } from './auth/auth.module';
import { ConfigModule } from '@nestjs/config';

import { RequestEntity } from './requests/entities/request.entity';
import { RequestWorkflowEntity } from './requests/entities/request-workflow.entity';
import { User } from './users/entities/user.entity';

/**
 * AppModule
 * Uygulamanın ana modülü
 * - Veritabanı bağlantısı ve entity’ler burada tanımlanır
 * - Alt modüller (Requests, Users, Roles, Notifications, Suppliers) import edilir
 */
@Module({
  imports: [

    ConfigModule.forRoot({ isGlobal: true }),

    // TypeORM veritabanı yapılandırması
    TypeOrmModule.forRoot({
      type: 'postgres',       // Kullanılan veritabanı türü
      host: 'localhost',      // Veritabanı sunucusu
      port: 5432,             // Veritabanı portu
      username: 'postgres',   // Veritabanı kullanıcı adı
      password: 'Babamrba1.',   // Veritabanı şifresi
      database: 'purchase_system', // Kullanılacak veritabanı
      entities: [             // Veritabanında kullanılacak entity’ler
        RequestEntity,
        RequestWorkflowEntity,
        User,
        Role,
        NotificationEntity,
        ReportLogEntity,
        OfferEntity,
      ],
      synchronize: true,      // Entity değişikliklerini otomatik senkronize eder (prod’da dikkat!)
    }),

    MailerModule.forRoot({
      transport: {
        host: process.env.MAIL_HOST || 'smtp.gmail.com',
        port: 587,
        auth: {
          user: process.env.MAIL_USER || '',
          pass: process.env.MAIL_PASS || '',
        },
      },
      defaults: {
        from: process.env.MAIL_FROM || '"No Reply" <noreply@example.com>',
      },
    }),

    // Uygulamanın modülleri
    RequestsModule,        // Talep yönetimi modülü
    UsersModule,           // Kullanıcı yönetimi modülü
    RolesModule,           // Rol ve yetki yönetimi modülü
    NotificationsModule,   // Bildirim gönderme modülü
    SuppliersModule,       // Tedarikçi yönetimi modülü
    AuthModule,
  ],
})
export class AppModule {}