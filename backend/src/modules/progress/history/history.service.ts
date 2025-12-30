import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';
import {
  HistoryQueryDto,
  HistoryResponseDto,
  HistoryItemDto,
} from '../dto/history-query.dto';

@Injectable()
export class HistoryService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Query learning history with filters and pagination
   */
  async queryHistory(
    userId: string,
    query: HistoryQueryDto,
  ): Promise<HistoryResponseDto> {
    const { startDate, endDate, type, page = 1, limit = 20 } = query;
    const skip = (page - 1) * limit;

    // Build date filter
    const dateFilter = this.buildDateFilter(startDate, endDate);

    // Collect history items from different sources
    const items: HistoryItemDto[] = [];

    // Get conversations if type matches or no type filter
    if (!type || type === 'conversation') {
      const conversations = await this.getConversationHistory(
        userId,
        dateFilter,
      );
      items.push(...conversations);
    }

    // Get vocabulary reviews if type matches or no type filter
    if (!type || type === 'vocabulary_review') {
      const vocabularyReviews = await this.getVocabularyHistory(
        userId,
        dateFilter,
      );
      items.push(...vocabularyReviews);
    }

    // Get challenges if type matches or no type filter
    if (!type || type === 'challenge') {
      const challenges = await this.getChallengeHistory(userId, dateFilter);
      items.push(...challenges);
    }

    // Sort by timestamp desc
    items.sort((a, b) => b.timestamp.getTime() - a.timestamp.getTime());

    // Get total count before pagination
    const total = items.length;

    // Apply pagination
    const paginatedItems = items.slice(skip, skip + limit);

    return {
      data: paginatedItems,
      total,
      page,
      limit,
    };
  }

  /**
   * Get conversation history
   */
  private async getConversationHistory(
    userId: string,
    dateFilter: any,
  ): Promise<HistoryItemDto[]> {
    const conversations = await this.prisma.conversation.findMany({
      where: {
        userId,
        ...dateFilter,
      },
      select: {
        id: true,
        mode: true,
        topic: true,
        durationSeconds: true,
        pronunciationScore: true,
        xpEarned: true,
        startedAt: true,
        endedAt: true,
      },
      orderBy: {
        startedAt: 'desc',
      },
    });

    return conversations.map((conv) => ({
      id: conv.id,
      type: 'conversation',
      timestamp: conv.startedAt,
      duration: conv.durationSeconds || 0,
      xpEarned: conv.xpEarned,
      details: {
        mode: conv.mode,
        topic: conv.topic,
        pronunciationScore: conv.pronunciationScore,
        endedAt: conv.endedAt,
      },
    }));
  }

  /**
   * Get vocabulary review history
   * Note: We track vocab reviews via updatedAt field
   */
  private async getVocabularyHistory(
    userId: string,
    dateFilter: any,
  ): Promise<HistoryItemDto[]> {
    // Map date filter from createdAt to updatedAt
    const vocabDateFilter = dateFilter.createdAt
      ? { updatedAt: dateFilter.createdAt }
      : {};

    const vocabularies = await this.prisma.vocabulary.findMany({
      where: {
        userId,
        reviewCount: {
          gt: 0, // Only include words that have been reviewed
        },
        ...vocabDateFilter,
      },
      select: {
        id: true,
        word: true,
        reviewCount: true,
        srsLevel: true,
        updatedAt: true,
      },
      orderBy: {
        updatedAt: 'desc',
      },
    });

    return vocabularies.map((vocab) => ({
      id: vocab.id,
      type: 'vocabulary_review',
      timestamp: vocab.updatedAt,
      duration: 0, // Reviews don't have duration
      xpEarned: this.calculateVocabXp(vocab.reviewCount),
      details: {
        word: vocab.word,
        reviewCount: vocab.reviewCount,
        srsLevel: vocab.srsLevel,
      },
    }));
  }

  /**
   * Get challenge history
   */
  private async getChallengeHistory(
    userId: string,
    dateFilter: any,
  ): Promise<HistoryItemDto[]> {
    // Map date filter from createdAt to completedAt
    const challengeDateFilter = dateFilter.createdAt
      ? {
          completedAt: {
            ...dateFilter.createdAt,
            not: null,
          },
        }
      : { completedAt: { not: null } };

    const challenges = await this.prisma.userChallenge.findMany({
      where: {
        userId,
        status: 'COMPLETED',
        ...challengeDateFilter,
      },
      select: {
        id: true,
        completedAt: true,
        currentProgress: true,
        challenge: {
          select: {
            type: true,
            title: true,
            description: true,
            xpReward: true,
            targetCount: true,
          },
        },
      },
      orderBy: {
        completedAt: 'desc',
      },
    });

    return challenges
      .filter((ch) => ch.completedAt !== null)
      .map((ch) => ({
        id: ch.id,
        type: 'challenge',
        timestamp: ch.completedAt!,
        duration: 0, // Challenges don't have duration
        xpEarned: ch.challenge.xpReward,
        details: {
          challengeType: ch.challenge.type,
          title: ch.challenge.title,
          description: ch.challenge.description,
          progress: ch.currentProgress,
          targetCount: ch.challenge.targetCount,
        },
      }));
  }

  /**
   * Build date filter for Prisma query
   */
  private buildDateFilter(
    startDate?: string,
    endDate?: string,
  ): { createdAt?: any } {
    if (!startDate && !endDate) {
      return {};
    }

    const filter: any = {};

    if (startDate && endDate) {
      filter.createdAt = {
        gte: new Date(startDate),
        lte: new Date(endDate),
      };
    } else if (startDate) {
      filter.createdAt = {
        gte: new Date(startDate),
      };
    } else if (endDate) {
      filter.createdAt = {
        lte: new Date(endDate),
      };
    }

    return filter;
  }

  /**
   * Calculate XP earned from vocabulary reviews
   * Estimation: 5 XP per review on average
   */
  private calculateVocabXp(reviewCount: number): number {
    return reviewCount * 5;
  }
}
