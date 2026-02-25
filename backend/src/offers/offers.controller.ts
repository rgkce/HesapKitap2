import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Param,
  Body,
  Query,
  Req,
} from '@nestjs/common';

import { OffersService } from './offers.service';
import { CreateOfferDto } from './dto/create-offer.dto';
import { UpdateOfferDto } from './dto/update-offer.dto';
import { OfferFilterDto } from './dto/offer-filter.dto';

// OffersController: HTTP isteklerini karşılar ve OffersService ile iletişim kurar
@Controller('offers')
export class OffersController {
  constructor(private readonly offersService: OffersService) {}

  // 1️⃣ Tüm teklifleri listele
  // GET /offers?status=pending&supplierId=2 gibi filtreleme ile çalışabilir
  @Get()
  getAllOffers(@Query() filters: OfferFilterDto) {
    return this.offersService.findAll(filters);
  }

  // 2️⃣ Belirli bir request'e ait teklifleri getir
  // Örn: GET /offers/request/5 → requestId = 5 olan teklifleri döner
  @Get('request/:requestId')
  getOffersForRequest(@Param('requestId') id: number) {
    return this.offersService.findByRequest(id);
  }

  // 3️⃣ Yeni teklif oluşturma (Supplier tarafından)
  // POST /offers
  @Post()
  createOffer(@Body() dto: CreateOfferDto, @Req() req) {
    const supplier = req.user; // JWT ile doğrulanmış supplier bilgisi
    return this.offersService.create(dto, supplier);
  }

  // 4️⃣ Teklif güncelleme
  // PUT /offers/:id
  @Put(':id')
  updateOffer(
    @Param('id') id: number,
    @Body() dto: UpdateOfferDto,
    @Req() req,
  ) {
    const supplier = req.user; // Sadece teklif sahibi güncelleyebilir
    return this.offersService.update(id, dto, supplier);
  }

  // 5️⃣ Teklif silme
  // DELETE /offers/:id
  @Delete(':id')
  deleteOffer(@Param('id') id: number, @Req() req) {
    const supplier = req.user; // Sadece teklif sahibi silebilir
    return this.offersService.remove(id, supplier);
  }

  // 6️⃣ Teklifleri karşılaştır
  // GET /offers/compare/:requestId
  // Belirli bir talep için tüm teklifler karşılaştırılır
  @Get('compare/:requestId')
  compareOffers(@Param('requestId') id: number) {
    return this.offersService.compare(id);
  }

  // 7️⃣ Kazanan teklifi seçme (Approver tarafından)
  // POST /offers/:id/select
  // Onaylayıcı, teklif seçimini yapar ve durumu günceller
  @Post(':id/select')
  selectOffer(@Param('id') id: number, @Req() req) {
    const approver = req.user; // Onay yetkisine sahip kullanıcı
    return this.offersService.select(id, approver);
  }
}