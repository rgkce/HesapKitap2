import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { RequestWorkflowEntity } from './entities/request-workflow.entity';
import { RequestEntity } from './entities/request.entity';
import { UserEntity } from '../users/entities/user.entity';

@Injectable()
export class RequestWorkflowService {
  constructor(
    // RequestWorkflowEntity repository'sini inject ediyoruz
    @InjectRepository(RequestWorkflowEntity)
    private readonly workflowRepository: Repository<RequestWorkflowEntity>,

    // RequestEntity repository'sini inject ediyoruz
    @InjectRepository(RequestEntity)
    private readonly requestRepository: Repository<RequestEntity>,
  ) {}

  /**
   * Yeni bir workflow başlatır (talep için onay sırası oluşturur)
   * @param requestId Talep ID'si
   * @param approvers Onaycılar (UserEntity dizisi veya ID dizisi)
   */
  async initWorkflow(requestId: number, approvers: UserEntity[] | number[]) {
    // Talebi veritabanından bul
    const request = await this.requestRepository.findOne({
      where: { id: requestId },
    });

    // Eğer talep bulunamazsa hata fırlat
    if (!request) throw new NotFoundException('Request not found');

    // Tüm onaycılar için workflow kaydı oluştur
    for (const approver of approvers) {
      const workflow = this.workflowRepository.create({
        request,
        // approver bir sayı ise UserEntity tipine cast et
        approver: typeof approver === 'number' ? ({ id: approver } as UserEntity) : approver,
        status: 'pending', // Başlangıç durumu pending
      });

      // Workflow kaydını veritabanına kaydet
      await this.workflowRepository.save(workflow);
    }

    return true; // Başarıyla tamamlandı
  }

  /**
   * Talebi onaylar (belirli onaycı için)
   * @param requestId Talep ID'si
   * @param approverId Onaycı ID'si
   */
  async markApproved(requestId: number, approverId: number) {
    // İlgili workflow kaydını bul
    const workflow = await this.workflowRepository.findOne({
      where: {
        request: { id: requestId },
        approver: { id: approverId },
      },
      relations: ['request', 'approver'], // ilişkili talep ve onaycıyı getir
    });

    // Workflow kaydı yoksa hata fırlat
    if (!workflow) throw new NotFoundException('Workflow record not found');

    // Eğer zaten işlenmişse onay veya reddedilmişse hata ver
    if (workflow.status !== 'pending') {
      throw new ForbiddenException('This approver already processed this request');
    }

    workflow.status = 'approved'; // Durumu approved olarak değiştir
    return this.workflowRepository.save(workflow); // Kaydet ve döndür
  }

  /**
   * Talebi reddeder (belirli onaycı için)
   * @param requestId Talep ID'si
   * @param approverId Onaycı ID'si
   * @param reason Reddetme nedeni
   */
  async markRejected(requestId: number, approverId: number, reason: string) {
    // İlgili workflow kaydını bul
    const workflow = await this.workflowRepository.findOne({
      where: {
        request: { id: requestId },
        approver: { id: approverId },
      },
      relations: ['request', 'approver'],
    });

    // Workflow kaydı yoksa hata fırlat
    if (!workflow) throw new NotFoundException('Workflow record not found');

    workflow.status = 'rejected'; // Durumu rejected olarak değiştir
    workflow.reason = reason; // Reddetme sebebini kaydet

    return this.workflowRepository.save(workflow); // Kaydet ve döndür
  }

  /**
   * Talebin mevcut workflow durumunu döner
   * @param requestId Talep ID'si
   */
  async getWorkflowStatus(requestId: number) {
    // Talebe ait tüm workflow kayıtlarını getir (oluşturulma sırasına göre)
    const workflows = await this.workflowRepository.find({
      where: { request: { id: requestId } },
      relations: ['approver'],
      order: { createdAt: 'ASC' },
    });

    // Eğer workflow yoksa hata fırlat
    if (!workflows.length) {
      throw new NotFoundException('No workflow found for this request');
    }

    // Kaç onay tamamlanmış
    const approvedCount = workflows.filter(w => w.status === 'approved').length;

    // Eğer herhangi biri reddetmişse
    const rejected = workflows.find(w => w.status === 'rejected');

    if (rejected) {
      // Talep reddedilmiş olarak dön
      return { status: 'rejected', rejectedBy: rejected.approver };
    }

    // Eğer tüm onaycılar onayladıysa
    if (approvedCount === workflows.length) {
      return { status: 'approved' };
    }

    // Henüz tamamlanmamışsa pending ve mevcut adımı döndür
    return {
      status: 'pending',
      currentStep: approvedCount + 1, // sıradaki adım
      totalSteps: workflows.length, // toplam adım sayısı
    };
  }

  /**
   * Talebin onaycı zincirini döner (workflow sırası)
   * @param requestId Talep ID'si
   */
  async getApproverChain(requestId: number) {
    // Workflow kayıtlarını oluşturulma sırasına göre getir
    return this.workflowRepository.find({
      where: { request: { id: requestId } },
      relations: ['approver'],
      order: { createdAt: 'ASC' },
    });
  }
}