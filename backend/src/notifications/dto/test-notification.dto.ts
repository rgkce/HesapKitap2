import { IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class TestNotificationDto {
  @IsString()
  @IsNotEmpty()
  userId: string;

  @IsString()
  @IsNotEmpty()
  title: string;

  @IsString()
  @IsNotEmpty()
  message: string;

  @IsString()
  @IsOptional()
  type?: string = 'TEST';
}
