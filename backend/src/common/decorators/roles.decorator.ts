import { SetMetadata } from '@nestjs/common';

export const ROLES_KEY = 'roles';

/**
 * Endpoint'e erişebilecek rolleri tanımlar
 */
export const Roles = (...roles: string[]) =>
  SetMetadata(ROLES_KEY, roles);
