/**
 * Tarihi ISO veya yerel formatta döner
 */
export function formatDate(
  date: Date,
  locale: string = 'tr-TR',
): string {
  return date.toLocaleDateString(locale, {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  });
}

/**
 * Son X günün tarih aralığını döner
 */
export function getDateRange(days: number): {
  startDate: Date;
  endDate: Date;
} {
  const endDate = new Date();
  const startDate = new Date();

  startDate.setDate(endDate.getDate() - days);

  return {
    startDate,
    endDate,
  };
}
