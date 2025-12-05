// RolesController: Rol ekleme, silme, güncelleme ve kullanıcıya rol atama işlemlerini yönetir
import { Controller, Post, Get, Param, Patch, Delete, Body, UseGuards } from '@nestjs/common';
import { RolesService } from './roles.service';
import { CreateRoleDto } from './dto/create-role.dto';
import { UpdateRoleDto } from './dto/update-role.dto';
import { AssignRoleDto } from './dto/assign-role.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';

@Controller('roles')
@UseGuards(JwtAuthGuard, RolesGuard) // Tüm endpoint'lerde JWT doğrulaması + role guard uygulanır
@Roles('admin') // Bu controller altındaki tüm işlemlere sadece admin kullanıcı erişebilir
export class RolesController {
  constructor(private readonly rolesService: RolesService) {}

  // Yeni rol oluşturma
  @Post()
  create(@Body() dto: CreateRoleDto) {
    return this.rolesService.create(dto);
  }

  // Tüm rolleri listeleme
  @Get()
  findAll() {
    return this.rolesService.findAll();
  }

  // ID'ye göre rol getirme
  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.rolesService.findOne(id);
  }

  // Rol güncelleme
  @Patch(':id')
  update(@Param('id') id: string, @Body() dto: UpdateRoleDto) {
    return this.rolesService.update(id, dto);
  }

  // Rol silme
  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.rolesService.remove(id);
  }

  // Bir kullanıcıya rol atama
  @Post('assign')
  assignRole(@Body() dto: AssignRoleDto) {
    return this.rolesService.assignRole(dto);
  }
}
