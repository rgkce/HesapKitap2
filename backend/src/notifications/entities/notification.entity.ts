import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, CreateDateColumn } from 'typeorm';
import { User } from '../../users/entities/user.entity';

@Entity('notifications') 
// 'notifications' isimli tabloyu temsil eder
export class NotificationEntity {
  // =====================================================
  // 1) Birincil anahtar (UUID)
  // =====================================================
  @PrimaryGeneratedColumn('uuid')
  id: string;
  // Her bildirimin benzersiz ID'si, UUID tipinde

  // =====================================================
  // 2) Kullanıcı ile ilişki (Many-to-One)
  // =====================================================
  @ManyToOne(() => User, user => user.notifications, {
    onDelete: 'CASCADE', 
    // Kullanıcı silindiğinde tüm ilgili bildirimler de silinir
    eager: false, 
    // İlişki otomatik yüklenmez, gerektiğinde sorguda join ile alınır
  })
  user: User;
  // Bildirim hangi kullanıcıya ait

  // =====================================================
  // 3) Kullanıcı ID’si
  // =====================================================
  @Column()
  userId: string;
  // userId alanı, relation ile birlikte DB’de tutulur
  // Bazı sorgularda doğrudan userId üzerinden filtreleme yapılabilir

  // =====================================================
  // 4) Bildirim başlığı
  // =====================================================
  @Column({ length: 150 })
  title: string;
  // Bildirim başlığı, max 150 karakter

  // =====================================================
  // 5) Bildirim mesajı
  // =====================================================
  @Column({ type: 'text' })
  message: string;
  // Bildirim içeriği, uzun metin için text tipi kullanılır

  // =====================================================
  // 6) Bildirim türü
  // =====================================================
  @Column({ default: 'GENERAL' })
  type: string;
  // Bildirim kategorisi → örn: GENERAL, SUCCESS, WARNING, ERROR

  // =====================================================
  // 7) Okundu durumu
  // =====================================================
  @Column({ default: false })
  isRead: boolean;
  // Bildirim okundu mu? false → okunmadı, true → okundu

  // =====================================================
  // 8) Oluşturulma tarihi
  // =====================================================
  @CreateDateColumn()
  createdAt: Date;
  // Bildirim ne zaman oluşturuldu, otomatik olarak DB tarafından set edilir
}