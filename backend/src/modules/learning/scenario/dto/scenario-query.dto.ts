import { IsOptional, IsEnum } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export enum ScenarioCategory {
  DAILY = 'daily',
  BUSINESS = 'business',
  TRAVEL = 'travel',
  ACADEMIC = 'academic',
  TEST_PREP = 'test_prep',
}

export enum ScenarioDifficulty {
  BEGINNER = 'beginner',
  INTERMEDIATE = 'intermediate',
  ADVANCED = 'advanced',
}

export class ScenarioQueryDto {
  @ApiPropertyOptional({ enum: ScenarioCategory })
  @IsOptional()
  @IsEnum(ScenarioCategory)
  category?: ScenarioCategory;

  @ApiPropertyOptional({ enum: ScenarioDifficulty })
  @IsOptional()
  @IsEnum(ScenarioDifficulty)
  difficulty?: ScenarioDifficulty;
}
