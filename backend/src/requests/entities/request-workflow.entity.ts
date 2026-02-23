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

export type WorkflowStatus = 'pending' | 'approved' | 'rejected';

@Entity('request_workflows')
export class RequestWorkflowEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => RequestEntity)
  request: RequestEntity;

  @ManyToOne(() => UserEntity)
  approver: UserEntity;

  @Column({ default: 'pending' })
  status: WorkflowStatus;

  @Column({ nullable: true })
  reason: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}