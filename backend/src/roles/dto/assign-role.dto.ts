// AssignRoleDto: Bir kullanıcıya rol atamak için kullanılan DTO
import { IsNotEmpty } from 'class-validator';

export class AssignRoleDto {
  // Rol atanacak kullanıcının ID'si — boş olamaz
  @IsNotEmpty()
  userId: string;

  // Kullanıcıya atanacak rolün ID'si — boş olamaz
  @IsNotEmpty()
  roleId: string;
}
