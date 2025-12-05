// CreateRoleDto: Yeni bir rol oluşturmak için kullanılan DTO
import { IsNotEmpty, IsOptional } from 'class-validator';

export class CreateRoleDto {
  // Rol adı zorunludur (örn: "admin")
  @IsNotEmpty()
  name: string;

  // Açıklama isteğe bağlıdır
  @IsOptional()
  description?: string;
}
