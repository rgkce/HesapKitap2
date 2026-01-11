import * as bcrypt from 'bcrypt';

const SALT_ROUNDS = 10;

/**
 * Parolayı hash'ler
 */
export async function hashPassword(
  password: string,
): Promise<string> {
  return bcrypt.hash(password, SALT_ROUNDS);
}

/**
 * Girilen parola ile hash karşılaştırması yapar
 */
export async function comparePasswords(
  password: string,
  hash: string,
): Promise<boolean> {
  return bcrypt.compare(password, hash);
}
