import { IsNumber, IsString, IsOptional, IsPositive, IsInt } from 'class-validator';

export class CreateOfferDto {

  @IsNumber()
  requestId: number;

  @IsNumber()
  @IsPositive()
  price: number;

  @IsString()
  currency: string;

  @IsInt()
  @IsPositive()
  deliveryDays: number;

  @IsOptional()
  @IsString()
  description?: string;
}