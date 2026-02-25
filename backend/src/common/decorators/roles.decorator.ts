// NestJS içerisinden metadata tanımlamak için kullanılan SetMetadata fonksiyonunu import eder
import { SetMetadata } from '@nestjs/common';

// Roller için kullanılacak metadata anahtarını (key) tanımlar
// Bu anahtar RolesGuard tarafından okunacaktır
export const ROLES_KEY = 'roles';

/**
 * Endpoint'e erişebilecek rolleri tanımlar
 * Bu decorator, controller veya method üzerine eklenerek
 * hangi rollerin bu endpoint'e erişebileceğini belirtir
 */
export const Roles = (...roles: string[]) =>
  // SetMetadata ile belirtilen roller NestJS'in reflection sistemi üzerinden saklanır
  // RolesGuard bu bilgiyi kullanarak yetkilendirme kontrolü yapar
  SetMetadata(ROLES_KEY, roles);