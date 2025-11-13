# Authentication Modülü

## Genel Bakış

Authentication modülü, HesapKitap uygulamasının kimlik doğrulama sistemini yönetir. Bu modül, kullanıcı girişi, kayıt olma, şifre sıfırlama ve rol seçimi işlemlerini içerir.

## Dosya Yapısı

```
features/auth/
├── login_page.dart           # Giriş sayfası
├── signup_page.dart          # Kayıt sayfası
├── forgot_password_page.dart # Şifre sıfırlama sayfası
├── role_selection_page.dart  # Rol seçim sayfası
└── README.md                # Bu dokümantasyon
```

## Bileşenler

### 1. LoginPage (login_page.dart)

Kullanıcıların uygulamaya giriş yapmasını sağlayan ana sayfa.

#### Özellikler
- Email ve şifre girişi
- Şifre görünürlük toggle'ı
- Form validasyonu
- Loading durumu
- Hata mesajları
- Gradient arka plan
- Responsive tasarım

#### Kullanıcı Etkileşimleri
- **Giriş Yap**: Email ve şifre doğrulaması
- **Kayıt Ol**: Kayıt sayfasına yönlendirme
- **Şifremi Unuttum**: Şifre sıfırlama sayfasına yönlendirme

#### Teknik Detaylar
```dart
// Test kullanıcı bilgileri
Email: test@example.com
Şifre: 123456
```

### 2. SignUpPage (signup_page.dart)

Yeni kullanıcıların hesap oluşturmasını sağlayan sayfa.

#### Özellikler
- İsim, email ve şifre girişi
- Şifre görünürlük toggle'ı
- Form validasyonu
- Email çakışma kontrolü
- Loading durumu
- Gradient arka plan

#### Kullanıcı Etkileşimleri
- **Kayıt Ol**: Yeni hesap oluşturma
- **Giriş Yap**: Mevcut hesap ile giriş

#### Validasyon Kuralları
- Tüm alanlar zorunlu
- Email formatı kontrolü
- Şifre güvenlik kontrolü

### 3. ForgotPasswordPage (forgot_password_page.dart)

Kullanıcıların şifrelerini sıfırlamasını sağlayan sayfa.

#### Özellikler
- Email girişi
- Form validasyonu
- Loading durumu
- Başarı mesajı
- Otomatik geri dönüş

#### Kullanıcı Etkileşimleri
- **Şifre Sıfırlama Linki Gönder**: Email gönderme simülasyonu
- **Geri Dön**: Login sayfasına dönüş

### 4. RoleSelectionPage (role_selection_page.dart)

Kullanıcıların sistemdeki rollerini seçmesini sağlayan sayfa.

#### Desteklenen Roller
1. **Admin** - Sistem yöneticisi
2. **Yönetici (Approver)** - Onay yetkisi olan kullanıcı
3. **Tedarikçi (Supplier)** - Ürün/hizmet sağlayıcı
4. **Satınalma (Customer)** - Talep oluşturan kullanıcı
5. **Satınalma Yöneticisi (Customer Approver)** - Teklif onaylayan kullanıcı

#### Özellikler
- Rol seçim butonları
- Onay dialog'u
- Geri tuşu engelleme
- Gradient arka plan
- İkonlu butonlar

#### Kullanıcı Etkileşimleri
- **Rol Seçimi**: İlgili ana sayfaya yönlendirme
- **Onay Dialog'u**: Seçimi doğrulama

## Tasarım Özellikleri

### 1. Görsel Tasarım
- **Gradient Arka Plan**: Primary ve accent renklerinin geçişi
- **Modern UI**: Material Design prensipleri
- **Responsive Layout**: Farklı ekran boyutlarına uyum
- **Dark Mode Desteği**: Sistem temasına göre otomatik değişim

### 2. Kullanıcı Deneyimi
- **Tutarlı Tasarım**: Tüm sayfalarda aynı stil
- **Loading States**: İşlem durumu göstergeleri
- **Error Handling**: Kullanıcı dostu hata mesajları
- **Form Validation**: Gerçek zamanlı doğrulama

### 3. Erişilebilirlik
- **Yüksek Kontrast**: Okunabilir renk kombinasyonları
- **Büyük Touch Target'lar**: Kolay dokunma
- **Açık Etiketler**: Anlaşılır form etiketleri

## Güvenlik Özellikleri

### 1. Form Validasyonu
- Boş alan kontrolü
- Email format kontrolü
- Şifre güvenlik kontrolü

### 2. Kullanıcı Doğrulama
- Test kullanıcı bilgileri
- Basit kimlik doğrulama
- Rol bazlı erişim kontrolü

### 3. Session Yönetimi
- Otomatik yönlendirme
- Geri tuşu kontrolü
- State yönetimi

## Teknik Detaylar

### 1. State Management
- StatefulWidget kullanımı
- Local state yönetimi
- Form controller'ları

### 2. Navigation
- Named routes kullanımı
- Push/pop navigation
- Route parametreleri

### 3. Form Handling
- TextEditingController kullanımı
- Form validation
- Input decoration

## Kullanım Örnekleri

### Login Sayfası Kullanımı
```dart
Navigator.pushNamed(context, '/login');
```

### Kayıt Sayfası Kullanımı
```dart
Navigator.pushNamed(context, '/signup');
```

### Rol Seçimi Kullanımı
```dart
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => RoleSelectionPage(
      name: 'Kullanıcı Adı',
      email: 'email@example.com',
    ),
  ),
);
```

## Gelecek Geliştirmeler

- [ ] Gerçek API entegrasyonu
- [ ] Biometric authentication
- [ ] Social login (Google, Facebook)
- [ ] Two-factor authentication
- [ ] Password strength indicator
- [ ] Remember me özelliği
- [ ] Auto-logout timer
- [ ] Session management
- [ ] User profile management
- [ ] Advanced form validation

## Test Senaryoları

### 1. Login Testleri
- Geçerli kullanıcı bilgileri ile giriş
- Geçersiz kullanıcı bilgileri ile giriş
- Boş alan validasyonu
- Loading durumu testi

### 2. Kayıt Testleri
- Yeni kullanıcı kaydı
- Mevcut email ile kayıt
- Form validasyonu
- Başarılı kayıt sonrası yönlendirme

### 3. Şifre Sıfırlama Testleri
- Geçerli email ile sıfırlama
- Boş email validasyonu
- Başarı mesajı gösterimi

### 4. Rol Seçimi Testleri
- Tüm rollerin seçilebilirliği
- Onay dialog'u çalışması
- Doğru sayfaya yönlendirme

