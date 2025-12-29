import { Type } from 'class-transformer';
import { IsInt, IsOptional, Min, Max } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

/**
 * Pagination query parameters for list endpoints
 */
export class PaginationQueryDto {
  @ApiPropertyOptional({
    description: 'Page number (1-based)',
    minimum: 1,
    default: 1,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number = 1;

  @ApiPropertyOptional({
    description: 'Number of items per page',
    minimum: 1,
    maximum: 100,
    default: 20,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number = 20;

  /**
   * Calculate skip value for database queries
   */
  get skip(): number {
    return ((this.page ?? 1) - 1) * (this.limit ?? 20);
  }

  /**
   * Get take value for database queries
   */
  get take(): number {
    return this.limit ?? 20;
  }
}

/**
 * Pagination metadata for paginated responses
 */
export class PaginationMeta {
  /**
   * Current page number (1-based)
   */
  page: number;

  /**
   * Number of items per page
   */
  limit: number;

  /**
   * Total number of items across all pages
   */
  total: number;

  /**
   * Total number of pages
   */
  totalPages: number;

  /**
   * Whether there is a next page
   */
  hasNext: boolean;

  /**
   * Whether there is a previous page
   */
  hasPrev: boolean;

  constructor(page: number, limit: number, total: number) {
    this.page = page;
    this.limit = limit;
    this.total = total;
    this.totalPages = Math.ceil(total / limit);
    this.hasNext = page < this.totalPages;
    this.hasPrev = page > 1;
  }
}

/**
 * Paginated response wrapper
 */
export class PaginatedResponseDto<T> {
  /**
   * Success flag
   */
  success: boolean;

  /**
   * Array of items for the current page
   */
  data: T[];

  /**
   * Pagination metadata
   */
  pagination: PaginationMeta;

  constructor(data: T[], page: number, limit: number, total: number) {
    this.success = true;
    this.data = data;
    this.pagination = new PaginationMeta(page, limit, total);
  }
}
