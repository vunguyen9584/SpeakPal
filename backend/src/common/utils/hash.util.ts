import * as bcrypt from 'bcrypt';

/**
 * Hash Utility
 *
 * Provides password hashing and verification using bcrypt.
 */

/**
 * Number of salt rounds for bcrypt hashing
 * Higher values = more secure but slower
 */
const SALT_ROUNDS = 10;

/**
 * Hash a plain text password
 *
 * @param password - Plain text password to hash
 * @returns Hashed password
 *
 * @example
 * ```typescript
 * const hashedPassword = await hashPassword('mySecretPassword');
 * // Store hashedPassword in database
 * ```
 */
export async function hashPassword(password: string): Promise<string> {
  return bcrypt.hash(password, SALT_ROUNDS);
}

/**
 * Compare a plain text password with a hashed password
 *
 * @param password - Plain text password to verify
 * @param hashedPassword - Hashed password to compare against
 * @returns True if passwords match, false otherwise
 *
 * @example
 * ```typescript
 * const isValid = await comparePassword(
 *   'userInputPassword',
 *   storedHashedPassword
 * );
 * if (isValid) {
 *   // Password is correct
 * }
 * ```
 */
export async function comparePassword(
  password: string,
  hashedPassword: string,
): Promise<boolean> {
  return bcrypt.compare(password, hashedPassword);
}

/**
 * Generate a random password hash for testing purposes
 *
 * @param password - Password to hash (default: 'password')
 * @returns Hashed password
 */
export async function generateTestHash(password: string = 'password'): Promise<string> {
  return hashPassword(password);
}
