import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { RequestEntity } from './entities/request.entity';

import { RequestsController } from './requests.controller';
import { RequestsService } from './requests.service';
import { RequestWorkflowService } from './request-workflow.service';

import { UsersModule } from '../users/users.module';
import { RolesModule } from '../roles/roles.module';
import { NotificationsModule } from '../notifications/notifications.module';

/**
 * RequestsModule
 * Satın alma taleplerini yöneten modül
 * Controller, Service ve Workflow servislerini içerir
 */
@Module({
  imports: [
    // RequestEntity için TypeORM repository'sini modüle dahil et
    TypeOrmModule.forFeature([RequestEntity]),
    // Kullanıcı bilgileri için UsersModule
    UsersModule,
    // Roller ve yetki kontrolü için RolesModule
    RolesModule,
    // Bildirim göndermek için NotificationsModule
    NotificationsModule,
  ],
  // Bu modülde bulunan controller
  controllers: [RequestsController],
  // Bu modülde bulunan servisler
  providers: [RequestsService, RequestWorkflowService],
  // RequestsService başka modüller tarafından kullanılabilir
  exports: [RequestsService], // örn: suppliers modülü
})
export class RequestsModule {}