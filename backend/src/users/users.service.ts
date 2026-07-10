import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { UserResponseDto } from './dto/user-response.dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
  ) {}

  // Sadece controller'a dönerken kullanılır — şifreyi çıkarır
  private toResponse(user: User): UserResponseDto {
    const { password, refreshToken, ...response } = user;
    return response;
  }

  // AuthService içeride tam User nesnesine ihtiyaç duyar (password, refreshToken, role dahil)
  async create(dto: CreateUserDto): Promise<User> {
    const exists = await this.userRepo.findOne({ where: { email: dto.email } });
    if (exists) {
      throw new ConflictException('Email already in use');
    }

    const hashedPass = await bcrypt.hash(dto.password, 10);
    const user = this.userRepo.create({
      ...dto,
      password: hashedPass,
    });

    return this.userRepo.save(user);
  }

  // AuthService.login / validateUser için — password dahil tam entity döner
  async findByEmail(email: string): Promise<User | null> {
    return this.userRepo.findOne({ where: { email } });
  }

  // AuthService.refreshToken için — refreshToken dahil tam entity döner
  async findById(id: string): Promise<User | null> {
    return this.userRepo.findOne({ where: { id } });
  }

  // Controller için — DTO listesi
  async findAll(): Promise<UserResponseDto[]> {
    const users = await this.userRepo.find();
    return users.map((u) => this.toResponse(u));
  }

  // Controller için — tek DTO
  async findOne(id: string): Promise<UserResponseDto> {
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('User not found');
    return this.toResponse(user);
  }

  // Hem controller (UpdateUserDto) hem internal (refreshToken güncellemesi) için kullanılır.
  // Partial<User> kabul ederek refreshToken: null gibi entity-özel alanlara da izin verir.
  async update(id: string, dto: UpdateUserDto | Partial<User>): Promise<UserResponseDto> {
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('User not found');

    if ('password' in dto && dto.password) {
      dto.password = await bcrypt.hash(dto.password, 10);
    }

    await this.userRepo.update(id, dto as any);

    const updated = await this.userRepo.findOne({ where: { id } });
    if (!updated) throw new NotFoundException('User not found after update');
    return this.toResponse(updated);
  }

  async remove(id: string): Promise<void> {
    const exists = await this.userRepo.findOne({ where: { id } });
    if (!exists) throw new NotFoundException('User not found');
    await this.userRepo.delete(id);
  }
}