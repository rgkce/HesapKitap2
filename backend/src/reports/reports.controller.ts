import {
  Controller,
  Get,
  Query,
  UseGuards,
  Res,
} from '@nestjs/common';
import type { Response } from 'express';

import { ReportsService } from './reports.service';
import { ReportFilterDto } from './dto/report-filter.dto';

import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';

// reports route prefix’i ile controller tanımlanıyor
@Controller('reports')
// Bu controller’daki tüm endpointler için JWT ve role bazlı guard uygulanıyor
@UseGuards(JwtAuthGuard, RolesGuard)
// Bu endpointlere sadece admin, approver ve customer_approver erişebilir
@Roles('admin', 'approver', 'customer_approver')
export class ReportsController {
  // ReportsService dependency injection ile inject ediliyor
  constructor(private readonly reportsService: ReportsService) {}

  // 1️⃣ Talep özet raporu endpoint’i
  // GET /reports/requests-summary
  // Query parametreleri ReportFilterDto ile alınıyor
  @Get('requests-summary')
  async getRequestSummaryReport(@Query() dto: ReportFilterDto) {
    // Service üzerinden talep özet raporu hesaplanıyor ve JSON olarak dönülüyor
    return this.reportsService.getRequestSummary(dto);
  }

  // 2️⃣ Aylık harcama raporu endpoint’i
  // GET /reports/monthly-spending
  @Get('monthly-spending')
  async getMonthlySpendingReport(@Query() dto: ReportFilterDto) {
    // Service üzerinden aylık harcama raporu hesaplanıyor ve JSON olarak dönülüyor
    return this.reportsService.getMonthlySpending(dto);
  }

  // 3️⃣ Tedarikçi performans raporu endpoint’i
  // GET /reports/supplier-performance
  @Get('supplier-performance')
  async getSupplierPerformanceReport() {
    // Service üzerinden tedarikçi performansı hesaplanıyor ve JSON olarak dönülüyor
    return this.reportsService.getSupplierPerformance();
  }

  // 4️⃣ Onay süresi raporu endpoint’i
  // GET /reports/approval-duration
  @Get('approval-duration')
  async getApprovalDurationReport() {
    // Service üzerinden onay süresi analizi hesaplanıyor ve JSON olarak dönülüyor
    return this.reportsService.getApprovalDurations();
  }

  // 5️⃣ PDF export endpoint’i
  // GET /reports/export/pdf
  @Get('export/pdf')
  async exportRequestsPdf(
    @Query() dto: ReportFilterDto, // Filtre parametreleri
    @Res() res: Response, // Express response object, dosya indirme için
  ) {
    // PDF buffer oluşturuluyor
    const buffer = await this.reportsService.exportToPdf(dto);

    // Response header’ları ayarlanıyor, tarayıcıda otomatik download başlatacak
    res.set({
      'Content-Type': 'application/pdf',
      'Content-Disposition': 'attachment; filename="requests-report.pdf"',
    });

    // PDF dosyası gönderiliyor
    res.send(buffer);
  }

  // 6️⃣ Excel export endpoint’i
  // GET /reports/export/excel
  @Get('export/excel')
  async exportRequestsExcel(
    @Query() dto: ReportFilterDto, // Filtre parametreleri
    @Res() res: Response, // Express response object, dosya indirme için
  ) {
    // Excel buffer oluşturuluyor
    const buffer = await this.reportsService.exportToExcel(dto);

    // Response header’ları ayarlanıyor, tarayıcıda otomatik download başlatacak
    res.set({
      'Content-Type':
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'Content-Disposition': 'attachment; filename="requests-report.xlsx"',
    });

    // Excel dosyası gönderiliyor
    res.send(buffer);
  }
}