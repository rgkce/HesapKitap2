# Splash Screen Modülü

## Genel Bakış

Splash Screen modülü, HesapKitap uygulamasının başlangıç ekranını yönetir. Bu modül, uygulama açılışında kullanıcıya marka kimliğini gösterir ve uygulamanın yüklenmesi sırasında güzel bir geçiş deneyimi sağlar.

## Dosya Yapısı

```
features/splash/
├── splash_screen.dart    # Ana splash screen bileşeni
└── README.md            # Bu dokümantasyon
```

## Bileşenler

### 1. SplashScreen (splash_screen.dart)

Uygulamanın başlangıç ekranını oluşturan ana bileşen.

#### Özellikler
- **Animasyonlu Logo**: Fade ve scale animasyonları
- **Gradient Arka Plan**: Dinamik renk geçişleri
- **Marka Kimliği**: Logo ve slogan gösterimi
- **Otomatik Yönlendirme**: 3 saniye sonra login sayfasına geçiş
- **Dark Mode Desteği**: Sistem temasına göre uyum
- **Responsive Tasarım**: Farklı ekran boyutlarına uyum

## Teknik Detaylar

### 1. Animasyon Sistemi

#### AnimationController
```dart
_controller = AnimationController(
  duration: const Duration(seconds: 2),
  vsync: this,
);
```

#### Fade Animation
```dart
_fadeAnimation = CurvedAnimation(
  parent: _controller,
  curve: Curves.easeIn,
);
```

#### Scale Animation
```dart
_scaleAnimation = Tween<double>(
  begin: 0.8,
  end: 1.0,
).animate(CurvedAnimation(
  parent: _controller,
  curve: Curves.elasticOut,
));
```

### 2. Tema Desteği

#### Açık Tema
- Primary ve accent renklerinin gradient geçişi
- Beyaz metin renkleri
- Açık gri tonları

#### Koyu Tema
- Grey800 ve primary renklerinin gradient geçişi
- Secondary renk vurguları
- Koyu gri tonları

### 3. Otomatik Yönlendirme

```dart
Future.delayed(const Duration(seconds: 3), () {
  Navigator.pushReplacementNamed(context, '/login');
});
```

## Görsel Öğeler

### 1. Logo
- **Boyut**: 200x200 piksel
- **Konum**: Merkezi yerleşim
- **Animasyon**: Scale ve fade efektleri
- **Dosya**: `assets/hk-logo.png`

### 2. Uygulama Adı
- **Metin**: "HesapKitap"
- **Stil**: AppStyles.heading1
- **Renk**: Tema uyumlu
- **Animasyon**: Fade efekti

### 3. Slogan
- **Metin**: "Finansını kolay yönet"
- **Stil**: AppStyles.heading3
- **Renk**: Tema uyumlu
- **Animasyon**: Fade efekti

### 4. Arka Plan
- **Gradient**: LinearGradient
- **Renkler**: Tema uyumlu
- **Yön**: TopLeft to BottomRight
- **Animasyon**: 2 saniye geçiş

## Kullanıcı Deneyimi

### 1. Açılış Süreci
1. **0-2 saniye**: Logo ve metin animasyonları
2. **2-3 saniye**: Statik görünüm
3. **3. saniye**: Otomatik login sayfasına geçiş

### 2. Görsel Geri Bildirim
- **Loading**: Animasyonlu logo
- **Progress**: Zamanlayıcı ile otomatik geçiş
- **Branding**: Marka kimliği vurgusu

### 3. Erişilebilirlik
- **Yüksek Kontrast**: Okunabilir renkler
- **Büyük Logo**: Görsel vurgu
- **Açık Metin**: Anlaşılır mesajlar

## Performans Optimizasyonu

### 1. Memory Management
```dart
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

### 2. Asset Loading
- Logo dosyası önceden yüklenir
- Gereksiz widget rebuild'leri önlenir
- SingleTickerProviderStateMixin kullanımı

### 3. Navigation Optimization
- `pushReplacementNamed` kullanımı
- Stack temizleme
- Memory leak önleme

## Kullanım Örnekleri

### Ana Uygulama Entegrasyonu
```dart
MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => const SplashScreen(),
    '/login': (context) => const LoginPage(),
    // Diğer route'lar...
  },
)
```

### Özel Splash Screen
```dart
class CustomSplashScreen extends StatefulWidget {
  @override
  _CustomSplashScreenState createState() => _CustomSplashScreenState();
}
```

## Özelleştirme Seçenekleri

### 1. Animasyon Süresi
```dart
_controller = AnimationController(
  duration: const Duration(seconds: 3), // Değiştirilebilir
  vsync: this,
);
```

### 2. Yönlendirme Süresi
```dart
Future.delayed(const Duration(seconds: 5), () { // Değiştirilebilir
  Navigator.pushReplacementNamed(context, '/login');
});
```

### 3. Logo Boyutu
```dart
Container(
  height: 250, // Değiştirilebilir
  width: 250,  // Değiştirilebilir
  child: Image.asset('assets/hk-logo.png'),
)
```

### 4. Gradient Renkleri
```dart
gradient: LinearGradient(
  colors: [
    AppColors.primary.withOpacity(0.8),
    AppColors.accent.withOpacity(0.8),
  ],
  // Özel renkler eklenebilir
)
```

## Hata Yönetimi

### 1. Asset Loading Hataları
- Logo dosyası bulunamazsa varsayılan ikon gösterilir
- Graceful degradation

### 2. Navigation Hataları
- Route bulunamazsa ana sayfaya yönlendirme
- Error handling

### 3. Animation Hataları
- Controller dispose kontrolü
- Memory leak önleme

## Test Senaryoları

### 1. Animasyon Testleri
- Logo animasyonunun çalışması
- Fade ve scale efektlerinin doğruluğu
- Timing kontrolü

### 2. Tema Testleri
- Açık tema görünümü
- Koyu tema görünümü
- Tema geçişleri

### 3. Navigation Testleri
- Otomatik yönlendirme
- Route geçişleri
- Back button davranışı

### 4. Performance Testleri
- Memory kullanımı
- CPU kullanımı
- Battery drain

## Gelecek Geliştirmeler

- [ ] Progress bar ekleme
- [ ] Skip button özelliği
- [ ] Özelleştirilebilir süreler
- [ ] Daha fazla animasyon efekti
- [ ] Sound effects
- [ ] Haptic feedback
- [ ] Network durumu kontrolü
- [ ] Version check
- [ ] Update notification
- [ ] Offline mode detection

## Best Practices

1. **Performans**: Gereksiz widget rebuild'lerinden kaçının
2. **Memory**: Controller'ları dispose edin
3. **UX**: Kullanıcıyı bekletmeyin
4. **Accessibility**: Yüksek kontrast kullanın
5. **Responsive**: Farklı ekran boyutlarını test edin
6. **Branding**: Marka kimliğini koruyun
7. **Loading**: Kullanıcıya geri bildirim verin

