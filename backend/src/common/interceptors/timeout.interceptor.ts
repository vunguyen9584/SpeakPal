import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  RequestTimeoutException,
} from '@nestjs/common';
import { Observable, throwError, TimeoutError } from 'rxjs';
import { catchError, timeout } from 'rxjs/operators';

/**
 * Timeout Interceptor
 *
 * Automatically times out requests that exceed a specified duration.
 * Default timeout is 30 seconds for general requests.
 */
@Injectable()
export class TimeoutInterceptor implements NestInterceptor {
  private readonly defaultTimeout = 30000; // 30 seconds

  constructor(private readonly timeoutMs?: number) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const timeoutValue = this.timeoutMs || this.defaultTimeout;

    return next.handle().pipe(
      timeout(timeoutValue),
      catchError((err) => {
        if (err instanceof TimeoutError) {
          return throwError(
            () =>
              new RequestTimeoutException(
                `Request timeout after ${timeoutValue}ms`,
              ),
          );
        }
        return throwError(() => err);
      }),
    );
  }
}

/**
 * Factory function to create TimeoutInterceptor with custom timeout
 */
export function createTimeoutInterceptor(timeoutMs: number): TimeoutInterceptor {
  return new TimeoutInterceptor(timeoutMs);
}
