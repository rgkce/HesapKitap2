// UsersController: Kullanıcı işlemlerini yöneten REST API controller
import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards } from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';

@Controller('users')
// Tüm kullanıcı endpoint'lerinde JWT doğrulaması ve rol kontrolü aktif
@UseGuards(JwtAuthGuard, RolesGuard)
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  // Yeni kullanıcı oluşturma — sadece admin yetkisi
  @Post()
  @Roles('admin')
  create(@Body() dto: CreateUserDto) {
    return this.usersService.create(dto);
  }

  // Tüm kullanıcıları listeleme — sadece admin yetkisi
  @Get()
  @Roles('admin')
  findAll() {
    return this.usersService.findAll();
  }

  // Belirli bir kullanıcıyı ID ile getirme — admin ve kullanıcı kendi bilgisine erişebilir
  @Get(':id')
  @Roles('admin', 'user')
  findOne(@Param('id') id: string) {
    return this.usersService.findOne(id);
  }

  // Kullanıcı güncelleme — admin veya user rolü
  @Patch(':id')
  @Roles('admin', 'user')
  update(@Param('id') id: string, @Body() dto: UpdateUserDto) {
    return this.usersService.update(id, dto);
  }

  // Kullanıcı silme — sadece admin
  @Delete(':id')
  @Roles('admin')
  remove(@Param('id') id: string) {
    return this.usersService.remove(id);
  }
}
