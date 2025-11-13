
# **offers/**

## 📦 Paket Adı

`offers` – Tedarikçi Teklif Yönetim Modülü

---

## 🎯 **Amaç**

Bu modül, onaylanmış satın alma taleplerinin tedarikçilere iletilmesini ve tedarikçilerin bu taleplere verdikleri tekliflerin toplanmasını sağlar.
Tedarikçiler (supplier) fiyat, teslim süresi ve açıklama belirterek teklif sunar.
Onaylayıcılar veya satın alma yetkilileri (approver) teklifleri karşılaştırarak birini seçebilir.

---

## 📁 **Dosyalar ve Fonksiyonlar**

### 1. **offers.module.ts**

* `imports`:

  * `TypeOrmModule.forFeature([OfferEntity, RequestEntity])`
  * `RequestsModule`, `SuppliersModule`, `NotificationsModule`
* `controllers`: `OffersController`
* `providers`: `OffersService`, `OfferComparisonService`
* 📌 *Teklifleri yönetir, karşılaştırma ve seçme işlevlerini sağlar.*

---

### 2. **offers.controller.ts**

Tedarikçi teklif işlemlerini HTTP üzerinden yönetir.

#### Fonksiyonlar:

* `getAllOffers(@Query() filters: OfferFilterDto)`

  * Tüm teklifleri listeler (filtrelenebilir).
* `getOffersForRequest(@Param('requestId') id: number)`

  * Belirli bir talep için gelen teklifleri döner.
* `createOffer(@Body() dto: CreateOfferDto, @Req() supplier)`

  * Tedarikçi yeni teklif oluşturur.
* `updateOffer(@Param('id') id: number, @Body() dto: UpdateOfferDto, @Req() supplier)`

  * Teklif güncellemesi (sadece oluşturucu supplier yapabilir).
* `deleteOffer(@Param('id') id: number, @Req() supplier)`

  * Teklifi siler.
* `compareOffers(@Param('requestId') id: number)`

  * Belirli talep için gelen teklifleri fiyat, teslim süresi vb. kriterlere göre karşılaştırır.
* `selectOffer(@Param('id') id: number, @Req() approver)`

  * Kazanan teklifi seçer (sadece approver yapabilir).

---

### 3. **offers.service.ts**

Tekliflerin oluşturulması, güncellenmesi ve seçim süreçlerini yönetir.
Ayrıca karşılaştırma servisini tetikler.

#### Fonksiyonlar:

* `findAll(filters: OfferFilterDto)`

  * Filtreli tüm teklifleri getirir.
* `findById(id: number)`

  * Tek bir teklifi döner.
* `findByRequest(requestId: number)`

  * Belirli bir talebe ait tüm teklifleri getirir.
* `create(dto: CreateOfferDto, supplier: UserEntity)`

  * Yeni teklif oluşturur.
* `update(id: number, dto: UpdateOfferDto, supplier: UserEntity)`

  * Teklif güncellenir.
* `remove(id: number, supplier: UserEntity)`

  * Teklif silinir.
* `select(id: number, approver: UserEntity)`

  * Kazanan teklifi seçer ve talep durumunu “offer_selected” olarak günceller.
* `notifySelection(requestId: number, offerId: number)`

  * Kazanan tedarikçiye bildirim gönderir.

---

### 4. **offer-comparison.service.ts**

Teklifleri belirli kriterlere göre karşılaştırır ve puanlama yapar.

#### Fonksiyonlar:

* `compareByPrice(offers: OfferEntity[])`

  * Fiyat bazlı sıralama döner.
* `compareByDelivery(offers: OfferEntity[])`

  * Teslim süresine göre sıralar.
* `compareByScore(offers: OfferEntity[])`

  * Fiyat, teslim süresi ve kalite puanlarını kombine ederek en uygun teklifi belirler.
* `calculateScore(offer: OfferEntity)`

  * Her teklif için ağırlıklı skor hesaplar (örnek: fiyat %60, teslim süresi %30, kalite %10).
* `generateComparisonReport(requestId: number)`

  * PDF/JSON formatında karşılaştırma raporu döner.

---

### 5. **entities/offer.entity.ts**

```ts
@Entity('offers')
export class OfferEntity {
  @PrimaryGeneratedColumn() id: number;

  @ManyToOne(() => RequestEntity)
  request: RequestEntity;

  @ManyToOne(() => UserEntity)
  supplier: UserEntity;

  @Column('decimal') price: number;
  @Column() currency: string;
  @Column('int') deliveryDays: number;
  @Column('text', { nullable: true }) description: string;

  @Column({ default: 'pending' })
  status: 'pending' | 'accepted' | 'rejected';

  @Column({ nullable: true }) score: number;

  @CreateDateColumn() createdAt: Date;
  @UpdateDateColumn() updatedAt: Date;
}
```

---

### 6. **dto/**

#### a. `create-offer.dto.ts`

```ts
{
  requestId: number;
  price: number;
  currency: string;
  deliveryDays: number;
  description?: string;
}
```

#### b. `update-offer.dto.ts`

```ts
{
  price?: number;
  deliveryDays?: number;
  description?: string;
}
```

#### c. `offer-filter.dto.ts`

```ts
{
  supplierId?: number;
  requestId?: number;
  status?: string;
}
```

---

## 🔄 **Veri Akışı**

### 1. **Onaylanan Talep → Tedarikçilere Açılır**

```
RequestsService.approve()
→ OffersModule’a event gönderilir
→ İlgili tedarikçiler bilgilendirilir
```

### 2. **Tedarikçi Teklif Gönderir**

```
Supplier → /offers (POST)
→ OffersService.create()
→ DB kayıt → Notification to approver
```

### 3. **Teklif Seçimi**

```
Approver → /offers/:id/select
→ OffersService.select()
→ Request.status = 'offer_selected'
→ Notification to supplier
```

---

## ⚙️ **Kullanıldığı Modüller**

* `requests` → Tekliflerin bağlı olduğu talepler
* `users` → Tedarikçi ve onaylayıcı bilgileri
* `notifications` → Teklif sonucu bildirimi
* `roles` → Teklif seçme yetkisi kontrolü (`offers:select`)

---

## 🧱 **Ek Özellikler**

* Teklif karşılaştırma raporu (PDF/Excel)
* Otomatik kazanan belirleme (AI tabanlı puanlama ileride)
* Fiyat değişim geçmişi
* Çoklu para birimi desteği
* Dinamik kriter ağırlıkları (örneğin teslimat önemine göre skor ayarı)

