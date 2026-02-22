import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { OfferEntity } from './entities/offer.entity';
import { RequestEntity } from '../requests/entities/request.entity';
import { UserEntity } from '../users/entities/user.entity';

import { CreateOfferDto } from './dto/create-offer.dto';
import { UpdateOfferDto } from './dto/update-offer.dto';
import { OfferFilterDto } from './dto/offer-filter.dto';

import { OfferComparisonService } from './offer-comparison.service';
import { NotificationsService } from '../notifications/notifications.service';

@Injectable()
export class OffersService {
  constructor(
    @InjectRepository(OfferEntity)
    private readonly offerRepository: Repository<OfferEntity>,

    @InjectRepository(RequestEntity)
    private readonly requestRepository: Repository<RequestEntity>,

    private readonly comparisonService: OfferComparisonService,
    private readonly notificationsService: NotificationsService,
  ) {}

  async findAll(filters: OfferFilterDto) {
    const query = this.offerRepository.createQueryBuilder('offer')
      .leftJoinAndSelect('offer.request', 'request')
      .leftJoinAndSelect('offer.supplier', 'supplier');

    if (filters.supplierId) {
      query.andWhere('supplier.id = :supplierId', { supplierId: filters.supplierId });
    }

    if (filters.requestId) {
      query.andWhere('request.id = :requestId', { requestId: filters.requestId });
    }

    if (filters.status) {
      query.andWhere('offer.status = :status', { status: filters.status });
    }

    return query.getMany();
  }

  async findByRequest(requestId: number) {
    return this.offerRepository.find({
      where: { request: { id: requestId } },
      relations: ['supplier'],
    });
  }

  async create(dto: CreateOfferDto, supplier: UserEntity) {
    const request = await this.requestRepository.findOne({
      where: { id: dto.requestId },
    });

    if (!request) throw new NotFoundException('Request not found');

    const offer = this.offerRepository.create({
      request,
      supplier,
      price: dto.price,
      currency: dto.currency,
      deliveryDays: dto.deliveryDays,
      description: dto.description,
      status: 'pending',
    });

    const savedOffer = await this.offerRepository.save(offer);

    await this.notificationsService.notifyApprover(
      request.id,
      'New offer submitted',
    );

    return savedOffer;
  }

  async update(id: number, dto: UpdateOfferDto, supplier: UserEntity) {
    const offer = await this.offerRepository.findOne({
      where: { id },
      relations: ['supplier'],
    });

    if (!offer) throw new NotFoundException('Offer not found');

    if (offer.supplier.id !== supplier.id) {
      throw new ForbiddenException('You can update only your own offer');
    }

    Object.assign(offer, dto);
    return this.offerRepository.save(offer);
  }

  async remove(id: number, supplier: UserEntity) {
    const offer = await this.offerRepository.findOne({
      where: { id },
      relations: ['supplier'],
    });

    if (!offer) throw new NotFoundException('Offer not found');

    if (offer.supplier.id !== supplier.id) {
      throw new ForbiddenException('You can delete only your own offer');
    }

    return this.offerRepository.remove(offer);
  }

  async select(id: number, approver: UserEntity) {
    const offer = await this.offerRepository.findOne({
      where: { id },
      relations: ['request', 'supplier'],
    });

    if (!offer) throw new NotFoundException('Offer not found');

    offer.status = 'accepted';
    await this.offerRepository.save(offer);

    await this.requestRepository.update(offer.request.id, {
      status: 'offer_selected',
    });

    await this.notificationsService.notifySupplier(
      offer.supplier.id,
      'Your offer has been selected',
    );

    return offer;
  }

  async compare(requestId: number) {
    const offers = await this.findByRequest(requestId);
    return this.comparisonService.compareByScore(offers);
  }
}