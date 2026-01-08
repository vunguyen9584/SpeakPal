import { HttpStatus } from '@nestjs/common';
import { AppException } from './app.exception';
import { VALIDATION_ERROR_CODES } from './error-codes';

/**
 * Base validation exception
 */
export abstract class ValidationException extends AppException {
  constructor(message: string, code: string, details?: Record<string, any>) {
    super(message, code, HttpStatus.BAD_REQUEST, details);
  }
}

/**
 * Required field missing exception
 */
export class RequiredFieldMissingException extends ValidationException {
  readonly code = VALIDATION_ERROR_CODES.REQUIRED_FIELD_MISSING;

  constructor(field: string, details?: Record<string, any>) {
    super(
      `Required field missing: ${field}`,
      VALIDATION_ERROR_CODES.REQUIRED_FIELD_MISSING,
      { field, ...details },
    );
  }
}

/**
 * Invalid format exception
 */
export class InvalidFormatException extends ValidationException {
  readonly code = VALIDATION_ERROR_CODES.INVALID_FORMAT;

  constructor(
    field: string,
    expectedFormat?: string,
    details?: Record<string, any>,
  ) {
    super(
      `Invalid format for field: ${field}`,
      VALIDATION_ERROR_CODES.INVALID_FORMAT,
      { field, expectedFormat, ...details },
    );
  }
}

/**
 * Value too short exception
 */
export class ValueTooShortException extends ValidationException {
  readonly code = VALIDATION_ERROR_CODES.VALUE_TOO_SHORT;

  constructor(field: string, minLength: number, details?: Record<string, any>) {
    super(
      `Value too short for field: ${field}`,
      VALIDATION_ERROR_CODES.VALUE_TOO_SHORT,
      { field, minLength, ...details },
    );
  }
}

/**
 * Value too long exception
 */
export class ValueTooLongException extends ValidationException {
  readonly code = VALIDATION_ERROR_CODES.VALUE_TOO_LONG;

  constructor(field: string, maxLength: number, details?: Record<string, any>) {
    super(
      `Value too long for field: ${field}`,
      VALIDATION_ERROR_CODES.VALUE_TOO_LONG,
      { field, maxLength, ...details },
    );
  }
}

/**
 * Invalid enum value exception
 */
export class InvalidEnumValueException extends ValidationException {
  readonly code = VALIDATION_ERROR_CODES.INVALID_ENUM_VALUE;

  constructor(
    field: string,
    value: string,
    allowedValues: string[],
    details?: Record<string, any>,
  ) {
    super(
      `Invalid enum value for field: ${field}`,
      VALIDATION_ERROR_CODES.INVALID_ENUM_VALUE,
      { field, value, allowedValues, ...details },
    );
  }
}

/**
 * Invalid UUID format exception
 */
export class InvalidUuidFormatException extends ValidationException {
  readonly code = VALIDATION_ERROR_CODES.INVALID_UUID_FORMAT;

  constructor(field: string, value: string, details?: Record<string, any>) {
    super(
      `Invalid UUID format for field: ${field}`,
      VALIDATION_ERROR_CODES.INVALID_UUID_FORMAT,
      { field, value, ...details },
    );
  }
}
