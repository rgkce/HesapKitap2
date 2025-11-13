
# **roles/**

## Paket Adı

`roles` – Rol ve Yetkilendirme Yönetim Modülü

---

## **Amaç**

Bu modül, uygulamadaki tüm **rolleri (roles)** ve bunlara bağlı **izinleri (permissions)** yönetir.
Her kullanıcı rolü için erişim seviyelerini, görünür sayfaları, işlem yetkilerini ve API erişimlerini tanımlar.

**Kullanıcı rolleri:**

* `admin` – sistem yöneticisi
* `approver` – yönetici (talep onaylayıcı)
* `customer` – satınalma
* `customer_approver` – satınalma yöneticisi
* `supplier` – tedarikçi

---

## **Dosyalar ve Fonksiyonlar**

### 1. **roles.module.ts**

* `imports`: `TypeOrmModule.forFeature([RoleEntity])`
* `controllers`: `RolesController`
* `providers`: `RolesService`
* *Rol servisini ve kontrolcüsünü NestJS’e bağlar.*

---

### 2. **roles.controller.ts**

HTTP isteklerini yönetir.
Sadece `admin` rolüne açık endpoint’ler içerir.

#### Fonksiyonlar:

* `getAllRoles()`

  * Sistemde tanımlı tüm rolleri listeler.
* `getRoleById(@Param('id') id: number)`

  * ID’ye göre rolü getirir.
* `createRole(@Body() dto: CreateRoleDto)`

  * Yeni rol oluşturur (örneğin yeni bir departman rolü eklenebilir).
* `updateRole(@Param('id') id: number, @Body() dto: UpdateRoleDto)`

  * Rol adını veya izinlerini günceller.
* `deleteRole(@Param('id') id: number)`

  * Bir rolü sistemden kaldırır.
* `assignPermissions(@Param('id') id: number, @Body() dto: AssignPermissionDto)`

  * Rol için izin seti atar (örneğin “requests:approve”, “offers:view”).

---

### 3. **roles.service.ts**

Rol CRUD işlemlerini, izin atamalarını ve rol denetimlerini gerçekleştirir.

#### Fonksiyonlar:

* `findAll()`

  * Tüm rolleri döner.
* `findById(id: number)`

  * ID’ye göre rolü getirir.
* `findByName(name: string)`

  * Rol adını baz alarak getirir.
* `create(dto: CreateRoleDto)`

  * Yeni bir rol ekler.
* `update(id: number, dto: UpdateRoleDto)`

  * Mevcut rolü günceller.
* `remove(id: number)`

  * Rolü siler.
* `assignPermissions(roleId: number, permissions: string[])`

  * Rolün izin listesini günceller.
* `getPermissions(role: string)`

  * Bir rolün sahip olduğu izinleri döner.
* `hasPermission(role: string, permission: string)`

  * İlgili rolün belirtilen izne sahip olup olmadığını kontrol eder.

---

### 4. **entities/role.entity.ts**

Veritabanındaki `roles` tablosunu temsil eder.

```ts
@Entity('roles')
export class RoleEntity {
  @PrimaryGeneratedColumn() id: number;
  @Column({ unique: true }) name: string; // örn: admin, approver
  @Column('simple-array', { default: '' }) permissions: string[]; // örn: requests:view, requests:approve
  @CreateDateColumn() createdAt: Date;
  @UpdateDateColumn() updatedAt: Date;
}
```

---

### 5. **dto/**

#### a. `create-role.dto.ts`

```ts
{
  name: string;
  permissions?: string[];
}
```

#### b. `update-role.dto.ts`

```ts
{
  name?: string;
  permissions?: string[];
}
```

#### c. `assign-permission.dto.ts`

```ts
{
  permissions: string[];
}
```

---

## 🔄 **Veri Akışı**

### 1. **Rol Ekleme**

```
Admin → /roles → RolesController.createRole()
→ RolesService.create() → DB kayıt → Yeni rol döner
```

### 2. **İzin Atama**

```
Admin → /roles/:id/permissions → RolesController.assignPermissions()
→ RolesService.assignPermissions() → DB update
```

### 3. **Rol Tabanlı Yetki Kontrolü**

```
@Roles('admin', 'approver') → RolesGuard
→ RolesService.hasPermission(role, permission)
→ true/false
```

---

## ⚙️ **Kullanıldığı Modüller**

* `auth` → Role-based JWT kontrolü
* `users` → Kullanıcı rol ataması
* `requests` → Talep onay izni (`requests:approve`)
* `offers` → Teklif görüntüleme (`offers:view`)
* `reports` → Rapor izni (`reports:view`)

---

## 🔐 **Güvenlik**

* Sadece admin kullanıcı rol oluşturabilir / silebilir.
* Role-based access control (RBAC) destekli.
* Her API çağrısında token içindeki `role` claim’i kontrol edilir.
* İzinler `simple-array` formatında veritabanında saklanır.

---

## 🧱 **Ek Özellikler**

* Dinamik izin sistemi (yeni permission eklenebilir)
* İleri düzey kontrol için `permissions.guard.ts` planlanabilir
* Rol güncellemeleri anlık olarak cache’den okunabilir (`Redis` veya `In-Memory`)
* “SuperAdmin” özel rol desteği

---
