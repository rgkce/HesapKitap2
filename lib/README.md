# HesapKitap - Flutter Uygulaması

## Genel Bakış

HesapKitap, farklı kullanıcı rollerine sahip bir finansal yönetim uygulamasıdır. Uygulama, admin, yönetici (approver), tedarikçi (supplier), satınalma (customer) ve satınalma yöneticisi (customer approver) rollerini destekler.

## Proje Yapısı

```
lib/
├── main.dart                    # Ana uygulama giriş noktası
├── core/                        # Temel uygulama bileşenleri
│   └── theme/                   # Tema ve stil tanımları
├── features/                    # Özellik modülleri
│   ├── auth/                    # Kimlik doğrulama
│   ├── home/                    # Ana sayfa modülleri
│   │   ├── admin/              # Admin paneli
│   │   ├── approver/           # Yönetici paneli
│   │   ├── customer/           # Satınalma paneli
│   │   ├── customer_approver/  # Satınalma yöneticisi paneli
│   │   └── supplier/           # Tedarikçi paneli
│   ├── navigation/             # Navigasyon bileşenleri
│   └── splash/                 # Splash ekranı
└── README.md                   # Bu dosya
```

## Ana Özellikler

### 1. Kullanıcı Rolleri
- **Admin**: Sistem yönetimi, kullanıcı yönetimi, raporlar
- **Yönetici (Approver)**: Talepleri onaylama, tedarikçi yönetimi
- **Tedarikçi (Supplier)**: Teklif verme, stok yönetimi, ödemeler
- **Satınalma (Customer)**: Talep oluşturma, teklif görüntüleme
- **Satınalma Yöneticisi (Customer Approver)**: Teklifleri onaylama

### 2. Temel Özellikler
- Çoklu kullanıcı rolü desteği
- Açık/koyu tema desteği
- Responsive tasarım
- Gradient arka planlar
- Modern UI/UX tasarımı
- Grafik ve analitik görünümler

### 3. Teknoloji Stack
- **Flutter**: 3.7.0+
- **Dart**: 3.7.0+
- **fl_chart**: Grafik görselleştirme
- **vector_math**: Matematiksel hesaplamalar
- **intl**: Uluslararasılaştırma

## Kurulum ve Çalıştırma

1. Flutter SDK'yı yükleyin (3.7.0+)
2. Projeyi klonlayın
3. Bağımlılıkları yükleyin:
   ```bash
   flutter pub get
   ```
4. Uygulamayı çalıştırın:
   ```bash
   flutter run
   ```

## Modül Dokümantasyonu

Her modül için detaylı dokümantasyon aşağıdaki dosyalarda bulunmaktadır:

- [Core Theme](./core/theme/README.md) - Tema ve stil yönetimi
- [Authentication](./features/auth/README.md) - Kimlik doğrulama sistemi
- [Admin Panel](./features/home/admin/README.md) - Admin paneli özellikleri
- [Approver Panel](./features/home/approver/README.md) - Yönetici paneli özellikleri
- [Customer Panel](./features/home/customer/README.md) - Satınalma paneli özellikleri
- [Customer Approver Panel](./features/home/customer_approver/README.md) - Satınalma yöneticisi paneli
- [Supplier Panel](./features/home/supplier/README.md) - Tedarikçi paneli özellikleri
- [Navigation](./features/navigation/README.md) - Navigasyon sistemi
- [Splash Screen](./features/splash/README.md) - Başlangıç ekranı

## Geliştirme Notları

- Uygulama Material Design prensiplerini takip eder
- Tüm sayfalar responsive tasarıma sahiptir
- Tema değişiklikleri sistem ayarlarına göre otomatik olarak uygulanır
- Navigasyon sistemi role-based routing kullanır
- State management için StatefulWidget kullanılır

## Lisans

Bu proje özel bir projedir ve ticari kullanım için tasarlanmıştır.

