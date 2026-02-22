import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { OfferEntity } from './entities/offer.entity';
import { RequestEntity } from '../requests/entities/request.entity';

import { RequestsModule } from '../requests/requests.module';
import { SuppliersModule } from '../suppliers/suppliers.module';
import { NotificationsModule } from '../notifications/notifications.module';

import { OffersController } from './offers.controller';
import { OffersService } from './offers.service';
import { OfferComparisonService } from './offer-comparison.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([OfferEntity, RequestEntity]),
    RequestsModule,
    SuppliersModule,
    NotificationsModule,
  ],
  controllers: [OffersController],
  providers: [OffersService, OfferComparisonService],
})
export class OffersModule {}