import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { OfferEntity } from './entities/offer.entity'; // Teklif tablosu (DB entity)
import { RequestEntity } from '../requests/entities/request.entity'; // Talep tablosu (DB entity)

import { RequestsModule } from '../requests/requests.module'; // Talep yönetim modülü
import { SuppliersModule } from '../suppliers/suppliers.module'; // Tedarikçi yönetim modülü
import { NotificationsModule } from '../notifications/notifications.module'; // Bildirim modülü

import { OffersController } from './offers.controller'; // Teklif endpointlerini yöneten controller
import { OffersService } from './offers.service'; // Teklif iş mantığını yöneten servis
import { OfferComparisonService } from './offer-comparison.service'; // Teklif karşılaştırma ve skor hesaplama servisi

// OffersModule: Teklif yönetim modülü
@Module({
  imports: [
    // TypeORM üzerinden Offer ve Request entitylerini DB ile ilişkilendir
    TypeOrmModule.forFeature([OfferEntity, RequestEntity]),

    // Modüller arası bağımlılıklar
    RequestsModule,       // Tekliflerin bağlı olduğu taleplerle iletişim
    SuppliersModule,      // Teklif sahipleri (supplier) bilgisi için
    NotificationsModule,  // Teklif oluşturma/güncelleme/sonuç bildirimleri için
  ],
  controllers: [OffersController], // HTTP endpointleri
  providers: [OffersService, OfferComparisonService], // İş mantığı ve karşılaştırma servisi
})
export class OffersModule {} // Modül export edilerek AppModule tarafından kullanılabilir