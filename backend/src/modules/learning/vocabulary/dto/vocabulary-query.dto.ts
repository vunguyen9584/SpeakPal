import { IsOptional, IsEnum, IsInt, Min } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { SRSLevel } from '@prisma/client';

export class VocabularyQueryDto {
  @ApiPropertyOptional({ minimum: 1, default: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number = 1;

  @ApiPropertyOptional({ minimum: 1, default: 20, maximum: 100 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  limit?: number = 20;

  @ApiPropertyOptional({ enum: SRSLevel })
  @IsOptional()
  @IsEnum(SRSLevel)
  srsLevel?: SRSLevel;

  @ApiPropertyOptional({ description: 'Search by word' })
  @IsOptional()
  search?: string;
}
