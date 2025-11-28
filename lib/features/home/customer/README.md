# Customer Panel Modülü

## Genel Bakış

Customer Panel modülü, HesapKitap uygulamasının satınalma kullanıcıları için özelleştirilmiş arayüzünü sağlar. Bu modül, talep oluşturma, teklif görüntüleme, raporlama ve profil yönetimi özelliklerini içerir.

## Dosya Yapısı

```
features/home/customer/
├── customer_dashboard_page.dart.dart  # Ana dashboard sayfası
├── customer_create_request_page.dart  # Talep oluşturma sayfası
├── customer_offers_page.dart         # Teklifler sayfası
├── customer_profile_page.dart        # Profil sayfası
├── customer_reports_page.dart        # Raporlar sayfası
├── offer_detail_page.dart           # Teklif detay sayfası
└── README.md                        # Bu dokümantasyon
```

## Bileşenler

### 1. CustomerDashboardPage (customer_dashboard_page.dart.dart)

Satınalma kullanıcılarının ana dashboard sayfası.

#### Özellikler
- **Özet İstatistikler**: Gelen teklif, onaylanan, reddedilen, bekleyen sayıları
- **Son Teklifler**: En son gelen tekliflerin listesi
- **Teklif Trend Grafiği**: fl_chart kullanılarak oluşturulan grafik
- **Gradient Arka Plan**: Modern görsel tasarım
- **Responsive Layout**: Farklı ekran boyutlarına uyum

#### Özet İstatistikler
1. **Gelen Teklif**: 58 adet
2. **Onaylanan**: 34 adet
3. **Reddedilen**: 12 adet
4. **Bekleyen**: 12 adet

#### Son Teklifler
- **ABC Ltd.**: ₺12.500 (02/09/2025)
- **XYZ A.Ş.**: ₺8.200 (01/09/2025)
- **LMN Tekstil**: ₺15.000 (30/08/2025)

### 2. CustomerCreateRequestPage (customer_create_request_page.dart)

Yeni talep oluşturma sayfası.

#### Özellikler
- Talep formu
- Kategori seçimi
- Öncelik belirleme
- Açıklama alanı
- Dosya ekleme
- Form validasyonu

### 3. CustomerOffersPage (customer_offers_page.dart)

Gelen teklifleri görüntüleme sayfası.

#### Özellikler
- Teklif listesi
- Filtreleme seçenekleri
- Sıralama seçenekleri
- Teklif detayları
- Onay/red işlemleri

### 4. CustomerProfilePage (customer_profile_page.dart)

Kullanıcı profil yönetim sayfası.

#### Özellikler
- Profil bilgileri
- Şifre değiştirme
- Bildirim ayarları
- Hesap tercihleri
- Çıkış yapma

### 5. CustomerReportsPage (customer_reports_page.dart)

Raporlama sayfası.

#### Özellikler
- Talep raporları
- Teklif analizi
- Harcama raporları
- Performans metrikleri
- Grafik görselleştirmeleri

### 6. OfferDetailPage (offer_detail_page.dart)

Teklif detay görüntüleme sayfası.

#### Özellikler
- Detaylı teklif bilgileri
- Tedarikçi bilgileri
- Fiyat analizi
- Onay/red işlemleri
- Yorum ekleme

## Tasarım Özellikleri

### 1. Görsel Tasarım
- **Gradient Arka Plan**: Primary ve accent renklerinin geçişi
- **İstatistik Kartları**: Renkli gradient kartları
- **Modern UI**: Material Design prensipleri
- **Chart Integration**: fl_chart kütüphanesi kullanımı

### 2. Kullanıcı Deneyimi
- **Dashboard View**: Özet bilgi görünümü
- **Interactive Charts**: Etkileşimli grafikler
- **Quick Actions**: Hızlı erişim butonları
- **Status Indicators**: Durum göstergeleri

### 3. Erişilebilirlik
- **High Contrast**: Yüksek kontrast renkler
- **Large Touch Targets**: Büyük dokunma alanları
- **Clear Typography**: Açık yazı tipi
- **Screen Reader Support**: Ekran okuyucu desteği

## Teknik Detaylar

