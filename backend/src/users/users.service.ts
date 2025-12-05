// UsersService: Kullanıcı CRUD işlemlerinin iş mantığını içerir
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
    // User repository'si TypeORM üzerinden inject edilir
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
  ) {}

  // User entity objesini şifre hariç UserResponseDto formatına dönüştürür
  private toResponse(user: User): UserResponseDto {
    const { password, ...response } = user;
    return response;
  }

  // Yeni kullanıcı oluşturma işlemi
  async create(dto: CreateUserDto): Promise<UserResponseDto> {
    // Aynı e-posta var mı kontrol et
    const exists = await this.userRepo.findOne({ where: { email: dto.email } });

    if (exists) {
      throw new ConflictException('Email already in use');
    }

    // Şifre hashleme işlemi
    const hashedPass = await bcrypt.hash(dto.password, 10);

    // Yeni kullanıcı entity'si oluşturma
    const user = this.userRepo.create({
      ...dto,
      password: hashedPass,
    });

    // DB’ye kaydet
    await this.userRepo.save(user);
    return this.toResponse(user);
  }

  // Tüm kullanıcıları listeleme
  async findAll(): Promise<UserResponseDto[]> {
    const users = await this.userRepo.find();
    return users.map((u) => this.toResponse(u));
  }

  // Belirli kullanıcıyı ID ile bulma
  async findOne(id: string): Promise<UserResponseDto> {
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('User not found');
    return this.toResponse(user);
  }

  // Kullanıcı güncelleme
  async update(id: string, dto: UpdateUserDto): Promise<UserResponseDto> {
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('User not found');

    // Şifre güncellenecekse hashle
    if (dto.password) {
      dto.password = await bcrypt.hash(dto.password, 10);
    }

    // Veritabanında güncelle
    await this.userRepo.update(id, dto);

    // Güncellenmiş kullanıcıyı geri çek
    const updated = await this.userRepo.findOne({ where: { id } });
    return this.toResponse(updated);
  }

  // Kullanıcı silme
  async remove(id: string): Promise<void> {
    const exists = await this.userRepo.findOne({ where: { id } });
    if (!exists) throw new NotFoundException('User not found');

    await this.userRepo.delete(id);
  }
}
