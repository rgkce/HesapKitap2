/**
 * Tarihi ISO veya yerel formatta döner
 * Bu fonksiyon verilen Date nesnesini belirtilen locale (dil/bölge) formatına göre string olarak biçimlendirir
 */
export function formatDate(
  // Formatlanacak tarih bilgisi
  date: Date,

  // Varsayılan olarak Türkçe tarih formatı (tr-TR) kullanılır
  locale: string = 'tr-TR',
): string {
  // Date nesnesi, yıl-ay-gün formatında okunabilir bir string'e dönüştürülür
  return date.toLocaleDateString(locale, {
    year: 'numeric',   // Yılı sayısal olarak gösterir (ör: 2026)
    month: '2-digit',  // Ayı iki haneli olarak gösterir (ör: 02)
    day: '2-digit',    // Günü iki haneli olarak gösterir (ör: 25)
  });
}

/**
 * Son X günün tarih aralığını döner
 * Bu fonksiyon bugünün tarihini baz alarak geçmişe doğru belirli gün sayısı kadar tarih aralığı hesaplar
 */
export function getDateRange(days: number): {
  startDate: Date;
  endDate: Date;
} {
  // Bugünün tarihini bitiş tarihi (endDate) olarak belirler
  const endDate = new Date();

  // Başlangıç tarihi için yeni bir Date nesnesi oluşturur
  const startDate = new Date();

  // Başlangıç tarihini, bugünden belirtilen gün sayısı kadar geriye alır
  startDate.setDate(endDate.getDate() - days);

  // Hesaplanan başlangıç ve bitiş tarihlerini nesne olarak döndürür
  return {
    startDate,
    endDate,
  };
}