
# **notifications/**

## 📦 Paket Adı

`notifications` – Sistem Bildirim Yönetim Modülü

---

## 🎯 **Amaç**

Kullanıcılara sistem olayları hakkında bilgilendirme yapmak:

* Yeni talep oluşturuldu
* Talep onaylandı veya reddedildi
* Yeni teklif geldi
* Teklif seçildi veya reddedildi
* Sistem güncellemeleri

Bu modül hem **gerçek zamanlı (in-app)** hem de **asenkron e-posta bildirimlerini** destekler.

---

## 📁 **Dosyalar ve Fonksiyonlar**

### 1. **notifications.module.ts**

* `imports`:

  * `TypeOrmModule.forFeature([NotificationEntity])`
  * `UsersModule`, `MailerModule`, `SocketModule`
* `controllers`: `NotificationsController`
* `providers`: `NotificationsService`, `NotificationGateway`, `EmailService`

📌 *Bildirim gönderimi, saklanması ve iletilmesini organize eder.*

---

### 2. **notifications.controller.ts**

Kullanıcılara ait bildirimlerin görüntülenmesi ve yönetimi için API sağlar.

#### Fonksiyonlar:

* `getUserNotifications(@Req() user)`

  * Kullanıcının bildirim geçmişini getirir.
* `markAsRead(@Param('id') id: number, @Req() user)`

  * Belirli bildirimi okundu olarak işaretler.
* `deleteNotification(@Param('id') id: number, @Req() user)`

  * Kullanıcı bildirimi siler.
* `clearAll(@Req() user)`

  * Tüm bildirimleri temizler.
* `testSend(@Body() dto: TestNotificationDto)`

  * Test amaçlı bildirim gönderimi (admin only).

---

### 3. **notifications.service.ts**

Bildirimlerin oluşturulması, kaydedilmesi ve uygun kanallara gönderilmesini yönetir.

#### Fonksiyonlar:

* `createNotification(dto: CreateNotificationDto)`

  * Yeni bildirim oluşturur ve DB’ye kaydeder.
* `sendInAppNotification(notification: NotificationEntity)`

  * WebSocket üzerinden gerçek zamanlı bildirim yollar.
* `sendEmailNotification(notification: NotificationEntity)`

  * E-posta ile bildirim gönderir (async task).
* `notifyUser(userId: number, dto: CreateNotificationDto)`

  * Hem e-posta hem in-app bildirimi tek fonksiyonla tetikler.
* `getUserNotifications(userId: number)`

  * Kullanıcının tüm bildirimlerini döner.
* `markAsRead(id: number, userId: number)`

  * Bildirimi okundu olarak günceller.
* `delete(id: number, userId: number)`

  * Bildirimi siler.

---

### 4. **notification.gateway.ts**

Gerçek zamanlı (WebSocket) bildirim iletimi için gateway.

#### Fonksiyonlar:

* `handleConnection(client: Socket)`

  * Kullanıcı bağlantısını yönetir.
* `handleDisconnect(client: Socket)`

  * Kullanıcı bağlantısını sonlandırır.
* `sendNotificationToUser(userId: number, data: any)`

  * Belirli kullanıcıya bildirim gönderir.
* `broadcastToRole(role: string, data: any)`

  * Belirli role sahip tüm kullanıcılara mesaj yollar (örneğin adminlere uyarı).

---

### 5. **email.service.ts**

E-posta bildirimlerinin gönderimini yönetir.
NestJS `@nestjs-modules/mailer` modülünü kullanır.

#### Fonksiyonlar:

* `sendMail(to: string, subject: string, template: string, context: any)`

  * E-posta gönderimi.
* `sendNotificationEmail(user: UserEntity, message: string)`

  * Bildirim türü e-postası yollar.
* `sendBulkEmails(recipients: string[], subject: string, template: string)`

  * Toplu e-posta gönderimi.
* `buildTemplate(templateName: string, context: any)`

  * E-posta şablonunu hazırlar.

---

### 6. **entities/notification.entity.ts**

```ts
@Entity('notifications')
export class NotificationEntity {
  @PrimaryGeneratedColumn() id: number;

  @ManyToOne(() => UserEntity)
  user: UserEntity;

  @Column() title: string;
  @Column('text') message: string;

  @Column({ default: 'info' })
  type: 'info' | 'success' | 'warning' | 'error';

  @Column({ default: false })
  read: boolean;

  @Column({ nullable: true })
  link: string;

  @Column({ default: 'in_app' })
  channel: 'in_app' | 'email' | 'both';

  @CreateDateColumn() createdAt: Date;
}
```

---

### 7. **dto/**

#### a. `create-notification.dto.ts`

```ts
{
  userId: number;
  title: string;
  message: string;
  type?: 'info' | 'success' | 'warning' | 'error';
  link?: string;
  channel?: 'in_app' | 'email' | 'both';
}
```

#### b. `test-notification.dto.ts`

```ts
{
  userId?: number;
  title: string;
  message: string;
}
```

---

## 🔄 **Veri Akışı**

### 1. **Olay Gerçekleşir**

Örneğin, `OfferService.select()` fonksiyonu çalışır.

```ts
notificationsService.notifyUser(
  supplierId,
  {
    title: 'Teklifiniz seçildi 🎉',
    message: 'Tebrikler! Teklifiniz onaylandı.',
    type: 'success',
    channel: 'both',
  }
);
```

### 2. **Notification Kaydı**

* DB’ye kaydedilir
* SocketGateway üzerinden client’a gönderilir
* EmailService ile e-posta gönderilir

### 3. **Kullanıcı Görür**

* Uygulama içi bildirimi alır
* E-posta kutusuna düşer
* Okununca `read = true` yapılır

---

## ⚙️ **Kullanıldığı Modüller**

* `offers`, `requests` → Olay bazlı bildirim üretir
* `auth` → Şifre sıfırlama, hesap oluşturma bildirimi
* `users` → Rol değişikliği bildirimi
* `admin` → Sistem raporu/uyarı bildirimleri

---

## 💡 **Ek Özellikler**

* Bildirim şablonları (`templates/notification-email.hbs`)
* Çoklu dil desteği (i18n)
* Bildirim gruplama (“5 yeni teklif geldi”)
* Zamanlanmış bildirimler (cron jobs)
* Firebase Push Notification desteği (mobil cihazlar için)

---
