import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { RequestsModule } from './requests/requests.module';
import { UsersModule } from './users/users.module';
import { RolesModule } from './roles/roles.module';
import { NotificationsModule } from './notifications/notifications.module';
import { SuppliersModule } from './suppliers/suppliers.module';

import { RequestEntity } from './requests/entities/request.entity';
import { RequestWorkflowEntity } from './requests/entities/request-workflow.entity';
import { UserEntity } from './users/entities/user.entity';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: 'localhost',
      port: 5432,
      username: 'postgres',
      password: 'postgres',
      database: 'purchase_system',
      entities: [
        RequestEntity,
        RequestWorkflowEntity,
        UserEntity,
      ],
      synchronize: true,
    }),

    RequestsModule,
    UsersModule,
    RolesModule,
    NotificationsModule,
    SuppliersModule,
  ],
})
export class AppModule {}