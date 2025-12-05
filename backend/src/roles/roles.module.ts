// RolesModule: Rol yönetimi için controller + service + entity yapılarını bir araya getiren modül
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { RolesService } from './roles.service';
import { RolesController } from './roles.controller';
import { Role } from './entities/role.entity';
import { User } from '../users/entities/user.entity';

@Module({
  // Role ve User entity’lerini TypeORM’e tanıtır
  imports: [TypeOrmModule.forFeature([Role, User])],
  controllers: [RolesController],
  providers: [RolesService],
  exports: [RolesService], // Diğer modüllerin RolesService kullanabilmesi için export edilir
})
export class RolesModule {}
