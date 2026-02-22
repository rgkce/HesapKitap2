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

@Controller('offers')
export class OffersController {
  constructor(private readonly offersService: OffersService) {}

  // 1. Tüm teklifleri listele
  @Get()
  getAllOffers(@Query() filters: OfferFilterDto) {
    return this.offersService.findAll(filters);
  }

  // 2. Bir request'e ait teklifler
  @Get('request/:requestId')
  getOffersForRequest(@Param('requestId') id: number) {
    return this.offersService.findByRequest(id);
  }

  // 3. Yeni teklif oluştur (supplier)
  @Post()
  createOffer(@Body() dto: CreateOfferDto, @Req() req) {
    const supplier = req.user;
    return this.offersService.create(dto, supplier);
  }

  // 4. Teklif güncelle
  @Put(':id')
  updateOffer(
    @Param('id') id: number,
    @Body() dto: UpdateOfferDto,
    @Req() req,
  ) {
    const supplier = req.user;
    return this.offersService.update(id, dto, supplier);
  }

  // 5. Teklif sil
  @Delete(':id')
  deleteOffer(@Param('id') id: number, @Req() req) {
    const supplier = req.user;
    return this.offersService.remove(id, supplier);
  }

  // 6. Teklifleri karşılaştır
  @Get('compare/:requestId')
  compareOffers(@Param('requestId') id: number) {
    return this.offersService.compare(id);
  }

  // 7. Kazanan teklifi seç (approver)
  @Post(':id/select')
  selectOffer(@Param('id') id: number, @Req() req) {
    const approver = req.user;
    return this.offersService.select(id, approver);
  }
}