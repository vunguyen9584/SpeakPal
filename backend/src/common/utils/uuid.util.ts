/**
 * UUID Utility
 *
 * Provides UUID validation and generation functions.
 */

/**
 * UUID v4 validation regex
 */
const UUID_V4_REGEX =
  /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

/**
 * General UUID validation regex (any version)
 */
const UUID_REGEX =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/**
 * Validate if string is a valid UUID v4
 *
 * @param uuid - String to validate
 * @returns True if valid UUID v4
 *
 * @example
 * ```typescript
 * isValidUuidV4('123e4567-e89b-12d3-a456-426614174000');
 * // false (not v4)
 * isValidUuidV4('550e8400-e29b-41d4-a716-446655440000');
 * // true
 * ```
 */
export function isValidUuidV4(uuid: string): boolean {
  return UUID_V4_REGEX.test(uuid);
}

/**
 * Validate if string is a valid UUID (any version)
 *
 * @param uuid - String to validate
 * @returns True if valid UUID
 *
 * @example
 * ```typescript
 * isValidUuid('550e8400-e29b-41d4-a716-446655440000');
 * // true
 * isValidUuid('not-a-uuid');
 * // false
 * ```
 */
export function isValidUuid(uuid: string): boolean {
  return UUID_REGEX.test(uuid);
}

/**
 * Generate a UUID v4
 *
 * Note: This uses crypto.randomUUID() which is available in Node.js 14.17.0+
 * For production use, Prisma will handle UUID generation, but this is useful
 * for testing or other scenarios.
 *
 * @returns UUID v4 string
 *
 * @example
 * ```typescript
 * const id = generateUuid();
 * // "550e8400-e29b-41d4-a716-446655440000"
 * ```
 */
export function generateUuid(): string {
  // Use Node.js built-in crypto.randomUUID() if available
  if (typeof crypto !== 'undefined' && crypto.randomUUID) {
    return crypto.randomUUID();
  }

  // Fallback implementation (not cryptographically secure)
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
    const r = (Math.random() * 16) | 0;
    const v = c === 'x' ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}

/**
 * Normalize UUID to lowercase
 *
 * @param uuid - UUID string
 * @returns Lowercase UUID
 *
 * @example
 * ```typescript
 * normalizeUuid('550E8400-E29B-41D4-A716-446655440000');
 * // "550e8400-e29b-41d4-a716-446655440000"
 * ```
 */
export function normalizeUuid(uuid: string): string {
  return uuid.toLowerCase();
}

/**
 * Check if string is a valid UUID and throw error if not
 *
 * @param uuid - String to validate
 * @param fieldName - Name of field for error message
 * @throws Error if invalid UUID
 *
 * @example
 * ```typescript
 * validateUuidOrThrow(userId, 'userId');
 * // Throws if userId is not a valid UUID
 * ```
 */
export function validateUuidOrThrow(
  uuid: string,
  fieldName: string = 'id',
): void {
  if (!isValidUuid(uuid)) {
    throw new Error(`Invalid UUID format for ${fieldName}: ${uuid}`);
  }
}
