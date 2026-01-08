import { Injectable, NotFoundException } from '@nestjs/common';
import { ScenarioRepository } from './scenario.repository';
import { ScenarioQueryDto } from './dto/scenario-query.dto';
import { ScenarioResponseDto } from './dto/scenario-response.dto';

@Injectable()
export class ScenarioService {
  constructor(private readonly repository: ScenarioRepository) {}

  async list(query: ScenarioQueryDto): Promise<ScenarioResponseDto[]> {
    const scenarios = await this.repository.findAll(
      query.category,
      query.difficulty,
    );
    return scenarios.map(ScenarioResponseDto.fromEntity);
  }

  async getById(id: string): Promise<ScenarioResponseDto> {
    const scenario = await this.repository.findById(id);
    if (!scenario) {
      throw new NotFoundException('Scenario not found');
    }
    return ScenarioResponseDto.fromEntity(scenario);
  }

  async getByCategory(category: string): Promise<ScenarioResponseDto[]> {
    const scenarios = await this.repository.findByCategory(category);
    return scenarios.map(ScenarioResponseDto.fromEntity);
  }

  async startScenario(
    userId: string,
    scenarioId: string,
  ): Promise<{ conversationContext: any }> {
    const scenario = await this.repository.findById(scenarioId);
    if (!scenario) {
      throw new NotFoundException('Scenario not found');
    }

    // Create conversation context for the scenario
    // This will be used by the ConversationModule
    return {
      conversationContext: {
        scenarioId: scenario.id,
        prompt:
          ((scenario.initialContext as Record<string, any>)
            ?.prompt as string) || scenario.description,
        suggestedTopics: scenario.keyPhrases as unknown as string[],
        estimatedMinutes: scenario.estimatedDurationMinutes,
      },
    };
  }
}
