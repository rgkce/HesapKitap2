import { IsNotEmpty } from 'class-validator';

export class AssignRoleDto {
  @IsNotEmpty()
  userId: string;

  @IsNotEmpty()
  roleId: string;
}
