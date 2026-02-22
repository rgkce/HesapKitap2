import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

import { RequestEntity } from '../../requests/entities/request.entity';
import { UserEntity } from '../../users/entities/user.entity';

@Entity('offers')
export class OfferEntity {

  @PrimaryGeneratedColumn()
  id: number;

  // Teklifin bağlı olduğu talep
  @ManyToOne(() => RequestEntity, (request) => request.offers)
  request: RequestEntity;

  // Teklifi veren supplier
  @ManyToOne(() => UserEntity)
  supplier: UserEntity;

  // Fiyat bilgisi
  @Column('decimal')
  price: number;

  // Para birimi
  @Column()
  currency: string;

  // Teslim süresi (gün)
  @Column('int')
  deliveryDays: number;

  // Açıklama (opsiyonel)
  @Column('text', { nullable: true })
  description: string;

  // Teklif durumu
  @Column({ default: 'pending' })
  status: 'pending' | 'accepted' | 'rejected';

  // Karşılaştırma skoru
  @Column({ nullable: true })
  score: number;

  // Oluşturulma tarihi
  @CreateDateColumn()
  createdAt: Date;

  // Güncellenme tarihi
  @UpdateDateColumn()
  updatedAt: Date;
}