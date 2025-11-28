export class UserResponseDto {
  id: string;
  email: string;
  fullName: string;
  phoneNumber?: string;
  isActive: boolean;
  createdAt: Date;
}
