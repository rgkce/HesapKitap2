# Navigation Modülü

## Genel Bakış

Navigation modülü, HesapKitap uygulamasının navigasyon sistemini yönetir. Bu modül, farklı kullanıcı rollerine göre özelleştirilmiş alt navigasyon çubukları sağlar ve kullanıcıların uygulama içinde kolayca gezinmesini sağlar.

## Dosya Yapısı

```
features/navigation/
├── admin_navbar.dart           # Admin navigasyon çubuğu
├── approver_navbar.dart        # Yönetici navigasyon çubuğu
├── customer_navbar.dart        # Satınalma navigasyon çubuğu
├── customerapprover_navbar.dart # Satınalma yöneticisi navigasyon çubuğu
├── supplier_navbar.dart        # Tedarikçi navigasyon çubuğu
└── README.md                  # Bu dokümantasyon
```

## Bileşenler

### 1. AdminNavBar (admin_navbar.dart)

Admin kullanıcıları için özelleştirilmiş navigasyon çubuğu.

#### Navigasyon Öğeleri
1. **Ana Sayfa** (Icons.home) - `/admin_home`
2. **Kullanıcılar** (Icons.group) - `/admin_users`
3. **Raporlar** (Icons.bar_chart) - `/admin_reports`
4. **Profil** (Icons.person) - `/admin_profile`

#### Özellikler
- Gradient arka plan
- Aktif sayfa vurgusu
- Icon ve metin kombinasyonu
- Responsive tasarım
- Dark mode desteği

### 2. ApproverNavBar (approver_navbar.dart)

Yönetici (Approver) kullanıcıları için özelleştirilmiş navigasyon çubuğu.

#### Navigasyon Öğeleri
1. **Ana Sayfa** (Icons.home) - `/approver_home`
2. **Talepler** (Icons.pending_actions) - `/approver_requests`
3. **Raporlar** (Icons.bar_chart) - `/approver_reports`
4. **Tedarikçiler** (Icons.business) - `/approver_suppliers`
5. **Profil** (Icons.person) - `/approver_profile`

### 3. CustomerNavBar (customer_navbar.dart)

Satınalma (Customer) kullanıcıları için özelleştirilmiş navigasyon çubuğu.

#### Navigasyon Öğeleri
1. **Ana Sayfa** (Icons.home) - `/customer_home`
2. **Teklifler** (Icons.shopping_cart) - `/customer_offers`
3. **Talepler** (Icons.request_page) - `/customer_createrequest`
4. **Raporlar** (Icons.bar_chart) - `/customer_reports`

### 4. CustomerApproverNavBar (customerapprover_navbar.dart)

Satınalma yöneticisi (Customer Approver) kullanıcıları için özelleştirilmiş navigasyon çubuğu.

#### Navigasyon Öğeleri
1. **Ana Sayfa** (Icons.home) - `/customapprover_home`
2. **Teklifler** (Icons.shopping_cart) - `/customapprover_offers`
3. **Raporlar** (Icons.bar_chart) - `/customapprover_reports`
4. **Profil** (Icons.person) - `/customapprover_profile`

### 5. SupplierNavBar (supplier_navbar.dart)

Tedarikçi (Supplier) kullanıcıları için özelleştirilmiş navigasyon çubuğu.

#### Navigasyon Öğeleri
1. **Ana Sayfa** (Icons.home) - `/supplier_home`
2. **Talepler** (Icons.pending_actions) - `/supplier_requests`
3. **Raporlar** (Icons.bar_chart) - `/supplier_reports`
4. **Stok** (Icons.inventory) - `/supplier_stock`
5. **Ödemeler** (Icons.payment) - `/supplier_payments`
6. **Profil** (Icons.person) - `/supplier_profile`

## Tasarım Özellikleri

### 1. Görsel Tasarım
- **Gradient Arka Plan**: Primary ve accent renklerinin geçişi
- **Box Shadow**: Derinlik hissi veren gölge efekti
- **Rounded Corners**: Modern görünüm için yuvarlatılmış köşeler
- **Icon + Text**: Görsel ve metin kombinasyonu

### 2. Etkileşim Tasarımı
- **Active State**: Aktif sayfa vurgusu
- **Hover Effects**: Dokunma efektleri
- **Smooth Transitions**: Yumuşak geçişler
- **Touch Feedback**: Dokunma geri bildirimi

