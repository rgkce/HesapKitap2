import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { RequestEntity } from '../requests/entities/request.entity';
import { OfferEntity } from '../offers/entities/offer.entity';
import { UserEntity } from '../users/entities/user.entity';

import { ReportFilterDto } from './dto/report-filter.dto';

import * as PDFDocument from 'pdfkit';
import * as ExcelJS from 'exceljs';

@Injectable()
export class ReportsService {
  constructor(
    @InjectRepository(RequestEntity)
    private readonly requestRepository: Repository<RequestEntity>,

    @InjectRepository(OfferEntity)
    private readonly offerRepository: Repository<OfferEntity>,

    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>,
  ) {}

  // 1️⃣ Talep özet raporu
  async getRequestSummary(filters: ReportFilterDto) {
    const query = this.requestRepository.createQueryBuilder('request');

    if (filters.status) {
      query.andWhere('request.status = :status', {
        status: filters.status,
      });
    }

    if (filters.dateFrom) {
      query.andWhere('request.createdAt >= :dateFrom', {
        dateFrom: filters.dateFrom,
      });
    }

    if (filters.dateTo) {
      query.andWhere('request.createdAt <= :dateTo', {
        dateTo: filters.dateTo,
      });
    }

    const total = await query.getCount();

    const pending = await query
      .andWhere('request.status = :pending', { pending: 'pending' })
      .getCount();

    const approved = await query
      .andWhere('request.status = :approved', { approved: 'approved' })
      .getCount();

    const rejected = await query
      .andWhere('request.status = :rejected', { rejected: 'rejected' })
      .getCount();

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
      .leftJoin('offer.request', 'request')
      .select("TO_CHAR(request.createdAt, 'YYYY-MM')", 'month')
      .addSelect('SUM(offer.price)', 'totalAmount')
      .where('offer.status = :status', { status: 'approved' })
      .groupBy('month')
      .orderBy('month', 'ASC');

    if (filters.dateFrom) {
      query.andWhere('request.createdAt >= :dateFrom', {
        dateFrom: filters.dateFrom,
      });
    }

    if (filters.dateTo) {
      query.andWhere('request.createdAt <= :dateTo', {
        dateTo: filters.dateTo,
      });
    }

    return query.getRawMany();
  }

  // 3️⃣ Tedarikçi performans raporu
  async getSupplierPerformance() {
    const data = await this.offerRepository
      .createQueryBuilder('offer')
      .leftJoin('offer.supplier', 'supplier')
      .select('supplier.id', 'supplierId')
      .addSelect('supplier.name', 'supplierName')
      .addSelect(
        "SUM(CASE WHEN offer.status = 'approved' THEN 1 ELSE 0 END)",
        'approvedOffers',
      )
      .addSelect(
        "SUM(CASE WHEN offer.status = 'rejected' THEN 1 ELSE 0 END)",
        'rejectedOffers',
      )
      .groupBy('supplier.id')
      .addGroupBy('supplier.name')
      .getRawMany();

    return data;
  }

  // 4️⃣ Onay süresi analizi
  async getApprovalDurations() {
    const requests = await this.requestRepository.find({
      where: { status: 'approved' },
    });

    let totalDuration = 0;

    requests.forEach((req) => {
      const created = new Date(req.createdAt).getTime();
      const approved = new Date(req.approvedAt).getTime();
      totalDuration += approved - created;
    });

    const averageMs = totalDuration / requests.length;
    const averageHours = averageMs / (1000 * 60 * 60);

    return {
      averageHours,
    };
  }

  // 5️⃣ PDF export
  async exportToPdf(filters: ReportFilterDto): Promise<Buffer> {
    const requests = await this.requestRepository.find();

    const doc = new PDFDocument();
    const buffers: Buffer[] = [];

    doc.on('data', buffers.push.bind(buffers));
    doc.on('end', () => {});

    doc.fontSize(18).text('Request Report', { align: 'center' });
    doc.moveDown();

    requests.forEach((req) => {
      doc
        .fontSize(12)
        .text(
          `ID: ${req.id} | Status: ${req.status} | Created: ${req.createdAt}`,
        );
    });

    doc.end();

    return Buffer.concat(buffers);
  }

  // 6️⃣ Excel export
  async exportToExcel(filters: ReportFilterDto): Promise<Buffer> {
    const requests = await this.requestRepository.find();

    const workbook = new ExcelJS.Workbook();
    const sheet = workbook.addWorksheet('Requests Report');

    sheet.columns = [
      { header: 'ID', key: 'id', width: 10 },
      { header: 'Status', key: 'status', width: 20 },
      { header: 'Created At', key: 'createdAt', width: 25 },
    ];

    requests.forEach((req) => {
      sheet.addRow({
        id: req.id,
        status: req.status,
        createdAt: req.createdAt,
      });
    });

    const buffer = await workbook.xlsx.writeBuffer();
    return Buffer.from(buffer);
  }
}