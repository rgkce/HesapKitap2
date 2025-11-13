

# **auth/**

## 📦 Paket Adı

`auth` – Kimlik Doğrulama Modülü

---

## 🎯 **Amaç**

Bu modül, tüm kullanıcıların güvenli bir şekilde **kayıt**, **giriş**, **çıkış** işlemlerini yapmasını; ayrıca **JWT token**’ları üzerinden kimlik doğrulama ve **role-based access control (RBAC)** sistemini sağlar.

Ayrıca kullanıcıların rollerine göre (admin, approver, supplier, customer, customer_approver) erişim sınırlarını belirler.

---

## 📁 **Dosyalar ve Fonksiyonlar**

### 1. **auth.module.ts**

* `imports`: `UsersModule`, `JwtModule`, `PassportModule`
* `controllers`: `AuthController`
* `providers`: `AuthService`, `JwtStrategy`
* 📌 *Modülün NestJS içinde bağımlılıklarını ve servislerini tanımlar.*

---

### 2. **auth.controller.ts**

Uygulama dışından gelen HTTP isteklerini karşılar.

#### Fonksiyonlar:

* `register(@Body() dto: RegisterDto)`

  * Yeni kullanıcı kaydı oluşturur.
  * `AuthService.register()` çağrılır.
* `login(@Body() dto: LoginDto)`

  * Kullanıcı girişini yapar.
  * `AuthService.login()` çağrılır ve JWT token döner.
* `refresh(@Body() token: RefreshTokenDto)`

  * JWT yenileme işlemi yapar.
* `logout(@Req() req)`

  * Session veya refresh token iptali.

---

### 3. **auth.service.ts**

Kimlik doğrulama iş mantığının yürütüldüğü katman.

#### Fonksiyonlar:

* `register(dto: RegisterDto)`

  * Yeni kullanıcıyı oluşturur.
  * Şifreyi hashler (`bcrypt` ile).
  * DB’ye kaydeder.
  * JWT token döner.
* `validateUser(email: string, password: string)`

  * Kullanıcı var mı, şifre doğru mu kontrol eder.
* `login(dto: LoginDto)`

  * JWT access ve refresh token oluşturur.
  * Kullanıcı bilgilerini döner.
* `getTokens(userId: number, role: string)`

  * Kullanıcı için access & refresh token üretir.
* `refreshToken(userId: number, refreshToken: string)`

  * Refresh token geçerliyse yeni token döner.
* `logout(userId: number)`

  * Refresh token’ı null yapar veya siler.

---

### 4. **dto/**

#### a. `register.dto.ts`

```ts
{
  fullName: string;
  email: string;
  password: string;
  role: string;
}
```

#### b. `login.dto.ts`

```ts
{
  email: string;
  password: string;
}
```

#### c. `refresh-token.dto.ts`

```ts
{
  refreshToken: string;
}
```

---

### 5. **strategies/**

#### a. `jwt.strategy.ts`

* `validate(payload: JwtPayload)`

  * Token geçerli mi kontrol eder.
  * Payload’dan userId ve role bilgisini çıkarır.
* `extractJwtFromHeader()`

  * Authorization header’dan token alır.

#### b. `local.strategy.ts`

* Email + Password doğrulaması yapar (Passport Local).

---

### 6. **guards/**

#### a. `jwt-auth.guard.ts`

* Protected route’lar için JWT doğrulaması yapar.

#### b. `roles.guard.ts`

* Kullanıcının rolünü kontrol eder.
* `@Roles()` decorator’u ile birlikte çalışır.

---

### 7. **decorators/**

#### a. `@Roles(...roles: string[])`

* Belirtilen rollerin erişimini sınırlar.
* Controller endpointlerinde kullanılır.

```ts
@Roles('admin', 'approver')
@Get('admin-data')
getAdminData() { ... }
```

---

## 🔄 **Veri Akışı**

### 1. **Kayıt (Register)**

```
User → /auth/register → AuthController → AuthService.register()
 → Password hash → User kaydı → Token üretimi → JWT + RefreshToken döner
```

### 2. **Giriş (Login)**

```
User → /auth/login → AuthController → AuthService.login()
 → Kullanıcı doğrulama → Token üretimi → JWT döner
```

### 3. **JWT Doğrulama**

```
Client → Protected Route → JwtGuard → JwtStrategy.validate()
 → Token doğrulama → Kullanıcı bilgisi payload’dan alınır
```

### 4. **Rol Doğrulama**

```
Controller’da @Roles() → RolesGuard kontrol eder → Erişim izni verilir veya reddedilir
```

---

## 🔐 **Kullanıldığı Modüller**

* `users` → kullanıcı doğrulama & kayıt işlemleri
* `roles` → rol tanımları ve izin yönetimi
* `common/guards` → JWT & Role guard’ları
* `config/jwt.config.ts` → JWT ayarları

---

## 🧱 **Ek Özellikler**

* JWT Access Token: 15 dk
* Refresh Token: 7 gün
* Token rotation mekanizması
* bcrypt hash: 10 salt rounds
* Role tabanlı erişim kontrolü

---
