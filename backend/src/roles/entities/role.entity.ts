// Role Entity: Sistemdeki rollerin (admin, user, moderator...) temsil edildiği tablo
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToMany } from 'typeorm';
import { User } from '../../users/entities/user.entity';

@Entity('roles') // Veritabanındaki tablo adı
export class Role {
  // Otomatik UUID üretilen benzersiz rol kimliği
  @PrimaryGeneratedColumn('uuid')
  id: string;

  // Rol adı (ör. 'admin', 'user') — benzersiz olmalı
  @Column({ unique: true })
  name: string; // admin, user, moderator...

  // Rol açıklaması (opsiyonel)
  @Column({ nullable: true })
  description?: string;

  // Bir rol birden fazla kullanıcıyla ilişkili olabilir (Many-to-Many)
  @ManyToMany(() => User, (user) => user.roles)
  users: User[];

  // Oluşturulma zamanı otomatik olarak set edilir
  @CreateDateColumn()
  createdAt: Date;

  // Güncellenme zamanı otomatik olarak set edilir
  @UpdateDateColumn()
  updatedAt: Date;
}
