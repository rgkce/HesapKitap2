import { IsNumber, IsOptional, IsPositive, IsInt, IsString } from 'class-validator';

export class UpdateOfferDto {

  @IsOptional()
  @IsNumber()
  @IsPositive()
  price?: number;

  @IsOptional()
  @IsInt()
  @IsPositive()
  deliveryDays?: number;

  @IsOptional()
  @IsString()
  description?: string;
}