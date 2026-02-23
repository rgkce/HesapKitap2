import {
  Controller,
  Get,
  Post,
  Patch,
  Param,
  Body,
  Query,
  Req,
  UseGuards,
} from '@nestjs/common';

import { RequestsService } from './requests.service';

import { CreateRequestDto } from './dto/create-request.dto';
import { UpdateRequestDto } from './dto/update-request.dto';
import { RejectReasonDto } from './dto/reject-reason.dto';
import { RequestFilterDto } from './dto/request-filter.dto';

import { AuthGuard } from '../auth/auth.guard';
import { RolesGuard } from '../roles/roles.guard';
import { Roles } from '../roles/roles.decorator';

@Controller('requests')
@UseGuards(AuthGuard, RolesGuard)
export class RequestsController {
  constructor(private readonly requestsService: RequestsService) {}

  @Get()
  @Roles('approver', 'customer_approver', 'supplier')
  getAllRequests(@Query() filters: RequestFilterDto) {
    return this.requestsService.findAll(filters);
  }

  @Get('my')
  @Roles('customer')
  getMyRequests(@Req() req) {
    return this.requestsService.findByUser(req.user.id);
  }

  @Get(':id')
  @Roles('customer', 'approver', 'customer_approver', 'supplier')
  getRequestById(@Param('id') id: number) {
    return this.requestsService.findById(Number(id));
  }

  @Post()
  @Roles('customer')
  createRequest(@Body() dto: CreateRequestDto, @Req() req) {
    return this.requestsService.create(dto, req.user);
  }

  @Patch(':id')
  @Roles('customer')
  updateRequest(
    @Param('id') id: number,
    @Body() dto: UpdateRequestDto,
    @Req() req,
  ) {
    return this.requestsService.update(Number(id), dto, req.user);
  }

  @Post(':id/approve')
  @Roles('approver', 'customer_approver')
  approveRequest(@Param('id') id: number, @Req() req) {
    return this.requestsService.approve(Number(id), req.user);
  }

  @Post(':id/reject')
  @Roles('approver', 'customer_approver')
  rejectRequest(
    @Param('id') id: number,
    @Req() req,
    @Body() dto: RejectReasonDto,
  ) {
    return this.requestsService.reject(Number(id), req.user, dto.reason);
  }

  @Post(':id/cancel')
  @Roles('customer', 'approver', 'customer_approver')
  cancelRequest(@Param('id') id: number, @Req() req) {
    return this.requestsService.cancel(Number(id), req.user);
  }

  @Get(':id/history')
  @Roles('customer', 'approver', 'customer_approver')
  getRequestHistory(@Param('id') id: number) {
    return this.requestsService.getHistory(Number(id));
  }
}