import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { ReportsController } from './reports.controller';
import { ReportsService } from './reports.service';

import { RequestEntity } from '../requests/entities/request.entity';
import { OfferEntity } from '../offers/entities/offer.entity';
import { UserEntity } from '../users/entities/user.entity';

import { RequestsModule } from '../requests/requests.module';
import { SuppliersModule } from '../suppliers/suppliers.module';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      RequestEntity,
      OfferEntity,
      UserEntity,
    ]),
    RequestsModule,
    SuppliersModule,
    UsersModule,
  ],
  controllers: [ReportsController],
  providers: [ReportsService],
})
export class ReportsModule {}