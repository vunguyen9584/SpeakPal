import { ApiProperty } from '@nestjs/swagger';

/**
 * Base DTO with common fields (id, timestamps)
 *
 * All entity response DTOs should extend this class
 */
export abstract class BaseDto {
  @ApiProperty({
    description: 'Unique identifier (UUID)',
    example: '123e4567-e89b-12d3-a456-426614174000',
  })
  id: string;

  @ApiProperty({
    description: 'Record creation timestamp (ISO 8601)',
    example: '2025-12-29T12:00:00Z',
  })
  createdAt: Date;

  @ApiProperty({
    description: 'Record last update timestamp (ISO 8601)',
    example: '2025-12-29T13:30:00Z',
  })
  updatedAt: Date;
}
