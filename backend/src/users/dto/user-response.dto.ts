// API cevaplarında kullanılacak, kullanıcıya dönülen veri modeli
export class UserResponseDto {
  id: string;              // Kullanıcı ID'si (UUID formatında)
  email: string;           // Kullanıcı e-posta adresi
  fullName: string;        // Kullanıcının tam adı
  phoneNumber?: string;    // Opsiyonel telefon numarası
  isActive: boolean;       // Kullanıcı aktif/pasif durum bilgisi
  createdAt: Date;         // Oluşturulma tarihi
}
