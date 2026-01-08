import { ApiProperty } from '@nestjs/swagger';
import { Scenario } from '@prisma/client';
import { ScenarioCategory, ScenarioDifficulty } from './scenario-query.dto';

export class ScenarioResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  title: string;

  @ApiProperty()
  description: string;

  @ApiProperty({ enum: ScenarioCategory })
  category: ScenarioCategory;

  @ApiProperty({ enum: ScenarioDifficulty })
  difficulty: ScenarioDifficulty;

  @ApiProperty({ description: 'Estimated duration in minutes' })
  estimatedMinutes: number;

  @ApiProperty()
  prompt: string;

  @ApiProperty({ type: [String] })
  suggestedTopics: string[];

  static fromEntity(scenario: Scenario): ScenarioResponseDto {
    const dto = new ScenarioResponseDto();
    dto.id = scenario.id;
    dto.title = scenario.title;
    dto.description = scenario.description;
    dto.category = scenario.category as unknown as ScenarioCategory;
    dto.difficulty = scenario.difficulty as unknown as ScenarioDifficulty;
    dto.estimatedMinutes = scenario.estimatedDurationMinutes;
    dto.prompt =
      ((scenario.initialContext as Record<string, any>)?.prompt as string) ||
      scenario.description;
    dto.suggestedTopics = (scenario.keyPhrases as unknown as string[]) || [];
    return dto;
  }
}
