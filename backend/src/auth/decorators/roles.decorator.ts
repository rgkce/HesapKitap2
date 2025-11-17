import { SetMetadata } from '@nestjs/common';

// Bu key, metadata üzerinde rollerin saklanacağı anahtar adıdır.
// RolesGuard bu anahtar üzerinden controller'a eklenen rolleri okuyacaktır.
export const ROLES_KEY = 'roles';

// Roles decorator'ı, verilen rolleri NestJS metadata'sına ekler.
// Örnek kullanım: @Roles('ADMIN', 'USER')
// Bu decorator tek başına çalışmaz; RolesGuard ile birlikte çalışır.
export const Roles = (...roles: string[]) => SetMetadata(ROLES_KEY, roles);
