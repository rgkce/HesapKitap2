
# **requests/**

## Paket Adı

`requests` – Satın Alma Talep Yönetim Modülü

---

## **Amaç**

Bu modül, satın alma sürecinin ilk adımı olan **talep oluşturma, güncelleme, onaylama ve durum takibini** yönetir.
Kullanıcılar (customer) talepler oluşturur, yöneticiler (approver / customer_approver) bu talepleri inceler ve onaylar.
Onaylanan talepler tedarikçilere (supplier) açılır.

---

## **Dosyalar ve Fonksiyonlar**

### 1. **requests.module.ts**

* `imports`:

  * `TypeOrmModule.forFeature([RequestEntity])`
  * `UsersModule`, `RolesModule`, `NotificationsModule`
* `controllers`: `RequestsController`
* `providers`: `RequestsService`, `RequestWorkflowService`
* 📌 *Tüm request mantığını, kullanıcı ve rol bağıyla birlikte yönetir.*

---

### 2. **requests.controller.ts**

HTTP isteklerini yönetir.
Erişim:

* `customer` → talep oluşturabilir
* `approver` / `customer_approver` → talebi onaylayabilir
* `supplier` → onaylanan talepleri görüntüleyebilir

#### Fonksiyonlar:

* `getAllRequests(@Query() filters: RequestFilterDto)`

  * Tüm talepleri (veya filtrelenmiş) listeler.
* `getMyRequests(@Req() user)`

  * Sadece giriş yapan kullanıcının oluşturduğu talepleri getirir.
* `getRequestById(@Param('id') id: number)`

  * Belirli bir talebin detayını döner.
* `createRequest(@Body() dto: CreateRequestDto, @Req() user)`

  * Yeni talep oluşturur.
* `updateRequest(@Param('id') id: number, @Body() dto: UpdateRequestDto)`

  * Talep içeriğini veya tutarını değiştirir (sadece oluşturucu yapabilir).
* `approveRequest(@Param('id') id: number, @Req() user)`

  * Talebi onaylar (sadece approver yapabilir).
* `rejectRequest(@Param('id') id: number, @Req() user, @Body() dto: RejectReasonDto)`

  * Talebi reddeder ve gerekçesini kaydeder.
* `cancelRequest(@Param('id') id: number, @Req() user)`

  * Talebi iptal eder (customer veya approver).
* `getRequestHistory(@Param('id') id: number)`

  * Talep onay geçmişini döner (workflow geçmişi).

---

### 3. **requests.service.ts**

Tüm iş mantığının (business logic) merkezi.
Veritabanı işlemlerini yürütür, e-posta / bildirim sistemini tetikler.

#### Fonksiyonlar:

* `findAll(filters: RequestFilterDto)`

  * Filtreli / sayfalı tüm talepleri getirir.
* `findById(id: number)`

  * Tek talebi döner.
* `findByUser(userId: number)`

  * Kullanıcının oluşturduğu talepleri döner.
* `create(dto: CreateRequestDto, user: UserEntity)`

  * Talep oluşturur, durum = “pending approval”.
* `update(id: number, dto: UpdateRequestDto, user: UserEntity)`

  * Talep sahibi tarafından güncellenebilir.
* `approve(id: number, approver: UserEntity)`

  * Talebi onaylar, durum “approved” olur, `RequestWorkflowService`’i tetikler.
* `reject(id: number, approver: UserEntity, reason: string)`

  * Talebi reddeder, gerekçeyi kaydeder.
* `cancel(id: number, user: UserEntity)`

  * Talebi iptal eder, durum “cancelled”.
* `getHistory(id: number)`

  * Talep geçmişini döner (`RequestWorkflowEntity` tablosundan).

---

### 4. **request-workflow.service.ts**

Talep onay sürecini (workflow) yönetir.
Onaylanma sırası, birden fazla onaycı ve loglama işlemlerini içerir.

#### Fonksiyonlar:

* `initWorkflow(requestId: number, approvers: UserEntity[])`

  * Yeni talep için onay sırası oluşturur.
* `markApproved(requestId: number, approverId: number)`

  * Belirli onaycının onayı tamamlandığında kaydeder.
* `markRejected(requestId: number, approverId: number, reason: string)`

  * Onaycı tarafından reddedilirse workflow’u sonlandırır.
* `getWorkflowStatus(requestId: number)`

  * Talebin şu an hangi aşamada olduğunu döner.
* `getApproverChain(requestId: number)`

  * Onay sürecindeki tüm kişileri listeler.

---

### 5. **entities/request.entity.ts**

```ts
@Entity('requests')
export class RequestEntity {
  @PrimaryGeneratedColumn() id: number;

  @Column() title: string;
  @Column('text') description: string;
  @Column('decimal') totalAmount: number;

  @Column({ default: 'pending' })
  status: 'pending' | 'approved' | 'rejected' | 'cancelled';

  @ManyToOne(() => UserEntity)
  createdBy: UserEntity;

  @ManyToOne(() => UserEntity, { nullable: true })
  approvedBy: UserEntity;

  @Column({ nullable: true }) rejectionReason: string;

  @CreateDateColumn() createdAt: Date;
  @UpdateDateColumn() updatedAt: Date;
}
```

---

### 6. **entities/request-workflow.entity.ts**

```ts
@Entity('request_workflows')
export class RequestWorkflowEntity {
  @PrimaryGeneratedColumn() id: number;

  @ManyToOne(() => RequestEntity)
  request: RequestEntity;

  @ManyToOne(() => UserEntity)
  approver: UserEntity;

  @Column({ default: 'pending' })
  status: 'pending' | 'approved' | 'rejected';

  @Column({ nullable: true }) reason: string;

  @CreateDateColumn() createdAt: Date;
  @UpdateDateColumn() updatedAt: Date;
}
```

---

### 7. **dto/**

#### a. `create-request.dto.ts`

```ts
{
  title: string;
  description: string;
  totalAmount: number;
  approvers: number[];
}
```

#### b. `update-request.dto.ts`

```ts
{
  title?: string;
  description?: string;
  totalAmount?: number;
}
```

#### c. `reject-reason.dto.ts`

```ts
{
  reason: string;
}
```

#### d. `request-filter.dto.ts`

```ts
{
  status?: string;
  createdBy?: number;
  dateFrom?: Date;
  dateTo?: Date;
}
```

---

## **Veri Akışı**

### 1. **Talep Oluşturma**

```
Customer → /requests (POST)
→ RequestsService.create() → DB kayıt
→ RequestWorkflowService.initWorkflow() → Onay sırası başlatılır
→ Notification gönderilir (approver’lara)
```

### 2. **Talep Onaylama**

```
Approver → /requests/:id/approve
→ RequestsService.approve()
→ Workflow güncellenir → status = approved
→ Supplier modülüne aktarılır
```

### 3. **Talep Reddetme**

```
Approver → /requests/:id/reject
→ RequestsService.reject()
→ Workflow sonlandırılır → status = rejected
→ Notification gönderilir (oluşturan kullanıcıya)
```

---

## **Kullanıldığı Modüller**

* `users` → Talebi oluşturan veya onaylayan kullanıcı
* `roles` → Onay yetkisi kontrolü (`requests:approve`)
* `notifications` → Onay ve reddetme bildirimleri
* `suppliers` → Onaylanan taleplerin tedarikçilere gönderimi

---

## **Ek Özellikler**

* Çok kademeli onay desteği (multi-approver chain)
* İptal edilen taleplerin yeniden açılması
* PDF / Excel export
* Anlık durum değişiklikleri (WebSocket / SSE)
* Talep durumu bazlı raporlama (grafiklerle)

