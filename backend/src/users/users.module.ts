// UsersModule: Kullanıcı işlemleri ile ilgili controller ve servisleri bir araya getirir
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { User } from './entities/user.entity';

@Module({
  // TypeORM repository erişimi için User entity modüle dahil edilir
  imports: [TypeOrmModule.forFeature([User])],
  // HTTP endpointlerin yönetildiği controller
  controllers: [UsersController],
  // İş mantığının yazıldığı servis
  providers: [UsersService],
  // Başka modüllerde kullanılmak üzere servis dışa aktarılır
  exports: [UsersService],
})
export class UsersModule {}
