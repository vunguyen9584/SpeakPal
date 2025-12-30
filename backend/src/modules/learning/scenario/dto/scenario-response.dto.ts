import { ApiProperty } from '@nestjs/swagger';
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

  static fromEntity(scenario: any): ScenarioResponseDto {
    const dto = new ScenarioResponseDto();
    dto.id = scenario.id;
    dto.title = scenario.title;
    dto.description = scenario.description;
    dto.category = scenario.category;
    dto.difficulty = scenario.difficulty;
    dto.estimatedMinutes = scenario.estimatedMinutes;
    dto.prompt = scenario.prompt;
    dto.suggestedTopics = scenario.suggestedTopics || [];
    return dto;
  }
}
