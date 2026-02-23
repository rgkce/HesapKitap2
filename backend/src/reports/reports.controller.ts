import {
  Controller,
  Get,
  Query,
  UseGuards,
  Res,
} from '@nestjs/common';
import { Response } from 'express';

import { ReportsService } from './reports.service';
import { ReportFilterDto } from './dto/report-filter.dto';

import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';

@Controller('reports')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('admin', 'approver', 'customer_approver')
export class ReportsController {
  constructor(private readonly reportsService: ReportsService) {}

  // 1️⃣ Talep özet raporu
  @Get('requests-summary')
  async getRequestSummaryReport(@Query() dto: ReportFilterDto) {
    return this.reportsService.getRequestSummary(dto);
  }

  // 2️⃣ Aylık harcama raporu
  @Get('monthly-spending')
  async getMonthlySpendingReport(@Query() dto: ReportFilterDto) {
    return this.reportsService.getMonthlySpending(dto);
  }

  // 3️⃣ Tedarikçi performans raporu
  @Get('supplier-performance')
  async getSupplierPerformanceReport() {
    return this.reportsService.getSupplierPerformance();
  }

  // 4️⃣ Onay süresi raporu
  @Get('approval-duration')
  async getApprovalDurationReport() {
    return this.reportsService.getApprovalDurations();
  }

  // 5️⃣ PDF export
  @Get('export/pdf')
  async exportRequestsPdf(
    @Query() dto: ReportFilterDto,
    @Res() res: Response,
  ) {
    const buffer = await this.reportsService.exportToPdf(dto);

    res.set({
      'Content-Type': 'application/pdf',
      'Content-Disposition': 'attachment; filename="requests-report.pdf"',
    });

    res.send(buffer);
  }

  // 6️⃣ Excel export
  @Get('export/excel')
  async exportRequestsExcel(
    @Query() dto: ReportFilterDto,
    @Res() res: Response,
  ) {
    const buffer = await this.reportsService.exportToExcel(dto);

    res.set({
      'Content-Type':
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'Content-Disposition': 'attachment; filename="requests-report.xlsx"',
    });

    res.send(buffer);
  }
}