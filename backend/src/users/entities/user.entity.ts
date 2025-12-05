// User Entity: Veritabanındaki 'users' tablosunu temsil eden yapı
import { Column, Entity, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('users') // Tablo adı
export class User {
  // Benzersiz kullanıcı ID’si (UUID otomatik üretilir)
  @PrimaryGeneratedColumn('uuid')
  id: string;

  // Kullanıcı e-posta adresi – benzersiz constraint içerir
  @Column({ unique: true })
  email: string;

  // Kullanıcının hashlenmiş şifresi
  @Column()
  password: string;

  // Kullanıcının tam adı
  @Column()
  fullName: string;

  // Opsiyonel telefon numarası – null olabilir
  @Column({ nullable: true })
  phoneNumber?: string;

  // Kullanıcının aktif olup olmadığı – default: true
  @Column({ default: true })
  isActive: boolean;

  // Kaydın oluşturulma tarihi otomatik generate edilir
  @CreateDateColumn()
  createdAt: Date;

  // Kaydın güncellenme tarihi otomatik generate edilir
  @UpdateDateColumn()
  updatedAt: Date;
}
