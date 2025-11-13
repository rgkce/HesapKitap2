
# **users/**

## 📦 Paket Adı

`users` – Kullanıcı Yönetim Modülü

---

## 🎯 **Amaç**

Bu modül, sistemde kayıtlı kullanıcıların tüm verilerini yönetir.
Admin, Approver, Customer, Customer Approver ve Supplier rollerine ait kullanıcılar bu modül üzerinden oluşturulur, güncellenir, listelenir veya silinir.

Ayrıca kimlik doğrulama (Auth) modülüne kullanıcı verilerini sağlar ve rollerle etkileşim içindedir.

---

## 📁 **Dosyalar ve Fonksiyonlar**

### 1. **users.module.ts**

* `imports`: `TypeOrmModule.forFeature([UserEntity])`, `RolesModule`
* `controllers`: `UsersController`
* `providers`: `UsersService`
* 📌 *User servisini ve kontrolcüsünü NestJS’e bağlar.*

---

### 2. **users.controller.ts**

HTTP isteklerini alır, servise yönlendirir.
Admin ve kullanıcı işlemleri buradan yönetilir.

#### Fonksiyonlar:

* `getAllUsers()`

  * Tüm kullanıcıları getirir (sadece admin erişebilir).
* `getUserById(@Param('id') id: number)`

  * Belirli bir kullanıcıyı getirir.
* `createUser(@Body() dto: CreateUserDto)`

  * Yeni kullanıcı oluşturur (admin veya auth.register).
* `updateUser(@Param('id') id: number, @Body() dto: UpdateUserDto)`

  * Kullanıcı bilgilerini günceller (ör: ad, e-posta, rol).
* `deleteUser(@Param('id') id: number)`

  * Kullanıcıyı sistemden siler.
* `updateRole(@Param('id') id: number, @Body() dto: UpdateRoleDto)`

  * Kullanıcının rolünü değiştirir.
* `getUserProfile(@Req() req)`

  * Giriş yapan kullanıcının profilini döner.

---

### 3. **users.service.ts**

İş mantığını ve veri tabanı işlemlerini yürütür.
`TypeORM` repository’siyle veritabanı etkileşimi sağlar.

#### Fonksiyonlar:

* `findAll()`

  * Tüm kullanıcıları döner.
* `findById(id: number)`

  * ID’ye göre kullanıcıyı bulur.
* `findByEmail(email: string)`

  * E-posta adresine göre kullanıcıyı bulur.
* `create(dto: CreateUserDto)`

  * Yeni kullanıcı oluşturur.
* `update(id: number, dto: UpdateUserDto)`

  * Kullanıcı bilgilerini günceller.
* `remove(id: number)`

  * Kullanıcıyı siler.
* `assignRole(userId: number, role: string)`

  * Kullanıcıya rol atar.
* `getProfile(userId: number)`

  * Kullanıcının profil detaylarını döner.
* `validatePassword(email: string, password: string)`

  * Şifre doğrulaması yapar (`bcrypt.compare` ile).

---

### 4. **entities/user.entity.ts**

Veritabanındaki `users` tablosunun modelidir.

```ts
@Entity('users')
export class UserEntity {
  @PrimaryGeneratedColumn() id: number;
  @Column() fullName: string;
  @Column({ unique: true }) email: string;
  @Column() password: string;
  @Column({ default: 'customer' }) role: string;
  @Column({ nullable: true }) refreshToken: string;
  @CreateDateColumn() createdAt: Date;
  @UpdateDateColumn() updatedAt: Date;
}
```

---

### 5. **dto/**

#### a. `create-user.dto.ts`

```ts
{
  fullName: string;
  email: string;
  password: string;
  role?: string;
}
```

#### b. `update-user.dto.ts`

```ts
{
  fullName?: string;
  email?: string;
  password?: string;
}
```

#### c. `update-role.dto.ts`

```ts
{
  role: string;
}
```

---

## 🔄 **Veri Akışı**

### 1. **Kullanıcı Oluşturma**

```
Admin veya Register → /users → UsersController.createUser()
→ UsersService.create() → DB kayıt → JSON yanıt (user info)
```

### 2. **Kullanıcı Girişi (Auth ile birlikte)**

```
AuthService.validateUser() → UsersService.findByEmail()
→ bcrypt.compare(password) → kullanıcı nesnesi döner
```

### 3. **Profil Görüntüleme**

```
GET /users/profile → JwtAuthGuard → UsersService.getProfile()
→ Kullanıcı bilgileri (şifre hariç)
```

---

## ⚙️ **Kullanıldığı Modüller**

* `auth` → Kullanıcı doğrulama işlemleri
* `roles` → Rol yönetimi ve yetkilendirme
* `requests` → Talep oluşturan kullanıcıların bağlantısı
* `offers` → Teklif oluşturan kullanıcıların bağlantısı

---

## 🔐 **Güvenlik**

* `JwtAuthGuard` ile koruma
* Role kontrolü (`@Roles()` dekoratörü)
* `password` alanı response’larda asla dönmez
* Unique email constraint
* Input validation (DTO + class-validator)

---

## 🧱 **Ek Özellikler**

* Admin tarafından kullanıcı oluşturma / silme yetkisi
* Şifre sıfırlama (gelecekte `auth` üzerinden entegre edilecek)
* Kullanıcı rolleri dinamik olarak değiştirilebilir
* Veritabanında soft delete desteği (isteğe bağlı)

---