### 1. Chart Integration
```dart
import 'package:fl_chart/fl_chart.dart';

SizedBox(
  height: 200,
  child: LineChart(
    LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(...),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          color: AppColors.success,
          barWidth: 4,
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.success.withOpacity(0.2),
          ),
          dotData: FlDotData(show: true),
          spots: offerTrendData,
        ),
      ],
    ),
  ),
)
```

### 2. İstatistik Kartları
```dart
Widget _buildColoredStatCard(
  String label,
  String value,
  List<Color> gradientColors,
) {
  return Container(
    width: 150,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(18),
      boxShadow: [...],
    ),
    child: Column(...),
  );
}
```

### 3. Responsive Layout
```dart
SizedBox(
  height: 130,
  child: ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: summaryStats.length,
    separatorBuilder: (_, __) => const SizedBox(width: 16),
    itemBuilder: (context, index) {
      // Kart oluşturma
    },
  ),
)
```

## Kullanım Örnekleri

### Dashboard Kullanımı
```dart
Navigator.pushReplacementNamed(context, '/customer_home');
```

### İstatistik Kartı Oluşturma
```dart
_buildColoredStatCard(
  "Gelen Teklif",
  "58",
  [AppColors.info, AppColors.accent],
)
```

### Grafik Verisi Oluşturma
```dart
final offerTrendData = [
  FlSpot(0, 5),
  FlSpot(1, 8),
  FlSpot(2, 6),
  FlSpot(3, 10),
  FlSpot(4, 12),
  FlSpot(5, 9),
  FlSpot(6, 14),
];
```

## Özelleştirme Seçenekleri

### 1. Yeni İstatistik Kartı Ekleme
```dart
summaryStats.add({
  "label": "Yeni Metrik",
  "value": "100",
  "color": AppColors.info,
});
```

### 2. Grafik Özelleştirme
```dart
LineChartBarData(
  isCurved: true,
  color: AppColors.primary, // Özel renk
  barWidth: 6, // Özel kalınlık
  // Diğer özellikler
)
```

### 3. Layout Özelleştirme
```dart
SizedBox(
  height: 150, // Özel yükseklik
  child: ListView.separated(
    scrollDirection: Axis.horizontal,
    // Özel düzen
  ),
)
```

## Performans Optimizasyonu

### 1. Chart Performance
- Efficient data structures
- Optimized rendering
- Memory management

### 2. List Performance
- ListView.separated kullanımı
- Efficient item builders
- Lazy loading

### 3. Widget Optimization
- StatelessWidget kullanımı
- Minimal rebuild'ler
- Efficient state management

## Güvenlik Özellikleri

### 1. Access Control
- Customer rolü kontrolü
- Route protection
- Permission management

### 2. Data Security
- Secure data handling
- Input validation
- Output sanitization

### 3. Session Management
- Secure session handling
- Auto-logout
- Session timeout

## Test Senaryoları

### 1. UI Testleri
- Dashboard görüntüleme
- İstatistik kartları
- Grafik renderı
- Responsive tasarım

### 2. Fonksiyonel Testler
- Navigasyon testleri
- Veri görüntüleme
- Etkileşim testleri
- Performance testleri

### 3. Chart Testleri
- Grafik renderı
- Veri doğruluğu
- Etkileşim testleri
- Performance testleri

## Gelecek Geliştirmeler

- [ ] Gerçek API entegrasyonu
- [ ] Real-time veri güncellemeleri
- [ ] Gelişmiş filtreleme seçenekleri
- [ ] Özelleştirilebilir dashboard
- [ ] Export/import özellikleri
- [ ] Bildirim sistemi
- [ ] Advanced analytics
- [ ] Machine learning insights
- [ ] Mobile optimization
- [ ] Offline support

## Best Practices

1. **Performance**: Optimized rendering
2. **Accessibility**: Erişilebilir tasarım
3. **Maintainability**: Temiz ve düzenli kod
4. **User Experience**: Sezgisel arayüz
5. **Responsive**: Farklı cihazlara uyum
6. **Testing**: Kapsamlı test coverage
7. **Security**: Güvenlik öncelikli tasarım



