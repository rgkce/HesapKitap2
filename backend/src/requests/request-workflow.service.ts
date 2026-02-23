import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { RequestWorkflowEntity } from './entities/request-workflow.entity';
import { RequestEntity } from './entities/request.entity';
import { UserEntity } from '../users/entities/user.entity';

@Injectable()
export class RequestWorkflowService {
  constructor(
    @InjectRepository(RequestWorkflowEntity)
    private readonly workflowRepository: Repository<RequestWorkflowEntity>,

    @InjectRepository(RequestEntity)
    private readonly requestRepository: Repository<RequestEntity>,
  ) {}

  async initWorkflow(requestId: number, approvers: UserEntity[] | number[]) {
    const request = await this.requestRepository.findOne({
      where: { id: requestId },
    });

    if (!request) throw new NotFoundException('Request not found');

    for (const approver of approvers) {
      const workflow = this.workflowRepository.create({
        request,
        approver: typeof approver === 'number' ? ({ id: approver } as UserEntity) : approver,
        status: 'pending',
      });

      await this.workflowRepository.save(workflow);
    }

    return true;
  }

  async markApproved(requestId: number, approverId: number) {
    const workflow = await this.workflowRepository.findOne({
      where: {
        request: { id: requestId },
        approver: { id: approverId },
      },
      relations: ['request', 'approver'],
    });

    if (!workflow) throw new NotFoundException('Workflow record not found');
    if (workflow.status !== 'pending') {
      throw new ForbiddenException('This approver already processed this request');
    }

    workflow.status = 'approved';
    return this.workflowRepository.save(workflow);
  }

  async markRejected(requestId: number, approverId: number, reason: string) {
    const workflow = await this.workflowRepository.findOne({
      where: {
        request: { id: requestId },
        approver: { id: approverId },
      },
      relations: ['request', 'approver'],
    });

    if (!workflow) throw new NotFoundException('Workflow record not found');

    workflow.status = 'rejected';
    workflow.reason = reason;

    return this.workflowRepository.save(workflow);
  }

  async getWorkflowStatus(requestId: number) {
    const workflows = await this.workflowRepository.find({
      where: { request: { id: requestId } },
      relations: ['approver'],
      order: { createdAt: 'ASC' },
    });

    if (!workflows.length) {
      throw new NotFoundException('No workflow found for this request');
    }

    const approvedCount = workflows.filter(w => w.status === 'approved').length;
    const rejected = workflows.find(w => w.status === 'rejected');

    if (rejected) {
      return { status: 'rejected', rejectedBy: rejected.approver };
    }

    if (approvedCount === workflows.length) {
      return { status: 'approved' };
    }

    return {
      status: 'pending',
      currentStep: approvedCount + 1,
      totalSteps: workflows.length,
    };
  }

  async getApproverChain(requestId: number) {
    return this.workflowRepository.find({
      where: { request: { id: requestId } },
      relations: ['approver'],
      order: { createdAt: 'ASC' },
    });
  }
}