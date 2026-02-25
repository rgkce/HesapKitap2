import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

import { RequestEntity } from '../../requests/entities/request.entity'; // Talep entity'si
import { UserEntity } from '../../users/entities/user.entity'; // Kullanıcı entity'si (supplier)

// Teklif tablosu
@Entity('offers')
export class OfferEntity {

  @PrimaryGeneratedColumn()
  id: number; // Teklifin benzersiz ID'si (otomatik artan)

  // Teklifin bağlı olduğu talep
  @ManyToOne(() => RequestEntity, (request) => request.offers)
  request: RequestEntity;

  // Teklifi veren supplier
  @ManyToOne(() => UserEntity)
  supplier: UserEntity;

  // Teklif fiyatı
  @Column('decimal')
  price: number;

  // Para birimi (örn: USD, EUR, TRY)
  @Column()
  currency: string;

  // Teslim süresi (gün cinsinden)
  @Column('int')
  deliveryDays: number;

  // Teklif açıklaması (opsiyonel)
  @Column('text', { nullable: true })
  description: string;

  // Teklif durumu: pending, accepted, rejected
  @Column({ default: 'pending' })
  status: 'pending' | 'accepted' | 'rejected';

  // Teklifin karşılaştırma skoru (opsiyonel, karşılaştırma sonrası doldurulur)
  @Column({ nullable: true })
  score: number;

  // Teklifin oluşturulma tarihi (DB tarafından otomatik doldurulur)
  @CreateDateColumn()
  createdAt: Date;

  // Teklifin güncellenme tarihi (DB tarafından otomatik doldurulur)
  @UpdateDateColumn()
  updatedAt: Date;
}