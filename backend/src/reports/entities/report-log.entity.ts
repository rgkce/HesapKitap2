import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
} from 'typeorm';

import { User } from '../../users/entities/user.entity';

// report_logs tablosu: rapor üretim loglarını saklar
@Entity('report_logs')
export class ReportLogEntity {
  // Birincil anahtar, otomatik artan ID
  @PrimaryGeneratedColumn()
  id: number;

  // Üretilen raporun tipi (örn: REQUEST_SUMMARY, PDF_EXPORT)
  @Column()
  reportType: string;

  // Raporu üreten kullanıcı ile ilişki
  // eager: true => log çekildiğinde user bilgisi otomatik gelir
  @ManyToOne(() => User, (user) => user.reportLogs, { eager: true })
  user: User;
  generatedBy: User;

  // Raporun üretildiği tarih (otomatik doldurulur)
  @CreateDateColumn()
  generatedAt: Date;

  // Rapor için kullanılan filtreler JSON formatında saklanır
  // Örnek: { status: "approved", dateFrom: "2026-01-01" }
  @Column({ type: 'json', nullable: true })
  filters: any;
}