/**
 * String Utility
 *
 * Provides string manipulation and formatting functions.
 */

/**
 * Capitalize first letter of a string
 *
 * @param str - Input string
 * @returns String with first letter capitalized
 *
 * @example
 * ```typescript
 * capitalize('hello world');
 * // "Hello world"
 * ```
 */
export function capitalize(str: string): string {
  if (!str) return str;
  return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
}

/**
 * Convert string to title case (capitalize each word)
 *
 * @param str - Input string
 * @returns String in title case
 *
 * @example
 * ```typescript
 * toTitleCase('hello world');
 * // "Hello World"
 * ```
 */
export function toTitleCase(str: string): string {
  if (!str) return str;
  return str
    .split(' ')
    .map((word) => capitalize(word))
    .join(' ');
}

/**
 * Convert string to slug (lowercase with hyphens)
 *
 * @param str - Input string
 * @returns URL-friendly slug
 *
 * @example
 * ```typescript
 * toSlug('Hello World!');
 * // "hello-world"
 * ```
 */
export function toSlug(str: string): string {
  return str
    .toLowerCase()
    .trim()
    .replace(/[^\w\s-]/g, '') // Remove special characters
    .replace(/[\s_-]+/g, '-') // Replace spaces and underscores with single hyphen
    .replace(/^-+|-+$/g, ''); // Remove leading/trailing hyphens
}

/**
 * Truncate string to specified length
 *
 * @param str - Input string
 * @param length - Maximum length
 * @param suffix - Suffix to add when truncated (default: '...')
 * @returns Truncated string
 *
 * @example
 * ```typescript
 * truncate('This is a long sentence', 10);
 * // "This is a..."
 * ```
 */
export function truncate(
  str: string,
  length: number,
  suffix: string = '...',
): string {
  if (str.length <= length) return str;
  return str.substring(0, length - suffix.length) + suffix;
}

/**
 * Generate random string
 *
 * @param length - Length of random string
 * @param charset - Character set to use (default: alphanumeric)
 * @returns Random string
 *
 * @example
 * ```typescript
 * randomString(8);
 * // "aB3xY9Zq"
 * ```
 */
export function randomString(
  length: number,
  charset: string = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
): string {
  let result = '';
  for (let i = 0; i < length; i++) {
    result += charset.charAt(Math.floor(Math.random() * charset.length));
  }
  return result;
}

/**
 * Generate random alphanumeric code (uppercase only)
 *
 * @param length - Length of code
 * @returns Random alphanumeric code
 *
 * @example
 * ```typescript
 * generateCode(8);
 * // "AB3XY9ZQ"
 * ```
 */
export function generateCode(length: number): string {
  return randomString(length, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789');
}

/**
 * Check if string is empty or only whitespace
 *
 * @param str - String to check
 * @returns True if empty or whitespace
 *
 * @example
 * ```typescript
 * isBlank('   ');
 * // true
 * ```
 */
export function isBlank(str: string | null | undefined): boolean {
  return !str || str.trim().length === 0;
}

/**
 * Remove extra whitespace from string
 *
 * @param str - Input string
 * @returns String with normalized whitespace
 *
 * @example
 * ```typescript
 * normalizeWhitespace('Hello    World  !');
 * // "Hello World !"
 * ```
 */
export function normalizeWhitespace(str: string): string {
  return str.replace(/\s+/g, ' ').trim();
}

/**
 * Mask sensitive string (e.g., email, phone)
 *
 * @param str - String to mask
 * @param visibleStart - Number of characters visible at start
 * @param visibleEnd - Number of characters visible at end
 * @param maskChar - Character to use for masking (default: '*')
 * @returns Masked string
 *
 * @example
 * ```typescript
 * maskString('user@example.com', 3, 4);
 * // "use*********.com"
 * ```
 */
export function maskString(
  str: string,
  visibleStart: number = 3,
  visibleEnd: number = 4,
  maskChar: string = '*',
): string {
  if (str.length <= visibleStart + visibleEnd) {
    return str;
  }

  const start = str.substring(0, visibleStart);
  const end = str.substring(str.length - visibleEnd);
  const maskLength = str.length - visibleStart - visibleEnd;
  const mask = maskChar.repeat(maskLength);

  return `${start}${mask}${end}`;
}

/**
 * Extract initials from name
 *
 * @param name - Full name
 * @param maxInitials - Maximum number of initials (default: 2)
 * @returns Initials in uppercase
 *
 * @example
 * ```typescript
 * getInitials('John Doe');
 * // "JD"
 * getInitials('John William Doe', 3);
 * // "JWD"
 * ```
 */
export function getInitials(name: string, maxInitials: number = 2): string {
  return name
    .split(' ')
    .filter((word) => word.length > 0)
    .slice(0, maxInitials)
    .map((word) => word[0].toUpperCase())
    .join('');
}
