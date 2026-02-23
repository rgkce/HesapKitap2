import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { RequestEntity } from './entities/request.entity';

import { RequestsController } from './requests.controller';
import { RequestsService } from './requests.service';
import { RequestWorkflowService } from './request-workflow.service';

import { UsersModule } from '../users/users.module';
import { RolesModule } from '../roles/roles.module';
import { NotificationsModule } from '../notifications/notifications.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([RequestEntity]),
    UsersModule,
    RolesModule,
    NotificationsModule,
  ],
  controllers: [RequestsController],
  providers: [RequestsService, RequestWorkflowService],
  exports: [RequestsService], // başka modüller kullanabilsin diye (örn: suppliers)
})
export class RequestsModule {}