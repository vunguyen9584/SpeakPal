import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { Request } from 'express';
import { ApiResponse } from '../dto/api-response.dto';
import { PaginatedResponseDto } from '../dto/pagination.dto';

/**
 * Transform Interceptor
 *
 * Automatically wraps all successful responses in ApiResponse format.
 * Handles both regular responses and paginated responses.
 */
@Injectable()
export class TransformInterceptor<T> implements NestInterceptor<
  T,
  ApiResponse<T> | PaginatedResponseDto<any>
> {
  intercept(
    context: ExecutionContext,
    next: CallHandler,
  ): Observable<ApiResponse<T> | PaginatedResponseDto<any>> {
    const request = context.switchToHttp().getRequest<Request>();
    const requestId =
      ((request as any).id as string) || this.generateRequestId();

    return next.handle().pipe(
      map((data: unknown) => {
        // If response is already wrapped (e.g., PaginatedResponseDto), return as-is
        if (this.isWrappedResponse(data)) {
          return data as PaginatedResponseDto<any>;
        }

        // If response is null or undefined (e.g., 204 No Content), return as-is
        if (data === null || data === undefined) {
          return data as ApiResponse<T>;
        }

        // Wrap regular responses in ApiResponse
        return new ApiResponse(data as T, requestId);
      }),
    );
  }

  private isWrappedResponse(data: unknown): boolean {
    // Check if response is already wrapped (has 'success' field)
    return data && typeof data === 'object' && 'success' in data;
  }

  private generateRequestId(): string {
    return `req-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  }
}
