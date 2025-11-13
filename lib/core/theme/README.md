# Core Theme Modülü

## Genel Bakış

Core theme modülü, HesapKitap uygulamasının görsel kimliğini ve tasarım sistemini yönetir. Bu modül, uygulama genelinde tutarlı bir görünüm sağlamak için renkler, yazı tipleri ve tema ayarlarını içerir.

## Dosya Yapısı

```
core/theme/
├── app_colors.dart      # Renk paleti tanımları
├── app_styles.dart      # Yazı tipi ve stil tanımları
├── app_theme.dart       # Ana tema konfigürasyonu
└── README.md           # Bu dokümantasyon
```

## Bileşenler

### 1. AppColors (app_colors.dart)

Uygulamanın renk paletini tanımlar. Hem açık hem de koyu tema için uygun renkler içerir.

#### Temel Renkler
- **Primary**: `#3A86FF` - Canlı mavi (ana marka rengi)
- **Secondary**: `#FFBE0B` - Altın sarısı (vurgu rengi)
- **Accent**: `#8338EC` - Mor ton (ikincil vurgu)

#### Arka Plan Renkleri
- **Background Light**: `#F8F9FA` - Açık tema arka plan
- **Background Dark**: `#121212` - Koyu tema arka plan

#### Metin Renkleri
- **Text Dark**: `#212529` - Açık tema metin
- **Text Light**: `#FFFFFF` - Koyu tema metin

#### Durum Renkleri
- **Success**: `#06D6A0` - Başarı/Onay
- **Warning**: `#FF6700` - Uyarı
- **Error**: `#FF4C4C` - Hata/Dikkat
- **Info**: `#00B4D8` - Bilgi/Yardım

#### Gri Tonlar
- **Grey100**: `#F1F3F5` - En açık gri
- **Grey200**: `#E9ECEF` - Açık gri
- **Grey400**: `#ADB5BD` - Orta gri
- **Grey600**: `#495057` - Koyu gri
- **Grey800**: `#343A40` - En koyu gri

### 2. AppStyles (app_styles.dart)

Uygulama genelinde kullanılan yazı tipi stillerini tanımlar.

#### Başlık Stilleri
- **Heading1**: 28px, bold - Ana başlıklar
- **Heading2**: 24px, w600 - Alt başlıklar
- **Heading3**: 20px, w500 - Küçük başlıklar

#### Metin Stilleri
- **BodyText**: 16px, normal - Normal metin
- **BodyTextBold**: 16px, bold - Kalın metin

#### Buton Stilleri
- **ButtonText**: 16px, bold, beyaz renk - Buton metinleri

### 3. AppTheme (app_theme.dart)

Flutter'ın ThemeData sınıfını kullanarak açık ve koyu tema konfigürasyonlarını sağlar.

#### Açık Tema (Light Theme)
- Açık arka plan renkleri
- Koyu metin renkleri
- Canlı renk paleti

#### Koyu Tema (Dark Theme)
- Koyu arka plan renkleri
- Açık metin renkleri
- Daha yumuşak renk tonları

## Kullanım Örnekleri

### Renk Kullanımı
```dart
Container(
  color: AppColors.primary,
  child: Text(
    'Merhaba',
    style: TextStyle(color: AppColors.textLight),
  ),
)
```

### Stil Kullanımı
```dart
Text(
  'Başlık',
  style: AppStyles.heading1,
)
```

### Tema Kullanımı
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,
  // ...
)
```

## Tasarım Prensipleri

### 1. Tutarlılık
- Tüm bileşenler aynı renk paletini kullanır
- Yazı tipleri tutarlı boyutlarda tanımlanmıştır
- Spacing değerleri standartlaştırılmıştır

### 2. Erişilebilirlik
- Renk kontrastları WCAG standartlarına uygun
- Yazı boyutları okunabilirlik için optimize edilmiş
- Koyu tema desteği

### 3. Responsive Tasarım
- Farklı ekran boyutları için uyumlu
- Dinamik renk değişimleri
- Esnek layout yapısı

## Özelleştirme

### Yeni Renk Ekleme
```dart
class AppColors {
  // Mevcut renkler...
  static const Color customColor = Color(0xFF123456);
}
```

### Yeni Stil Ekleme
```dart
class AppStyles {
  // Mevcut stiller...
  static const TextStyle customStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );
}
```

### Tema Özelleştirme
```dart
class AppTheme {
  static final ThemeData customTheme = ThemeData(
    // Özel tema ayarları
  );
}
```

## Best Practices

1. **Renk Kullanımı**: Her zaman AppColors sınıfından renk kullanın
2. **Stil Kullanımı**: Önceden tanımlanmış stilleri tercih edin
3. **Tema Desteği**: Hem açık hem koyu tema için uyumlu kod yazın
4. **Performans**: Gereksiz renk hesaplamalarından kaçının
5. **Bakım**: Renk ve stil değişikliklerini merkezi olarak yapın

## Gelecek Geliştirmeler

- [ ] Animasyon renkleri ekleme
- [ ] Daha fazla yazı tipi seçeneği
- [ ] Responsive font boyutları
- [ ] Özel tema oluşturma arayüzü
- [ ] Renk erişilebilirlik testleri

