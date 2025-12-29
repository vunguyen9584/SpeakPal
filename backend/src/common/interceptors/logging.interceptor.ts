import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  Logger,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { Request, Response } from 'express';

/**
 * Logging Interceptor
 *
 * Logs incoming HTTP requests and outgoing responses with performance metrics.
 */
@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  private readonly logger = new Logger(LoggingInterceptor.name);

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest<Request>();
    const response = context.switchToHttp().getResponse<Response>();
    const { method, url, ip } = request;
    const userAgent = request.get('user-agent') || '';

    // Generate or get request ID
    const requestId =
      (request as any).id || this.generateAndSetRequestId(request);

    const startTime = Date.now();

    // Log incoming request
    this.logger.log({
      type: 'REQUEST',
      requestId,
      method,
      url,
      ip,
      userAgent,
      timestamp: new Date().toISOString(),
    });

    return next.handle().pipe(
      tap({
        next: (data) => {
          const duration = Date.now() - startTime;
          const statusCode = response.statusCode;

          // Log successful response
          this.logger.log({
            type: 'RESPONSE',
            requestId,
            method,
            url,
            statusCode,
            duration: `${duration}ms`,
            timestamp: new Date().toISOString(),
          });
        },
        error: (error) => {
          const duration = Date.now() - startTime;
          const statusCode = error.status || 500;

          // Log error response
          this.logger.error({
            type: 'ERROR_RESPONSE',
            requestId,
            method,
            url,
            statusCode,
            duration: `${duration}ms`,
            error: error.message,
            timestamp: new Date().toISOString(),
          });
        },
      }),
    );
  }

  private generateAndSetRequestId(request: Request): string {
    const requestId = `req-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
    (request as any).id = requestId;
    return requestId;
  }
}
