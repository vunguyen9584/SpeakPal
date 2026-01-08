import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { TranslationQuestion, Level, Prisma } from '@prisma/client';

@Injectable()
export class TranslationQuestionRepository {
  private readonly logger = new Logger(TranslationQuestionRepository.name);

  constructor(private readonly prisma: PrismaService) {}

  /**
   * Find a random translation question excluding recently shown ones
   * Uses raw SQL for efficient random selection
   */
  async findRandomQuestion(
    topic: string,
    level: Level,
    excludeIds: string[],
  ): Promise<TranslationQuestion | null> {
    try {
      // Use raw query for RANDOM() selection with exclusions
      const questions = await this.prisma.$queryRaw<TranslationQuestion[]>`
        SELECT * FROM translation_questions
        WHERE topic = ${topic}
          AND level = ${level}
          AND is_active = true
          AND id NOT IN (${Prisma.join(excludeIds.length ? excludeIds : [''])})
        ORDER BY RANDOM()
        LIMIT 1
      `;

      return questions[0] || null;
    } catch (error) {
      this.logger.error(
        `Error finding random question: ${(error as Error).message}`,
      );
      throw error;
    }
  }

  /**
   * Find translation question by ID
   */
  async findById(id: string): Promise<TranslationQuestion | null> {
    return this.prisma.translationQuestion.findUnique({
      where: { id },
    });
  }

  /**
   * Get count of active questions for a topic and level
   */
  async countQuestions(topic: string, level: Level): Promise<number> {
    return this.prisma.translationQuestion.count({
      where: {
        topic,
        level,
        isActive: true,
      },
    });
  }
}
