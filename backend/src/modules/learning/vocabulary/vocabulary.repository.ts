import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';
import { Vocabulary, SrsLevel, Prisma } from '@prisma/client';
import { VocabularyQueryDto } from './dto/vocabulary-query.dto';
import { CreateVocabularyDto } from './dto/create-vocabulary.dto';

@Injectable()
export class VocabularyRepository {
  constructor(private prisma: PrismaService) {}

  async create(userId: string, dto: CreateVocabularyDto): Promise<Vocabulary> {
    return this.prisma.vocabulary.create({
      data: {
        userId,
        word: dto.word,
        meaning: dto.meaning,
        pronunciation: dto.pronunciation || '',
        exampleSentence: dto.exampleSentence,
        conversationId: dto.conversationId,
        srsLevel: SrsLevel.NEW,
        nextReviewDate: new Date(),
        reviewCount: 0,
        correctCount: 0,
      },
    });
  }

  async findByUser(
    userId: string,
    query: VocabularyQueryDto,
  ): Promise<{ data: Vocabulary[]; total: number }> {
    const { page = 1, limit = 20, srsLevel, search } = query;
    const skip = (page - 1) * limit;

    const where: Prisma.VocabularyWhereInput = {
      userId,
      ...(srsLevel && { srsLevel: srsLevel }),
      ...(search && {
        word: {
          contains: search,
          mode: 'insensitive' as Prisma.QueryMode,
        },
      }),
    };

    const [data, total] = await Promise.all([
      this.prisma.vocabulary.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.vocabulary.count({ where }),
    ]);

    return { data, total };
  }

  async findById(id: string): Promise<Vocabulary | null> {
    return this.prisma.vocabulary.findUnique({
      where: { id },
    });
  }

  async findDueForReview(userId: string): Promise<Vocabulary[]> {
    return this.prisma.vocabulary.findMany({
      where: {
        userId,
        nextReviewDate: {
          lte: new Date(),
        },
      },
      orderBy: { nextReviewDate: 'asc' },
    });
  }

  async updateAfterReview(
    id: string,
    newLevel: SrsLevel,
    nextDate: Date,
  ): Promise<Vocabulary> {
    return this.prisma.vocabulary.update({
      where: { id },
      data: {
        srsLevel: newLevel,
        nextReviewDate: nextDate,
        reviewCount: {
          increment: 1,
        },
        correctCount: {
          increment: newLevel !== SrsLevel.LEARNING ? 1 : 0,
        },
      },
    });
  }

  async checkDuplicate(userId: string, word: string): Promise<boolean> {
    const existing = await this.prisma.vocabulary.findFirst({
      where: {
        userId,
        word: {
          equals: word,
          mode: 'insensitive' as Prisma.QueryMode,
        },
      },
    });
    return !!existing;
  }

  async countByUser(userId: string): Promise<number> {
    return this.prisma.vocabulary.count({
      where: { userId },
    });
  }

  async delete(id: string): Promise<void> {
    await this.prisma.vocabulary.delete({
      where: { id },
    });
  }
}
