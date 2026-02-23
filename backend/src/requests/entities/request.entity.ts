import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

import { UserEntity } from '../../users/entities/user.entity';

export type RequestStatus = 'pending' | 'approved' | 'rejected' | 'cancelled';

@Entity('requests')
export class RequestEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  title: string;

  @Column('text')
  description: string;

  @Column('decimal')
  totalAmount: number;

  @Column({ default: 'pending' })
  status: RequestStatus;

  @ManyToOne(() => UserEntity, user => user.requests)
  createdBy: UserEntity;

  @ManyToOne(() => UserEntity, { nullable: true })
  approvedBy: UserEntity;

  @Column({ nullable: true })
  rejectionReason: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}