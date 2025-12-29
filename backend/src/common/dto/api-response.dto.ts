/**
 * Response metadata
 */
export class ResponseMeta {
  /**
   * Timestamp of the response (ISO 8601)
   */
  timestamp: string;

  /**
   * Unique request ID for tracing
   */
  requestId: string;

  constructor(requestId: string) {
    this.timestamp = new Date().toISOString();
    this.requestId = requestId;
  }
}

/**
 * Generic success response wrapper
 */
export class ApiResponse<T> {
  /**
   * Success flag
   */
  success: boolean;

  /**
   * Response data
   */
  data: T;

  /**
   * Response metadata
   */
  meta: ResponseMeta;

  constructor(data: T, requestId: string) {
    this.success = true;
    this.data = data;
    this.meta = new ResponseMeta(requestId);
  }
}

/**
 * Error details object
 */
export class ErrorDetails {
  /**
   * Error code (e.g., ERR_AUTH_001)
   */
  code: string;

  /**
   * Human-readable error message
   */
  message: string;

  /**
   * Additional error details (validation errors, etc.)
   */
  details?: any;

  constructor(code: string, message: string, details?: any) {
    this.code = code;
    this.message = message;
    if (details) {
      this.details = details;
    }
  }
}

/**
 * Error response wrapper
 */
export class ApiErrorResponse {
  /**
   * Success flag (always false for errors)
   */
  success: boolean;

  /**
   * Error information
   */
  error: ErrorDetails;

  constructor(code: string, message: string, details?: any) {
    this.success = false;
    this.error = new ErrorDetails(code, message, details);
  }
}
