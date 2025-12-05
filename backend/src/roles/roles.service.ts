// RolesService: Rol CRUD işlemleri ve kullanıcıya rol atama mantığını içerir
import { Injectable, ConflictException, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Role } from './entities/role.entity';
import { CreateRoleDto } from './dto/create-role.dto';
import { UpdateRoleDto } from './dto/update-role.dto';
import { AssignRoleDto } from './dto/assign-role.dto';
import { User } from '../users/entities/user.entity';

@Injectable()
export class RolesService {
  constructor(
    @InjectRepository(Role)
    private readonly roleRepo: Repository<Role>, // Role tablosu için repository

    @InjectRepository(User)
    private readonly userRepo: Repository<User>, // User tablosu için repository
  ) {}

  // Yeni rol oluşturma
  async create(dto: CreateRoleDto): Promise<Role> {
    const exists = await this.roleRepo.findOne({ where: { name: dto.name } });
    if (exists) {
      throw new ConflictException('Role already exists');
    }

    const role = this.roleRepo.create(dto);
    return this.roleRepo.save(role);
  }

  // Tüm rolleri listeleme
  async findAll(): Promise<Role[]> {
    return this.roleRepo.find();
  }

  // Belirli bir rolü ID ile bulma
  async findOne(id: string): Promise<Role> {
    const role = await this.roleRepo.findOne({ where: { id } });
    if (!role) throw new NotFoundException('Role not found');
    return role;
  }

  // Rol güncelleme
  async update(id: string, dto: UpdateRoleDto): Promise<Role> {
    const role = await this.findOne(id); // Rol var mı kontrol et
    Object.assign(role, dto); // DTO'daki alanlarla rolü güncelle
    return this.roleRepo.save(role);
  }

  // Rol silme
  async remove(id: string): Promise<void> {
    const role = await this.findOne(id); // Rol var mı kontrol et
    await this.roleRepo.remove(role); // Rolü sil
  }

  // Bir kullanıcıya rol atama
  async assignRole(dto: AssignRoleDto) {
    // Kullanıcıyı rollerle birlikte getir
    const user = await this.userRepo.findOne({
      where: { id: dto.userId },
      relations: ['roles'], // Roller many-to-many ilişkisinde
    });

    if (!user) throw new NotFoundException('User not found');

    // Atanacak rolü getir
    const role = await this.roleRepo.findOne({ where: { id: dto.roleId } });
    if (!role) throw new NotFoundException('Role not found');

    // Kullanıcıda bu rol zaten var mı?
    const alreadyAssigned = user.roles.some((r) => r.id === role.id);
    if (alreadyAssigned) {
      throw new ConflictException('User already has this role');
    }

    // Rolü kullanıcıya ekle
    user.roles.push(role);
    await this.userRepo.save(user);

    return {
      message: 'Role assigned successfully',
      userId: user.id,
      roleId: role.id,
    };
  }
}
