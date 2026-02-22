import { IsOptional, IsNumber, IsString } from 'class-validator';

export class OfferFilterDto {

  @IsOptional()
  @IsNumber()
  supplierId?: number;

  @IsOptional()
  @IsNumber()
  requestId?: number;

  @IsOptional()
  @IsString()
  status?: string;
}