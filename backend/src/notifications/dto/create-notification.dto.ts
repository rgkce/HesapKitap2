import {
  IsEnum,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
} from 'class-validator';

export class CreateNotificationDto {
  @IsNumber()
  @IsNotEmpty()
  userId: number;

  @IsString()
  @IsNotEmpty()
  title: string;

  @IsString()
  @IsNotEmpty()
  message: string;

  @IsEnum(['info', 'success', 'warning', 'error'], {
    message: 'type must be one of: info, success, warning, error',
  })
  @IsOptional()
  type?: 'info' | 'success' | 'warning' | 'error' = 'info';

  @IsString()
  @IsOptional()
  link?: string;

  @IsEnum(['in_app', 'email', 'both'], {
    message: 'channel must be one of: in_app, email, both',
  })
  @IsOptional()
  channel?: 'in_app' | 'email' | 'both' = 'both';
}
