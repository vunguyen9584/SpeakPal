import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { TranslationQuestion, Level, Prisma } from '@prisma/client';

@Injectable()
export class TranslationQuestionRepository {
  private readonly logger = new Logger(TranslationQuestionRepository.name);

  constructor(private readonly prisma: PrismaService) { }

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
      const where: Prisma.TranslationQuestionWhereInput = {
        topic,
        level,
        isActive: true,
        ...(excludeIds.length > 0 && { id: { notIn: excludeIds } }),
      };

      const count = await this.prisma.translationQuestion.count({ where });

      if (count === 0) {
        return null;
      }

      const skip = Math.floor(Math.random() * count);

      const questions = await this.prisma.translationQuestion.findMany({
        where,
        take: 1,
        skip,
      });

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
