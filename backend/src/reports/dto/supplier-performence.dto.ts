// Tedarikçi performans raporu DTO'su
// Tedarikçi bazlı onaylanan ve reddedilen teklif sayılarını taşır
export class SupplierPerformanceDto {
  // Tedarikçi ID'si
  supplierId: number;

  // Tedarikçi adı
  supplierName: string;

  // Onaylanan teklif sayısı
  approvedOffers: number;

  // Reddedilen teklif sayısı
  rejectedOffers: number;
}