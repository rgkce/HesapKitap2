import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { RequestEntity } from '../requests/entities/request.entity';
import { OfferEntity } from '../offers/entities/offer.entity';
import { UserEntity } from '../users/entities/user.entity';

import { ReportFilterDto } from './dto/report-filter.dto';

import * as PDFDocument from 'pdfkit'; // PDF oluşturmak için kütüphane
import * as ExcelJS from 'exceljs';    // Excel oluşturmak için kütüphane

@Injectable()
export class ReportsService {
  // Repository’ler dependency injection ile inject ediliyor
  constructor(
    @InjectRepository(RequestEntity)
    private readonly requestRepository: Repository<RequestEntity>, // Talep verileri

    @InjectRepository(OfferEntity)
    private readonly offerRepository: Repository<OfferEntity>,     // Teklif verileri

    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>,       // Kullanıcı verileri
  ) {}

  // 1️⃣ Talep özet raporu
  async getRequestSummary(filters: ReportFilterDto) {
    const query = this.requestRepository.createQueryBuilder('request');

    // Filtre: status varsa uygula
    if (filters.status) {
      query.andWhere('request.status = :status', {
        status: filters.status,
      });
    }

    // Filtre: başlangıç tarihi
    if (filters.dateFrom) {
      query.andWhere('request.createdAt >= :dateFrom', {
        dateFrom: filters.dateFrom,
      });
    }

    // Filtre: bitiş tarihi
    if (filters.dateTo) {
      query.andWhere('request.createdAt <= :dateTo', {
        dateTo: filters.dateTo,
      });
    }

    // Toplam talep sayısı
    const total = await query.getCount();

    // Beklemede olan talepler
    const pending = await query
      .andWhere('request.status = :pending', { pending: 'pending' })
      .getCount();

    // Onaylanan talepler
    const approved = await query
      .andWhere('request.status = :approved', { approved: 'approved' })
      .getCount();

    // Reddedilen talepler
    const rejected = await query
      .andWhere('request.status = :rejected', { rejected: 'rejected' })
      .getCount();

    // Özet rapor objesi döndürülüyor
    return {
      total,
      pending,
      approved,
      rejected,
    };
  }

  // 2️⃣ Aylık harcama raporu
  async getMonthlySpending(filters: ReportFilterDto) {
    const query = this.offerRepository
      .createQueryBuilder('offer')
      .leftJoin('offer.request', 'request') // Offer ile Request join
      // Yıl-ay formatında grupla
      .select("TO_CHAR(request.createdAt, 'YYYY-MM')", 'month')
      .addSelect('SUM(offer.price)', 'totalAmount') // Toplam harcama
      .where('offer.status = :status', { status: 'approved' }) // Sadece onaylı teklifler
      .groupBy('month')
      .orderBy('month', 'ASC');

    // Filtre: başlangıç tarihi
    if (filters.dateFrom) {
      query.andWhere('request.createdAt >= :dateFrom', {
        dateFrom: filters.dateFrom,
      });
    }

    // Filtre: bitiş tarihi
    if (filters.dateTo) {
      query.andWhere('request.createdAt <= :dateTo', {
        dateTo: filters.dateTo,
      });
    }

    // Raw veri olarak döndür
    return query.getRawMany();
  }

  // 3️⃣ Tedarikçi performans raporu
  async getSupplierPerformance() {
    const data = await this.offerRepository
      .createQueryBuilder('offer')
      .leftJoin('offer.supplier', 'supplier')
      .select('supplier.id', 'supplierId')
      .addSelect('supplier.name', 'supplierName')
      // Onaylanan teklif sayısı
      .addSelect(
        "SUM(CASE WHEN offer.status = 'approved' THEN 1 ELSE 0 END)",
        'approvedOffers',
      )
      // Reddedilen teklif sayısı
      .addSelect(
        "SUM(CASE WHEN offer.status = 'rejected' THEN 1 ELSE 0 END)",
        'rejectedOffers',
      )
      .groupBy('supplier.id')
      .addGroupBy('supplier.name')
      .getRawMany();

    return data; // Tedarikçi performans listesi
  }

  // 4️⃣ Onay süresi analizi
  async getApprovalDurations() {
    // Onaylanan talepler
    const requests = await this.requestRepository.find({
      where: { status: 'approved' },
    });

    let totalDuration = 0;

    // Her talep için onay süresini hesapla
    requests.forEach((req) => {
      const created = new Date(req.createdAt).getTime();
      const approved = new Date(req.approvedAt).getTime();
      totalDuration += approved - created; // MS cinsinden fark
    });

    const averageMs = totalDuration / requests.length;
    const averageHours = averageMs / (1000 * 60 * 60); // Saat cinsine çevir

    return {
      averageHours, // Ortalama onay süresi
    };
  }

  // 5️⃣ PDF export
  async exportToPdf(filters: ReportFilterDto): Promise<Buffer> {
    // Tüm talepler
    const requests = await this.requestRepository.find();

    const doc = new PDFDocument(); // PDF dokümanı oluştur
    const buffers: Buffer[] = [];  // Buffer dizisi

    // PDF verilerini buffer dizisine ekle
    doc.on('data', buffers.push.bind(buffers));
    doc.on('end', () => {});

    // Başlık
    doc.fontSize(18).text('Request Report', { align: 'center' });
    doc.moveDown();

    // Taleplerin her biri satır olarak ekleniyor
    requests.forEach((req) => {
      doc
        .fontSize(12)
        .text(
          `ID: ${req.id} | Status: ${req.status} | Created: ${req.createdAt}`,
        );
    });

    doc.end(); // PDF bitir

    return Buffer.concat(buffers); // PDF buffer olarak dön
  }

  // 6️⃣ Excel export
  async exportToExcel(filters: ReportFilterDto): Promise<Buffer> {
    // Tüm talepler
    const requests = await this.requestRepository.find();

    const workbook = new ExcelJS.Workbook(); // Excel workbook
    const sheet = workbook.addWorksheet('Requests Report'); // Sheet oluştur

    // Kolon başlıkları ve genişlikleri
    sheet.columns = [
      { header: 'ID', key: 'id', width: 10 },
      { header: 'Status', key: 'status', width: 20 },
      { header: 'Created At', key: 'createdAt', width: 25 },
    ];

    // Her talep satır olarak ekleniyor
    requests.forEach((req) => {
      sheet.addRow({
        id: req.id,
        status: req.status,
        createdAt: req.createdAt,
      });
    });

    const buffer = await workbook.xlsx.writeBuffer(); // Excel buffer
    return Buffer.from(buffer); // Buffer olarak dön
  }
}