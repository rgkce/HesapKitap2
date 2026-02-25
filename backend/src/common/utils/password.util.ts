// bcrypt kütüphanesini import eder
// Parola hashleme ve doğrulama işlemleri için kullanılır
import * as bcrypt from 'bcrypt';

// Hashleme sırasında kullanılacak salt tur sayısı
// Salt, hashleme sürecini güvenli hale getirir
const SALT_ROUNDS = 10;

/**
 * Parolayı hash'ler
 * Kullanıcının girdiği düz metin parolayı güvenli bir hash değerine çevirir
 */
export async function hashPassword(
  // Hashlenecek parola
  password: string,
): Promise<string> {
  // bcrypt.hash ile parola hashlenir
  return bcrypt.hash(password, SALT_ROUNDS);
}

/**
 * Girilen parola ile hash karşılaştırması yapar
 * Kullanıcının girdiği parola ile veritabanında kayıtlı hash değerini karşılaştırır
 */
export async function comparePasswords(
  // Kullanıcının girdiği düz metin parola
  password: string,

  // Veritabanında saklanan hash değeri
  hash: string,
): Promise<boolean> {
  // bcrypt.compare true/false döner, eşleşme kontrolü sağlar
  return bcrypt.compare(password, hash);
}