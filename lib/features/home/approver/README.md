# Approver Panel Modülü

## Genel Bakış

Approver Panel modülü, HesapKitap uygulamasının yönetici (onaylayıcı) kullanıcıları için özelleştirilmiş arayüzünü sağlar. Bu modül, talep onaylama, tedarikçi yönetimi, raporlama ve profil yönetimi özelliklerini içerir.

## Dosya Yapısı

```
features/home/approver/
├── approver_home_page.dart      # Ana dashboard sayfası
├── approver_request_page.dart   # Talep onaylama sayfası
├── approver_reports_page.dart   # Raporlar sayfası
├── approver_profile_page.dart   # Profil sayfası
├── approversupplier_page.dart   # Tedarikçi yönetimi sayfası
├── widgets/
│   └── hk_buttons.dart         # Özel buton bileşenleri
└── README.md                   # Bu dokümantasyon
```

## Bileşenler

### 1. ApproverHomePage (approver_home_page.dart)

Yönetici kullanıcılarının ana dashboard sayfası.

#### Özellikler
- **Bekleyen Talepler**: Onay bekleyen taleplerin listesi
- **Özet İstatistikler**: Onaylanan, reddedilen, bekleyen sayıları
- **Performans Grafiği**: fl_chart kullanılarak oluşturulan grafik
- **Gradient Arka Plan**: Modern görsel tasarım
- **Responsive Layout**: Farklı ekran boyutlarına uyum

#### Bekleyen Talepler
- **Talep #101**: Bekliyor
- **Talep #102**: Bekliyor
- **Talep #103**: Bekliyor

### 2. ApproverRequestPage (approver_request_page.dart)

Talep onaylama sayfası.

#### Özellikler
- Talep listesi
- Talep detayları
- Onay/red işlemleri
- Yorum ekleme
- Filtreleme seçenekleri
- Toplu işlemler

### 3. ApproverReportsPage (approver_reports_page.dart)

Yönetici raporlama sayfası.

#### Özellikler
- Onay raporları
- Performans analizi
- Talep analizi
- Tedarikçi analizi
- Grafik görselleştirmeleri

### 4. ApproverProfilePage (approver_profile_page.dart)

Yönetici profil yönetim sayfası.

#### Özellikler
- Profil bilgileri
- Yetki ayarları
- Bildirim tercihleri
- Hesap ayarları
- Çıkış yapma

### 5. ApproverSuppliersPage (approversupplier_page.dart)

Tedarikçi yönetim sayfası.

#### Özellikler
- Tedarikçi listesi
- Tedarikçi detayları
- Performans değerlendirme
- Onay durumu yönetimi
- İletişim bilgileri

### 6. HKButtons (widgets/hk_buttons.dart)

Özel buton bileşenleri.

#### Özellikler
- Onay butonu
- Red butonu
- Bekleme butonu
- Özel stiller
- Loading durumları

## Tasarım Özellikleri

### 1. Görsel Tasarım
- **Gradient Arka Plan**: Primary ve accent renklerinin geçişi
- **İstatistik Kartları**: Renkli metrik kartları
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
          spots: performanceData,
        ),
      ],
    ),
  ),
)
```

### 2. İstatistik Kartları
```dart
Widget _buildStatCard({
  required String label,
  required String value,
  required Color color,
}) {
  return Container(
    width: 120,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withOpacity(0.9),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [...],
    ),
    child: Column(...),
  );
}
```

### 3. Talep Listesi
```dart
Widget _buildRequestItem(Map<String, String> request) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.grey600.withOpacity(0.8),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Talep bilgileri
      ],
    ),
  );
}
```

## Kullanım Örnekleri

### Dashboard Kullanımı
```dart
Navigator.pushReplacementNamed(context, '/approver_home');
```

### İstatistik Kartı Oluşturma
```dart
_buildStatCard(
  label: "Onaylanan",
  value: "15",
  color: AppColors.success,
)
```

### Talep Listesi Oluşturma
```dart
final pendingRequests = [
  {"title": "Talep #101", "status": "Bekliyor"},
  {"title": "Talep #102", "status": "Bekliyor"},
  // Diğer talepler...
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
Wrap(
  spacing: 16, // Kartlar arası boşluk
  runSpacing: 16, // Satırlar arası boşluk
  children: [...],
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
- Approver rolü kontrolü
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


