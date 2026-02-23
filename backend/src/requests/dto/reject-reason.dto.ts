import { IsString, IsNotEmpty } from 'class-validator';

export class RejectReasonDto {
  @IsString()
  @IsNotEmpty()
  reason: string;
}