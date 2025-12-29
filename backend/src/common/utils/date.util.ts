/**
 * Date Utility
 *
 * Provides date formatting and manipulation functions.
 */

/**
 * Format a date to ISO 8601 string (UTC)
 *
 * @param date - Date to format
 * @returns ISO 8601 formatted string
 *
 * @example
 * ```typescript
 * const isoString = formatToIso(new Date());
 * // "2025-12-29T12:00:00.000Z"
 * ```
 */
export function formatToIso(date: Date): string {
  return date.toISOString();
}

/**
 * Format a date to simple date string (YYYY-MM-DD)
 *
 * @param date - Date to format
 * @returns Date string in YYYY-MM-DD format
 *
 * @example
 * ```typescript
 * const dateStr = formatToDateString(new Date());
 * // "2025-12-29"
 * ```
 */
export function formatToDateString(date: Date): string {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}

/**
 * Get start of day (00:00:00.000)
 *
 * @param date - Input date
 * @returns Date at start of day
 *
 * @example
 * ```typescript
 * const startOfDay = getStartOfDay(new Date());
 * // 2025-12-29T00:00:00.000
 * ```
 */
export function getStartOfDay(date: Date): Date {
  const result = new Date(date);
  result.setHours(0, 0, 0, 0);
  return result;
}

/**
 * Get end of day (23:59:59.999)
 *
 * @param date - Input date
 * @returns Date at end of day
 *
 * @example
 * ```typescript
 * const endOfDay = getEndOfDay(new Date());
 * // 2025-12-29T23:59:59.999
 * ```
 */
export function getEndOfDay(date: Date): Date {
  const result = new Date(date);
  result.setHours(23, 59, 59, 999);
  return result;
}

/**
 * Add days to a date
 *
 * @param date - Starting date
 * @param days - Number of days to add (can be negative)
 * @returns New date with days added
 *
 * @example
 * ```typescript
 * const tomorrow = addDays(new Date(), 1);
 * const yesterday = addDays(new Date(), -1);
 * ```
 */
export function addDays(date: Date, days: number): Date {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}

/**
 * Check if two dates are on the same day
 *
 * @param date1 - First date
 * @param date2 - Second date
 * @returns True if dates are on the same day
 *
 * @example
 * ```typescript
 * const isSameDay = areSameDay(new Date(), new Date());
 * // true
 * ```
 */
export function areSameDay(date1: Date, date2: Date): boolean {
  return (
    date1.getFullYear() === date2.getFullYear() &&
    date1.getMonth() === date2.getMonth() &&
    date1.getDate() === date2.getDate()
  );
}

/**
 * Calculate difference in days between two dates
 *
 * @param date1 - First date
 * @param date2 - Second date
 * @returns Number of days between dates (absolute value)
 *
 * @example
 * ```typescript
 * const diff = daysBetween(new Date('2025-01-01'), new Date('2025-01-10'));
 * // 9
 * ```
 */
export function daysBetween(date1: Date, date2: Date): number {
  const msPerDay = 24 * 60 * 60 * 1000;
  const utc1 = Date.UTC(date1.getFullYear(), date1.getMonth(), date1.getDate());
  const utc2 = Date.UTC(date2.getFullYear(), date2.getMonth(), date2.getDate());
  return Math.abs(Math.floor((utc2 - utc1) / msPerDay));
}

/**
 * Check if a date is in the past
 *
 * @param date - Date to check
 * @returns True if date is before now
 *
 * @example
 * ```typescript
 * const isPast = isInPast(new Date('2020-01-01'));
 * // true
 * ```
 */
export function isInPast(date: Date): boolean {
  return date.getTime() < Date.now();
}

/**
 * Check if a date is in the future
 *
 * @param date - Date to check
 * @returns True if date is after now
 *
 * @example
 * ```typescript
 * const isFuture = isInFuture(new Date('2030-01-01'));
 * // true
 * ```
 */
export function isInFuture(date: Date): boolean {
  return date.getTime() > Date.now();
}
