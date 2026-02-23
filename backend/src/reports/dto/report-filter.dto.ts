import { IsOptional, IsDateString, IsNumber, IsString } from 'class-validator';
import { Type } from 'class-transformer';

export class ReportFilterDto {
  @IsOptional()
  @IsString()
  status?: string;

  @IsOptional()
  @IsDateString()
  dateFrom?: Date;

  @IsOptional()
  @IsDateString()
  dateTo?: Date;

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  supplierId?: number;

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  createdBy?: number;
}