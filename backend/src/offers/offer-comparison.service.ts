import { Injectable } from '@nestjs/common';
import { OfferEntity } from './entities/offer.entity';

// Bu servis, teklifler üzerinde karşılaştırma ve skor hesaplama işlemlerini yapar
@Injectable()
export class OfferComparisonService {

  // Teklifleri fiyata göre karşılaştırır
  // En ucuz teklif en üstte olacak şekilde sıralar
  compareByPrice(offers: OfferEntity[]) {
    return offers.sort((a, b) => a.price - b.price);
  }

  // Teklifleri teslim süresine göre karşılaştırır
  // En hızlı teslim eden teklif en üstte olacak şekilde sıralar
  compareByDelivery(offers: OfferEntity[]) {
    return offers.sort((a, b) => a.deliveryDays - b.deliveryDays);
  }

  // Teklifleri genel skora göre karşılaştırır
  // Score: fiyat, teslim süresi ve kalite kriterlerinin ağırlıklı toplamı
  compareByScore(offers: OfferEntity[]) {
    // Her teklif için skor hesapla ve obje içine ekle
    const scoredOffers = offers.map((offer) => {
      const score = this.calculateScore(offer); // Teklifin skorunu hesapla
      return { ...offer, score }; // Skoru teklif objesine ekle
    });

    // Skora göre sıralama: en yüksek skor en üstte
    return scoredOffers.sort((a, b) => b.score - a.score);
  }

  // Teklif için ağırlıklı skor hesaplama
  calculateScore(offer: OfferEntity): number {
    const priceWeight = 0.6;    // Fiyatın skor içindeki ağırlığı %60
    const deliveryWeight = 0.3; // Teslim süresinin ağırlığı %30
    const qualityWeight = 0.1;  // Kalite/description ağırlığı %10

    // Fiyat skoru: fiyat ne kadar düşükse skor o kadar yüksek
    const priceScore = 1 / offer.price;

    // Teslim skoru: teslim süresi ne kadar kısa ise skor o kadar yüksek
    const deliveryScore = 1 / offer.deliveryDays;

    // Kalite skoru: açıklama varsa 1, yoksa 0.5
    const qualityScore = offer.description ? 1 : 0.5;

    // Toplam skor = ağırlıklı toplam
    const totalScore =
      priceScore * priceWeight +
      deliveryScore * deliveryWeight +
      qualityScore * qualityWeight;

    // Skoru 4 ondalık basamakla döndür
    return Number(totalScore.toFixed(4));
  }

  // Teklif karşılaştırma raporu oluşturma
  // requestId ve tüm teklifler ile birlikte en iyi teklifi ve tüm sıralamayı döner
  generateComparisonReport(requestId: number, offers: OfferEntity[]) {
    const comparison = this.compareByScore(offers); // Skor ile sıralama yap

    return {
      requestId,             // Hangi talep için rapor
      generatedAt: new Date(), // Raporun oluşturulma zamanı
      bestOffer: comparison[0], // En yüksek skora sahip teklif
      allOffers: comparison,    // Tüm teklifler skor sırasına göre
    };
  }
}