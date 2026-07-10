import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, CreateDateColumn } from 'typeorm';
import { User } from '../../users/entities/user.entity';

@Entity('notifications')
export class NotificationEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User, (user) => user.notifications, {
    onDelete: 'CASCADE',
    eager: false,
  })
  user: User;

  @Column()
  userId: string;

  @Column({ length: 150 })
  title: string;

  @Column({ type: 'text' })
  message: string;

  @Column({ default: 'GENERAL' })
  type: string;

  @Column({ nullable: true })
  link?: string;   // eklendi — service bunu kullanıyordu

  @Column({ default: false })
  isRead: boolean;

  @CreateDateColumn()
  createdAt: Date;
}