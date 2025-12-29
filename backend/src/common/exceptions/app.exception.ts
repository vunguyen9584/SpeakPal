import { HttpException, HttpStatus } from '@nestjs/common';

/**
 * Base application exception class
 *
 * All custom exceptions should extend this class.
 */
export abstract class AppException extends HttpException {
  /**
   * Error code (e.g., ERR_AUTH_001)
   */
  code: string;

  /**
   * Additional error details
   */
  details?: Record<string, any>;

  /**
   * Timestamp when the error occurred
   */
  readonly timestamp: string;

  constructor(
    message: string,
    code: string,
    statusCode: HttpStatus,
    details?: Record<string, any>,
  ) {
    super(message, statusCode);
    this.code = code;
    this.details = details;
    this.timestamp = new Date().toISOString();

    // Maintains proper stack trace for where our error was thrown
    Error.captureStackTrace(this, this.constructor);
  }

  /**
   * Convert exception to error response format
   */
  toErrorResponse(requestId?: string) {
    return {
      success: false,
      error: {
        code: this.code,
        message: this.message,
        details: this.details,
        timestamp: this.timestamp,
        ...(requestId && { requestId }),
      },
    };
  }
}
