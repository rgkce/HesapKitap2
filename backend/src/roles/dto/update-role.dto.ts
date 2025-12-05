// UpdateRoleDto: Var olan bir rolün güncellenmesinde kullanılan DTO
import { IsOptional } from 'class-validator';

export class UpdateRoleDto {
  // Rol adı isteğe bağlıdır — sadece gönderilen alanlar güncellenir
  @IsOptional()
  name?: string;

  // Rol açıklaması isteğe bağlıdır
  @IsOptional()
  description?: string;
}
