import { IsOptional, MinLength, IsString } from 'class-validator';

export class UpdateUserDto {
  @IsOptional()
  @MinLength(6)
  password?: string;

  @IsOptional()
  @IsString()
  fullName?: string;

  @IsOptional()
  phoneNumber?: string;
}
