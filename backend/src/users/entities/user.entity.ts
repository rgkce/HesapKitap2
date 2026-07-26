import {
  Column,
  Entity,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
  ManyToMany,
  JoinTable,
} from 'typeorm';
import { Role } from '../../roles/entities/role.entity';
import { NotificationEntity } from '../../notifications/entities/notification.entity';
import { ReportLogEntity } from '../../reports/entities/report-log.entity';
import { RequestEntity } from '../../requests/entities/request.entity';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  email: string;

  @Column()
  password: string;

  @Column()
  fullName: string;

  @Column({ nullable: true })
  phoneNumber?: string;

  // auth.service.ts bunu okuyor (getTokens'a payload olarak veriyor)
  @Column({ default: 'user' })
  role: string;

  // logout / refresh token akışında null'a set edilebiliyor
  @Column({ type: 'varchar', nullable: true })
  refreshToken: string | null;

  @Column({ default: true })
  isActive: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @ManyToMany(() => Role, (role) => role.users)
  @JoinTable() // sadece owning side'da (Role tarafında @JoinTable OLMAMALI)
  roles: Role[];

  @OneToMany(() => NotificationEntity, (n) => n.user)
  notifications: NotificationEntity[];

  @OneToMany(() => RequestEntity, (r) => r.createdBy)
  requests: RequestEntity[];

  @OneToMany(() => ReportLogEntity, (r) => r.user)
  reportLogs: ReportLogEntity[];
}

