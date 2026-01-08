import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { IntentQuestion, Level, Prisma } from '@prisma/client';

@Injectable()
export class IntentQuestionRepository {
  private readonly logger = new Logger(IntentQuestionRepository.name);

  constructor(private readonly prisma: PrismaService) {}

  /**
   * Find a random intent question by category and level
   */
  async findRandomQuestion(
    category: string,
    level: Level,
    excludeIds: string[] = [],
  ): Promise<IntentQuestion | null> {
    try {
      const questions = await this.prisma.$queryRaw<IntentQuestion[]>`
        SELECT * FROM intent_questions
        WHERE category = ${category}
          AND level = ${level}
          AND is_active = true
          AND id NOT IN (${Prisma.join(excludeIds.length ? excludeIds : [''])})
        ORDER BY RANDOM()
        LIMIT 1
      `;

      return questions[0] || null;
    } catch (error) {
      this.logger.error(
        `Error finding random intent question: ${error.message}`,
      );
      throw error;
    }
  }

  /**
   * Find intent question by ID
   */
  async findById(id: string): Promise<IntentQuestion | null> {
    return this.prisma.intentQuestion.findUnique({
      where: { id },
    });
  }

  /**
   * Get count of active intent questions
   */
  async countQuestions(category: string, level: Level): Promise<number> {
    return this.prisma.intentQuestion.count({
      where: {
        category,
        level,
        isActive: true,
      },
    });
  }
}
