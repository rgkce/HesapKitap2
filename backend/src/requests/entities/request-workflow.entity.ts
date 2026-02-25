import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

import { RequestEntity } from './request.entity';
import { UserEntity } from '../../users/entities/user.entity';

// Workflow durumu tipleri
export type WorkflowStatus = 'pending' | 'approved' | 'rejected';

/**
 * RequestWorkflowEntity
 * Her talep için onay sürecini (workflow) temsil eder
 * Kim onayladı/reddetti ve durum ne oldu gibi bilgileri tutar
 */
@Entity('request_workflows')
export class RequestWorkflowEntity {
  // Otomatik artan birincil anahtar
  @PrimaryGeneratedColumn()
  id: number;

  // Hangi talep ile ilişkili olduğunu belirtir
  @ManyToOne(() => RequestEntity)
  request: RequestEntity;

  // Talebi onaylayan kullanıcı
  @ManyToOne(() => UserEntity)
  approver: UserEntity;

  // Onay durumu (pending, approved, rejected)
  @Column({ default: 'pending' })
  status: WorkflowStatus;

  // Reddetme sebebi varsa burada saklanır
  @Column({ nullable: true })
  reason: string;

  // Oluşturulma zamanı otomatik olarak kaydedilir
  @CreateDateColumn()
  createdAt: Date;

  // Güncellenme zamanı otomatik olarak kaydedilir
  @UpdateDateColumn()
  updatedAt: Date;
}