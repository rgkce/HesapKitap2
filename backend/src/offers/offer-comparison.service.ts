import { Injectable } from '@nestjs/common';
import { OfferEntity } from './entities/offer.entity';

@Injectable()
export class OfferComparisonService {

  // Fiyata göre sıralama (en ucuz üstte)
  compareByPrice(offers: OfferEntity[]) {
    return offers.sort((a, b) => a.price - b.price);
  }

  // Teslim süresine göre sıralama (en hızlı üstte)
  compareByDelivery(offers: OfferEntity[]) {
    return offers.sort((a, b) => a.deliveryDays - b.deliveryDays);
  }

  // Genel skor ile karşılaştırma
  compareByScore(offers: OfferEntity[]) {
    const scoredOffers = offers.map((offer) => {
      const score = this.calculateScore(offer);
      return { ...offer, score };
    });

    return scoredOffers.sort((a, b) => b.score - a.score);
  }

  // Teklif için skor hesaplama
  calculateScore(offer: OfferEntity): number {
    const priceWeight = 0.6;
    const deliveryWeight = 0.3;
    const qualityWeight = 0.1;

    const priceScore = 1 / offer.price;
    const deliveryScore = 1 / offer.deliveryDays;
    const qualityScore = offer.description ? 1 : 0.5;

    const totalScore =
      priceScore * priceWeight +
      deliveryScore * deliveryWeight +
      qualityScore * qualityWeight;

    return Number(totalScore.toFixed(4));
  }

  // Karşılaştırma raporu üret
  generateComparisonReport(requestId: number, offers: OfferEntity[]) {
    const comparison = this.compareByScore(offers);

    return {
      requestId,
      generatedAt: new Date(),
      bestOffer: comparison[0],
      allOffers: comparison,
    };
  }
}