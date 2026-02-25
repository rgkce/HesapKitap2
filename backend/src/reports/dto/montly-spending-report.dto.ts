// Aylık harcama raporu DTO'su
// Frontend veya API yanıtında döndürülecek veri formatını belirler
export class MonthlySpendingReportDto {
  // Ay bilgisi, format: YYYY-MM (ör: "2026-02")
  month: string;

  // O ay için toplam harcama
  totalAmount: number;
}