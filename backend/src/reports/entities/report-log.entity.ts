import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
} from 'typeorm';

import { UserEntity } from '../../users/entities/user.entity';

@Entity('report_logs')
export class ReportLogEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  reportType: string;

  @ManyToOne(() => UserEntity, (user) => user.reportLogs, { eager: true })
  generatedBy: UserEntity;

  @CreateDateColumn()
  generatedAt: Date;

  @Column({ type: 'json', nullable: true })
  filters: any;
}