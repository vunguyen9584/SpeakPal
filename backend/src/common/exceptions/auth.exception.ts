import { HttpStatus } from '@nestjs/common';
import { AppException } from './app.exception';
import { AUTH_ERROR_CODES } from './error-codes';

/**
 * Base authentication exception
 */
export abstract class AuthException extends AppException {
  constructor(
    message: string,
    code: string,
    statusCode: HttpStatus = HttpStatus.UNAUTHORIZED,
    details?: Record<string, any>,
  ) {
    super(message, code, statusCode, details);
  }
}

/**
 * Invalid credentials exception (wrong email/password)
 */
export class InvalidCredentialsException extends AuthException {
  readonly code = AUTH_ERROR_CODES.INVALID_CREDENTIALS;

  constructor(details?: Record<string, any>) {
    super(
      'Invalid credentials',
      AUTH_ERROR_CODES.INVALID_CREDENTIALS,
      HttpStatus.UNAUTHORIZED,
      details,
    );
  }
}

/**
 * Token expired exception
 */
export class TokenExpiredException extends AuthException {
  readonly code = AUTH_ERROR_CODES.TOKEN_EXPIRED;

  constructor(details?: Record<string, any>) {
    super(
      'Token expired',
      AUTH_ERROR_CODES.TOKEN_EXPIRED,
      HttpStatus.UNAUTHORIZED,
      details,
    );
  }
}

/**
 * Token invalid exception
 */
export class TokenInvalidException extends AuthException {
  readonly code = AUTH_ERROR_CODES.TOKEN_INVALID;

  constructor(details?: Record<string, any>) {
    super(
      'Token invalid',
      AUTH_ERROR_CODES.TOKEN_INVALID,
      HttpStatus.UNAUTHORIZED,
      details,
    );
  }
}

/**
 * Account locked exception
 */
export class AccountLockedException extends AuthException {
  readonly code = AUTH_ERROR_CODES.ACCOUNT_LOCKED;

  constructor(details?: Record<string, any>) {
    super(
      'Account locked',
      AUTH_ERROR_CODES.ACCOUNT_LOCKED,
      HttpStatus.FORBIDDEN,
      details,
    );
  }
}

/**
 * Email not verified exception
 */
export class EmailNotVerifiedException extends AuthException {
  readonly code = AUTH_ERROR_CODES.EMAIL_NOT_VERIFIED;

  constructor(email: string, details?: Record<string, any>) {
    super(
      'Email not verified',
      AUTH_ERROR_CODES.EMAIL_NOT_VERIFIED,
      HttpStatus.FORBIDDEN,
      { email, ...details },
    );
  }
}

/**
 * Insufficient permissions exception
 */
export class InsufficientPermissionsException extends AuthException {
  readonly code = AUTH_ERROR_CODES.INSUFFICIENT_PERMISSIONS;

  constructor(requiredPermission?: string, details?: Record<string, any>) {
    super(
      'Insufficient permissions',
      AUTH_ERROR_CODES.INSUFFICIENT_PERMISSIONS,
      HttpStatus.FORBIDDEN,
      { requiredPermission, ...details },
    );
  }
}

/**
 * OAuth provider error exception
 */
export class OAuthProviderException extends AuthException {
  readonly code = AUTH_ERROR_CODES.OAUTH_PROVIDER_ERROR;

  constructor(provider: string, error?: string, details?: Record<string, any>) {
    super(
      `OAuth provider error: ${provider}`,
      AUTH_ERROR_CODES.OAUTH_PROVIDER_ERROR,
      HttpStatus.BAD_REQUEST,
      { provider, error, ...details },
    );
  }
}
