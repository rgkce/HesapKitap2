export class UserResponseDto {
  id: string;
  email: string;
  fullName: string;
  phoneNumber?: string;
  role: string;        // eklendi
  isActive: boolean;
  createdAt: Date;
}