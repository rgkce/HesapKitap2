import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { RequestsModule } from './requests/requests.module';
import { UsersModule } from './users/users.module';
import { RolesModule } from './roles/roles.module';
import { NotificationsModule } from './notifications/notifications.module';
import { SuppliersModule } from './suppliers/suppliers.module';

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
    // TypeORM veritabanı yapılandırması
    TypeOrmModule.forRoot({
      type: 'postgres',       // Kullanılan veritabanı türü
      host: 'localhost',      // Veritabanı sunucusu
      port: 5432,             // Veritabanı portu
      username: 'postgres',   // Veritabanı kullanıcı adı
      password: 'postgres',   // Veritabanı şifresi
      database: 'purchase_system', // Kullanılacak veritabanı
      entities: [             // Veritabanında kullanılacak entity’ler
        RequestEntity,
        RequestWorkflowEntity,
        User,
      ],
      synchronize: true,      // Entity değişikliklerini otomatik senkronize eder (prod’da dikkat!)
    }),

    // Uygulamanın modülleri
    RequestsModule,        // Talep yönetimi modülü
    UsersModule,           // Kullanıcı yönetimi modülü
    RolesModule,           // Rol ve yetki yönetimi modülü
    NotificationsModule,   // Bildirim gönderme modülü
    SuppliersModule,       // Tedarikçi yönetimi modülü
  ],
})
export class AppModule {}