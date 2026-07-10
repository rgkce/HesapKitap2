import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { ReportsController } from './reports.controller';
import { ReportsService } from './reports.service';

import { RequestEntity } from '../requests/entities/request.entity';
import { OfferEntity } from '../offers/entities/offer.entity';
import { User } from '../users/entities/user.entity';

import { RequestsModule } from '../requests/requests.module';
import { SuppliersModule } from '../suppliers/suppliers.module';
import { UsersModule } from '../users/users.module';

// ReportsModule: Raporlama modülü
// Burada gerekli entity’ler, controller ve service tanımlanıyor
@Module({
  imports: [
    // TypeOrmModule ile bu entity’leri repository olarak kullanabiliriz
    TypeOrmModule.forFeature([
      RequestEntity, // Talep tablosu
      OfferEntity,   // Teklif tablosu
      User,    // Kullanıcı tablosu
    ]),
    // İhtiyaç duyulan diğer modüller import ediliyor
    RequestsModule,   // Taleplerle ilgili modül
    SuppliersModule,  // Tedarikçilerle ilgili modül
    UsersModule,      // Kullanıcılarla ilgili modül
  ],
  // Bu modülün controller’ı
  controllers: [ReportsController],
  // Bu modülün servisleri
  providers: [ReportsService],
})
export class ReportsModule {}