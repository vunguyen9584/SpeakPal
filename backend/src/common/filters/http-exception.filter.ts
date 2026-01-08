import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { AppException } from '../exceptions/app.exception';

/**
 * HTTP Exception Filter
 *
 * Catches HttpException and AppException instances and formats them
 * according to our API error response format.
 */
@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(HttpExceptionFilter.name);

  catch(exception: HttpException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();
    const status = exception.getStatus();

    // Generate request ID (fallback if not set by middleware)
    const requestId =
      (request as unknown as { id?: string }).id || this.generateRequestId();

    // Build error response
    const errorResponse = this.buildErrorResponse(
      exception,
      request,
      requestId,
    );

    // Log the error
    this.logError(exception, request, requestId, status);

    // Send response
    response.status(status).json(errorResponse);
  }

  private buildErrorResponse(
    exception: HttpException,
    request: Request,
    requestId: string,
  ) {
    // If it's our custom AppException, use its toErrorResponse method
    if (exception instanceof AppException) {
      return exception.toErrorResponse(requestId);
    }

    // Handle standard NestJS HttpException
    const exceptionResponse = exception.getResponse();
    const status = exception.getStatus();

    // If response is a string, create simple error object
    if (typeof exceptionResponse === 'string') {
      return {
        success: false,
        error: {
          code: this.getErrorCodeFromStatus(status),
          message: exceptionResponse,
          timestamp: new Date().toISOString(),
          requestId,
        },
      };
    }

    // If response is an object (e.g., validation errors from class-validator)
    const responseObj = exceptionResponse as Record<string, unknown>;
    return {
      success: false,
      error: {
        code: this.getErrorCodeFromStatus(status),
        message: (responseObj.message as string) || exception.message,
        details: responseObj.error
          ? { fields: this.extractValidationErrors(responseObj) }
          : undefined,
        timestamp: new Date().toISOString(),
        requestId,
      },
    };
  }

  private extractValidationErrors(
    responseObj: Record<string, unknown>,
  ): unknown[] {
    // Handle class-validator errors
    const messages = responseObj.message;
    if (Array.isArray(messages)) {
      return messages.map((msg: unknown) => {
        const messageStr = typeof msg === 'string' ? msg : JSON.stringify(msg);
        // Try to parse field name from message
        const match = messageStr.match(/^(\w+)\s/);
        return {
          field: match ? match[1] : 'unknown',
          message: messageStr,
        };
      });
    }
    return [];
  }

  private getErrorCodeFromStatus(status: number): string {
    const codeMap: Record<number, string> = {
      [HttpStatus.BAD_REQUEST]: 'ERR_VAL_001',
      [HttpStatus.UNAUTHORIZED]: 'ERR_AUTH_003',
      [HttpStatus.FORBIDDEN]: 'ERR_AUTH_006',
      [HttpStatus.NOT_FOUND]: 'ERR_RES_001',
      [HttpStatus.CONFLICT]: 'ERR_BIZ_001',
      [HttpStatus.TOO_MANY_REQUESTS]: 'ERR_RATE_001',
      [HttpStatus.INTERNAL_SERVER_ERROR]: 'ERR_INT_001',
      [HttpStatus.SERVICE_UNAVAILABLE]: 'ERR_EXT_001',
    };

    return codeMap[status] || 'ERR_INT_001';
  }

  private logError(
    exception: HttpException,
    request: Request,
    requestId: string,
    status: number,
  ) {
    const errorLog = {
      requestId,
      timestamp: new Date().toISOString(),
      path: request.url,
      method: request.method,
      statusCode: status,
      message: exception.message,
      stack: exception.stack,
      ...(exception instanceof AppException && { code: exception.code }),
    };

    // Log as error for 5xx, warn for 4xx
    if (status >= 500) {
      this.logger.error(errorLog);
    } else {
      this.logger.warn(errorLog);
    }
  }

  private generateRequestId(): string {
    return `req-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  }
}