### 3. Responsive Tasarım
- **Flexible Layout**: Esnek düzen
- **Icon Scaling**: Farklı ekran boyutlarına uyum
- **Text Scaling**: Okunabilir metin boyutları
- **Spacing**: Uygun boşluklar

## Teknik Detaylar

### 1. State Management
```dart
class AdminNavBar extends StatelessWidget {
  final int currentIndex;
  
  const AdminNavBar({super.key, required this.currentIndex});
}
```

### 2. Navigation Logic
```dart
void _onItemTapped(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.pushReplacementNamed(context, '/admin_home');
      break;
    // Diğer case'ler...
  }
}
```

### 3. Active State Management
```dart
Widget _navItem(BuildContext context, int index, IconData icon, String label) {
  final bool isActive = index == currentIndex;
  // Aktif durum kontrolü
}
```

## Kullanım Örnekleri

### Admin Navigasyon Kullanımı
```dart
Scaffold(
  body: AdminHomePage(),
  bottomNavigationBar: const AdminNavBar(currentIndex: 0),
)
```

### Customer Navigasyon Kullanımı
```dart
Scaffold(
  body: CustomerDashboardPage(),
  bottomNavigationBar: const CustomerNavBar(currentIndex: 0),
)
```

### Supplier Navigasyon Kullanımı
```dart
Scaffold(
  body: SupplierHomePage(),
  bottomNavigationBar: const SupplierNavBar(currentIndex: 0),
)
```

## Özelleştirme Seçenekleri

### 1. Yeni Navigasyon Öğesi Ekleme
```dart
Widget _navItem(BuildContext context, int index, IconData icon, String label) {
  // Yeni öğe ekleme
  case 4:
    Navigator.pushReplacementNamed(context, '/new_route');
    break;
}
```

### 2. Icon Değiştirme
```dart
Icon(
  Icons.new_icon, // Yeni ikon
  color: isActive ? AppColors.grey100 : AppColors.grey400,
  size: 28,
)
```

### 3. Renk Özelleştirme
```dart
gradient: LinearGradient(
  colors: [
    AppColors.primary.withOpacity(0.8),
    AppColors.accent.withOpacity(0.8),
  ],
  // Özel renkler
)
```

### 4. Boyut Özelleştirme
```dart
Container(
  padding: const EdgeInsets.symmetric(vertical: 15), // Değiştirilebilir
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    // Özel düzen
  ),
)
```

## Performans Optimizasyonu

### 1. Widget Rebuild Minimization
- StatelessWidget kullanımı
- Gereksiz rebuild'lerin önlenmesi
- Efficient state management

### 2. Memory Management
- Controller'ların doğru yönetimi
- Dispose işlemleri
- Memory leak önleme

### 3. Navigation Optimization
- `pushReplacementNamed` kullanımı
- Stack temizleme
- Efficient routing

## Erişilebilirlik Özellikleri

### 1. Görsel Erişilebilirlik
- Yüksek kontrast renkler
- Büyük touch target'lar
- Açık icon'lar

### 2. Dokunsal Erişilebilirlik
- Kolay dokunma
- Responsive feedback
- Clear visual states

### 3. Metin Erişilebilirliği
- Okunabilir font boyutları
- Açık etiketler
- Tutarlı terminoloji

## Test Senaryoları

### 1. Navigation Testleri
- Tüm sayfalar arası geçiş
- Active state kontrolü
- Route doğruluğu

### 2. UI Testleri
- Farklı ekran boyutları
- Dark/light tema
- Responsive tasarım

### 3. Performance Testleri
- Widget rebuild sayısı
- Memory kullanımı
- Navigation hızı

### 4. Accessibility Testleri
- Screen reader uyumluluğu
- Touch target boyutları
- Color contrast

## Gelecek Geliştirmeler

- [ ] Badge sistemi (bildirim sayıları)
- [ ] Animasyonlu geçişler
- [ ] Haptic feedback
- [ ] Özelleştirilebilir düzen
- [ ] Quick actions
- [ ] Search functionality
- [ ] Recent pages
- [ ] Favorites
- [ ] Custom themes
- [ ] Gesture navigation

## Best Practices

1. **Consistency**: Tüm navbar'larda tutarlı tasarım
2. **Accessibility**: Erişilebilir tasarım prensipleri
3. **Performance**: Efficient widget kullanımı
4. **Maintainability**: Temiz ve düzenli kod
5. **User Experience**: Sezgisel navigasyon
6. **Responsive**: Farklı cihazlara uyum
7. **Testing**: Kapsamlı test coverage

