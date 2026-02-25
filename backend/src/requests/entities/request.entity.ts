import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

import { UserEntity } from '../../users/entities/user.entity';

// Talep durumu tipleri
export type RequestStatus = 'pending' | 'approved' | 'rejected' | 'cancelled';

/**
 * RequestEntity
 * Satın alma taleplerini temsil eder.
 * Talebin başlığı, açıklaması, tutarı, durumu ve ilgili kullanıcı bilgileri burada saklanır.
 */
@Entity('requests')
export class RequestEntity {
  // Otomatik artan birincil anahtar
  @PrimaryGeneratedColumn()
  id: number;

  // Talebin başlığı
  @Column()
  title: string;

  // Talebin detaylı açıklaması
  @Column('text')
  description: string;

  // Talep edilen toplam tutar
  @Column('decimal')
  totalAmount: number;

  // Talebin durumu (pending, approved, rejected, cancelled)
  @Column({ default: 'pending' })
  status: RequestStatus;

  // Talebi oluşturan kullanıcı
  @ManyToOne(() => UserEntity, user => user.requests)
  createdBy: UserEntity;

  // Talebi onaylayan kullanıcı (varsa)
  @ManyToOne(() => UserEntity, { nullable: true })
  approvedBy: UserEntity;

  // Talep reddedildiyse reddetme sebebi
  @Column({ nullable: true })
  rejectionReason: string;

  // Oluşturulma zamanı otomatik olarak kaydedilir
  @CreateDateColumn()
  createdAt: Date;

  // Güncellenme zamanı otomatik olarak kaydedilir
  @UpdateDateColumn()
  updatedAt: Date;
}