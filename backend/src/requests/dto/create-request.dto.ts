import { IsString, IsNotEmpty, IsNumber, IsArray, ArrayNotEmpty } from 'class-validator';

export class CreateRequestDto {
  @IsString()
  @IsNotEmpty()
  title: string;

  @IsString()
  @IsNotEmpty()
  description: string;

  @IsNumber()
  totalAmount: number;

  @IsArray()
  @ArrayNotEmpty()
  approvers: number[];
}