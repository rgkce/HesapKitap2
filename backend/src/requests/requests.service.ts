import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { RequestEntity } from './entities/request.entity';
import { RequestWorkflowEntity } from './entities/request-workflow.entity';

import { CreateRequestDto } from './dto/create-request.dto';
import { UpdateRequestDto } from './dto/update-request.dto';
import { RequestFilterDto } from './dto/request-filter.dto';

import { UserEntity } from '../users/entities/user.entity';

import { RequestWorkflowService } from './request-workflow.service';
import { NotificationsService } from '../notifications/notifications.service';

@Injectable()
export class RequestsService {
  constructor(
    @InjectRepository(RequestEntity)
    private readonly requestRepository: Repository<RequestEntity>,

    @InjectRepository(RequestWorkflowEntity)
    private readonly workflowRepository: Repository<RequestWorkflowEntity>,

    private readonly workflowService: RequestWorkflowService,
    private readonly notificationsService: NotificationsService,
  ) {}

  async findAll(filters: RequestFilterDto) {
    const query = this.requestRepository.createQueryBuilder('request')
      .leftJoinAndSelect('request.createdBy', 'createdBy')
      .leftJoinAndSelect('request.approvedBy', 'approvedBy');

    if (filters.status) {
      query.andWhere('request.status = :status', { status: filters.status });
    }

    if (filters.createdBy) {
      query.andWhere('createdBy.id = :createdBy', { createdBy: filters.createdBy });
    }

    if (filters.dateFrom) {
      query.andWhere('request.createdAt >= :dateFrom', { dateFrom: filters.dateFrom });
    }

    if (filters.dateTo) {
      query.andWhere('request.createdAt <= :dateTo', { dateTo: filters.dateTo });
    }

    return query.getMany();
  }

  async findById(id: number) {
    const request = await this.requestRepository.findOne({
      where: { id },
      relations: ['createdBy', 'approvedBy'],
    });

    if (!request) throw new NotFoundException('Request not found');
    return request;
  }

  async findByUser(userId: number) {
    return this.requestRepository.find({
      where: { createdBy: { id: userId } },
      relations: ['createdBy', 'approvedBy'],
    });
  }

  async create(dto: CreateRequestDto, user: UserEntity) {
    const request = this.requestRepository.create({
      title: dto.title,
      description: dto.description,
      totalAmount: dto.totalAmount,
      status: 'pending',
      createdBy: user,
    });

    const savedRequest = await this.requestRepository.save(request);

    await this.workflowService.initWorkflow(savedRequest.id, dto.approvers);
    await this.notificationsService.notifyApprovers(dto.approvers, savedRequest.id);

    return savedRequest;
  }

  async update(id: number, dto: UpdateRequestDto, user: UserEntity) {
    const request = await this.findById(id);

    if (request.createdBy.id !== user.id) {
      throw new ForbiddenException('You can only update your own request');
    }

    Object.assign(request, dto);
    return this.requestRepository.save(request);
  }

  async approve(id: number, approver: UserEntity) {
    const request = await this.findById(id);

    if (request.status !== 'pending') {
      throw new ForbiddenException('Request is not pending');
    }

    await this.workflowService.markApproved(id, approver.id);

    request.status = 'approved';
    request.approvedBy = approver;

    const saved = await this.requestRepository.save(request);

    await this.notificationsService.notifyUser(
      request.createdBy.id,
      `Your request #${request.id} has been approved`,
    );

    return saved;
  }

  async reject(id: number, approver: UserEntity, reason: string) {
    const request = await this.findById(id);

    if (request.status !== 'pending') {
      throw new ForbiddenException('Request is not pending');
    }

    await this.workflowService.markRejected(id, approver.id, reason);

    request.status = 'rejected';
    request.rejectionReason = reason;
    request.approvedBy = approver;

    const saved = await this.requestRepository.save(request);

    await this.notificationsService.notifyUser(
      request.createdBy.id,
      `Your request #${request.id} was rejected. Reason: ${reason}`,
    );

    return saved;
  }

  async cancel(id: number, user: UserEntity) {
    const request = await this.findById(id);

    if (request.createdBy.id !== user.id && user.role !== 'approver') {
      throw new ForbiddenException('You cannot cancel this request');
    }

    request.status = 'cancelled';
    return this.requestRepository.save(request);
  }

  async getHistory(id: number) {
    return this.workflowRepository.find({
      where: { request: { id } },
      relations: ['approver'],
      order: { createdAt: 'ASC' },
    });
  }
}