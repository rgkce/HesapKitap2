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

  private toResponse(user: User): UserResponseDto {
    const { password, ...response } = user;
    return response;
  }

  async create(dto: CreateUserDto): Promise<UserResponseDto> {
    const exists = await this.userRepo.findOne({ where: { email: dto.email } });

    if (exists) {
      throw new ConflictException('Email already in use');
    }

    const hashedPass = await bcrypt.hash(dto.password, 10);

    const user = this.userRepo.create({
      ...dto,
      password: hashedPass,
    });

    await this.userRepo.save(user);
    return this.toResponse(user);
  }

  async findAll(): Promise<UserResponseDto[]> {
    const users = await this.userRepo.find();
    return users.map((u) => this.toResponse(u));
  }

  async findOne(id: string): Promise<UserResponseDto> {
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('User not found');
    return this.toResponse(user);
  }

  async update(id: string, dto: UpdateUserDto): Promise<UserResponseDto> {
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('User not found');

    if (dto.password) {
      dto.password = await bcrypt.hash(dto.password, 10);
    }

    await this.userRepo.update(id, dto);

    const updated = await this.userRepo.findOne({ where: { id } });
    return this.toResponse(updated);
  }

  async remove(id: string): Promise<void> {
    const exists = await this.userRepo.findOne({ where: { id } });
    if (!exists) throw new NotFoundException('User not found');

    await this.userRepo.delete(id);
  }
}
