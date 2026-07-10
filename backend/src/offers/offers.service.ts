import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { OfferEntity } from './entities/offer.entity'; // Teklif entity'si
import { RequestEntity } from '../requests/entities/request.entity'; // Talep entity'si
import { User } from '../users/entities/user.entity'; // Kullanıcı entity'si

import { CreateOfferDto } from './dto/create-offer.dto'; // Teklif oluşturma DTO'su
import { UpdateOfferDto } from './dto/update-offer.dto'; // Teklif güncelleme DTO'su
import { OfferFilterDto } from './dto/offer-filter.dto'; // Teklif filtreleme DTO'su

import { OfferComparisonService } from './offer-comparison.service'; // Teklif karşılaştırma servisi
import { NotificationsService } from '../notifications/notifications.service'; // Bildirim servisi

@Injectable()
// OffersService: Tekliflerin iş mantığını yönetir (CRUD, seçim, karşılaştırma)
export class OffersService {
  constructor(
    @InjectRepository(OfferEntity)
    private readonly offerRepository: Repository<OfferEntity>, // Teklifler için DB repository

    @InjectRepository(RequestEntity)
    private readonly requestRepository: Repository<RequestEntity>, // Talepler için DB repository

    private readonly comparisonService: OfferComparisonService, // Teklif karşılaştırma servisi
    private readonly notificationsService: NotificationsService, // Bildirim servisi
  ) {}

  // Tüm teklifleri filtreli şekilde getir
  async findAll(filters: OfferFilterDto) {
    const query = this.offerRepository.createQueryBuilder('offer')
      .leftJoinAndSelect('offer.request', 'request') // Teklifin talep ilişkisini ekle
      .leftJoinAndSelect('offer.supplier', 'supplier'); // Teklifin supplier ilişkisini ekle

    if (filters.supplierId) {
      query.andWhere('supplier.id = :supplierId', { supplierId: filters.supplierId });
    }

    if (filters.requestId) {
      query.andWhere('request.id = :requestId', { requestId: filters.requestId });
    }

    if (filters.status) {
      query.andWhere('offer.status = :status', { status: filters.status });
    }

    return query.getMany(); // Filtrelenmiş teklifleri döndür
  }

  // Belirli bir request'e ait tüm teklifleri getir
  async findByRequest(requestId: number) {
    return this.offerRepository.find({
      where: { request: { id: requestId } }, // requestId ile filtrele
      relations: ['supplier'], // Supplier ilişkisini ekle
    });
  }

  // Yeni teklif oluştur (supplier tarafından)
  async create(dto: CreateOfferDto, supplier: User) {
    // Teklifin ait olduğu talebi bul
    const request = await this.requestRepository.findOne({
      where: { id: dto.requestId },
    });

    if (!request) throw new NotFoundException('Request not found'); // Talep yoksa hata

    // Yeni teklif entity'si oluştur
    const offer = this.offerRepository.create({
      request,
      supplier,
      price: dto.price,
      currency: dto.currency,
      deliveryDays: dto.deliveryDays,
      description: dto.description,
      status: 'pending', // Yeni teklifler varsayılan olarak pending
    });

    const savedOffer = await this.offerRepository.save(offer); // Teklifi DB'ye kaydet

    // Onaylayıcıya bildirim gönder
    await this.notificationsService.notifyApprover(
      request.id,
      'New offer submitted',
    );

    return savedOffer; // Kaydedilen teklifi döndür
  }

  // Teklif güncelle
  async update(id: number, dto: UpdateOfferDto, supplier: User) {
    const offer = await this.offerRepository.findOne({
      where: { id },
      relations: ['supplier'], // Supplier ilişkisini al
    });

    if (!offer) throw new NotFoundException('Offer not found'); // Teklif yoksa hata

    if (offer.supplier.id !== supplier.id) {
      throw new ForbiddenException('You can update only your own offer'); // Sadece sahibi güncelleyebilir
    }

    Object.assign(offer, dto); // DTO alanlarını offer'a ata
    return this.offerRepository.save(offer); // Güncellenmiş teklifi kaydet
  }

  // Teklif silme
  async remove(id: number, supplier: User) {
    const offer = await this.offerRepository.findOne({
      where: { id },
      relations: ['supplier'],
    });

    if (!offer) throw new NotFoundException('Offer not found'); // Teklif yoksa hata

    if (offer.supplier.id !== supplier.id) {
      throw new ForbiddenException('You can delete only your own offer'); // Sadece sahibi silebilir
    }

    return this.offerRepository.remove(offer); // Teklifi DB'den sil
  }

  // Kazanan teklifi seç (approver tarafından)
  async select(id: number, approver: User) {
    const offer = await this.offerRepository.findOne({
      where: { id },
      relations: ['request', 'supplier'], // Teklifin talep ve supplier ilişkisini al
    });

    if (!offer) throw new NotFoundException('Offer not found'); // Teklif yoksa hata

    offer.status = 'accepted'; // Teklifi kabul et
    await this.offerRepository.save(offer); // Güncelle

    // Talep durumunu "offer_selected" olarak güncelle
    await this.requestRepository.update(offer.request.id, {
      status: 'offer_selected',
    });

    // Supplier'a bildirim gönder
    await this.notificationsService.notifySupplier(
      offer.supplier.id,
      'Your offer has been selected',
    );

    return offer; // Seçilen teklifi döndür
  }

  // Teklifleri skor bazlı karşılaştır
  async compare(requestId: number) {
    const offers = await this.findByRequest(requestId); // Request'e ait teklifler
    return this.comparisonService.compareByScore(offers); // Skora göre sırala ve döndür
  }
}