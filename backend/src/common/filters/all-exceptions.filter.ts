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
import { INTERNAL_ERROR_CODES } from '../exceptions/error-codes';

/**
 * All Exceptions Filter
 *
 * Catches all unhandled exceptions (including non-HTTP exceptions)
 * and formats them according to our API error response format.
 *
 * This is the global fallback filter for any exception that wasn't
 * caught by more specific filters.
 */
@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  private readonly logger = new Logger(AllExceptionsFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    // Generate request ID (fallback if not set by middleware)
    const requestId =
      ((request as any).id as string) || this.generateRequestId();

    // Determine status code and build error response
    const { status, errorResponse } = this.buildErrorResponse(
      exception,
      requestId,
    );

    // Log the error
    this.logError(exception, request, requestId, status);

    // Send response
    response.status(status).json(errorResponse);
  }

  private buildErrorResponse(exception: unknown, requestId: string) {
    // Handle our custom AppException
    if (exception instanceof AppException) {
      return {
        status: exception.getStatus(),
        errorResponse: exception.toErrorResponse(requestId),
      };
    }

    // Handle NestJS HttpException
    if (exception instanceof HttpException) {
      const status = exception.getStatus();
      const exceptionResponse = exception.getResponse();

      return {
        status,
        errorResponse: {
          success: false,
          error: {
            code: this.getErrorCodeFromStatus(status),
            message:
              typeof exceptionResponse === 'string'
                ? exceptionResponse
                : ((exceptionResponse as Record<string, any>)
                    .message as string) || exception.message,
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
      };
    }

    // Handle standard Error objects
    if (exception instanceof Error) {
      return {
        status: HttpStatus.INTERNAL_SERVER_ERROR,
        errorResponse: {
          success: false,
          error: {
            code: INTERNAL_ERROR_CODES.UNEXPECTED_ERROR,
            message: 'An unexpected error occurred',
            details: {
              originalMessage: exception.message,
            },
            timestamp: new Date().toISOString(),
            requestId,
          },
        },
      };
    }

    // Handle unknown exceptions
    return {
      status: HttpStatus.INTERNAL_SERVER_ERROR,
      errorResponse: {
        success: false,
        error: {
          code: INTERNAL_ERROR_CODES.UNEXPECTED_ERROR,
          message: 'An unexpected error occurred',
          timestamp: new Date().toISOString(),
          requestId,
        },
      },
    };
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
    exception: unknown,
    request: Request,
    requestId: string,
    status: number,
  ) {
    const errorLog: Record<string, unknown> = {
      requestId,
      timestamp: new Date().toISOString(),
      path: request.url,
      method: request.method,
      statusCode: status,
      userAgent: request.headers['user-agent'],
      ip: request.ip,
    };

    // Add exception-specific details
    if (exception instanceof Error) {
      errorLog.message = exception.message;
      errorLog.stack = exception.stack;
      errorLog.name = exception.name;
    }

    if (exception instanceof AppException) {
      errorLog.code = exception.code;
      errorLog.details = exception.details;
    }

    // Log level based on status code
    if (status >= 500) {
      this.logger.error('Internal server error', errorLog);
    } else if (status >= 400) {
      this.logger.warn('Client error', errorLog);
    } else {
      this.logger.log('Exception handled', errorLog);
    }
  }

  private generateRequestId(): string {
    return `req-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  }
}
