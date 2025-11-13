

1. **`common/`** → sistem genelinde tekrar kullanılan yardımcı yapılar
2. **`config/`** → ortam değişkenleri, database ve JWT gibi ayar dosyaları

Şimdi bunların her biri için `.txt` planlarını, fonksiyonları ve görev açıklamalarını detaylıca yazıyorum 👇

---

## 📁 `src/common/`

Bu klasör, **guard**, **interceptor**, **decorator** ve **utility**’lerin toplandığı merkezi yardımcı modül yapısıdır.

---

### 📄 `guards/jwt_auth_guard.txt`

**Amaç:** JWT token doğrulaması yaparak route erişimini kontrol eder.
**Fonksiyonlar:**

* `canActivate(context)` → İstek header’ındaki token’ı alır ve doğrular.
* `handleRequest(err, user, info)` → Hatalı token veya kullanıcı bulunamadığında hata fırlatır.

---

### 📄 `guards/roles_guard.txt`

**Amaç:** Kullanıcının rolüne göre erişim izni verir.
**Fonksiyonlar:**

* `canActivate(context)` → `@Roles()` decorator’ı üzerinden izin verilen rolleri kontrol eder.

---

### 📄 `interceptors/logging.interceptor.txt`

**Amaç:** Gelen istekleri ve yanıt sürelerini loglar.
**Fonksiyonlar:**

* `intercept(context, next)` → Request öncesi ve sonrası loglama işlemi yapar.

---

### 📄 `interceptors/transform.interceptor.txt`

**Amaç:** API cevaplarını standart bir JSON yapısına dönüştürür.
**Fonksiyonlar:**

* `intercept(context, next)` → Response verisini `{ success, data, timestamp }` formatına çevirir.

---

### 📄 `decorators/roles.decorator.txt`

**Amaç:** Belirli endpoint’leri sadece belirli rollerin erişebilmesini sağlar.
**Fonksiyonlar:**

* `Roles(...roles)` → Metadata olarak rol listesi ekler.

---

### 📄 `decorators/user.decorator.txt`

**Amaç:** Request içerisindeki kullanıcı bilgisini kolayca çekmek için.
**Fonksiyonlar:**

* `User()` → `@User()` decorator’ı, `req.user` objesini döner.

---

### 📄 `utils/password.util.txt`

**Amaç:** Parola hashleme ve doğrulama işlemlerini yönetir.
**Fonksiyonlar:**

* `hashPassword(password)` → bcrypt ile hash oluşturur.
* `comparePasswords(password, hash)` → Parola doğrulaması yapar.

---

### 📄 `utils/date.util.txt`

**Amaç:** Tarih formatlama ve fark hesaplama işlevleri içerir.
**Fonksiyonlar:**

* `formatDate(date)` → Tarihi ISO veya yerel formatta döner.
* `getDateRange(days)` → Son X günün tarih aralığını döner.

---

### 📄 `utils/logger.util.txt`

**Amaç:** Konsol veya dosya bazlı loglama arayüzü sağlar.
**Fonksiyonlar:**

* `logInfo(message)` → Bilgi mesajı yazar.
* `logError(message)` → Hata mesajını loglar.
* `logDebug(message)` → Geliştirme ortamı için debug log’u.

---

## 📁 `src/config/`

Bu klasör ortam değişkenleri ve sistem yapılandırmalarını yönetir.

---

### 📄 `config/database.config.txt`

**Amaç:** ORM (örneğin TypeORM veya Prisma) yapılandırmasını döner.
**Fonksiyonlar:**

* `getDatabaseConfig()` → Ortam değişkenlerinden `host`, `port`, `user`, `password`, `dbName` parametrelerini alır.
* `connectDatabase()` → Veritabanına bağlantıyı başlatır, hata durumlarını yakalar.

---

### 📄 `config/jwt.config.txt`

**Amaç:** JWT token yapılandırmasını döner.
**Fonksiyonlar:**

* `getJwtConfig()` → `secret`, `expiresIn`, `refreshExpiresIn` değerlerini `.env`’den çeker.
* `validateJwtEnv()` → Gerekli ortam değişkenlerinin tanımlı olup olmadığını kontrol eder.

---

### 📄 `config/app.config.txt`

**Amaç:** Uygulama genel yapılandırmasını tutar.
**Fonksiyonlar:**

* `getAppConfig()` → `port`, `environment`, `baseUrl` gibi genel ayarları döner.


