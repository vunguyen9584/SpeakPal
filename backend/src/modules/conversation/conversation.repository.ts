import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../common/services/prisma.service';
import { Conversation, ConversationMode } from '@prisma/client';
import { CreateConversationDto } from './dto/create-conversation.dto';

export interface ListQuery {
  page: number;
  limit: number;
  mode?: ConversationMode;
}

export interface PaginatedResult<T> {
  data: T[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

@Injectable()
export class ConversationRepository {
  constructor(private prisma: PrismaService) {}

  async create(
    userId: string,
    dto: CreateConversationDto,
  ): Promise<Conversation> {
    return this.prisma.conversation.create({
      data: {
        userId,
        mode: dto.mode,
        personaId: dto.personaId,
        scenarioId: dto.scenarioId,
        topic: dto.topic,
        status: 'active',
      },
    });
  }

  async findById(id: string): Promise<Conversation | null> {
    return this.prisma.conversation.findUnique({
      where: { id },
      include: {
        persona: true,
        scenario: true,
      },
    });
  }

  async findByUser(
    userId: string,
    query: ListQuery,
  ): Promise<PaginatedResult<Conversation>> {
    const where: any = { userId };
    if (query.mode) {
      where.mode = query.mode;
    }

    const [data, total] = await Promise.all([
      this.prisma.conversation.findMany({
        where,
        orderBy: { startedAt: 'desc' },
        skip: (query.page - 1) * query.limit,
        take: query.limit,
        include: {
          persona: true,
          scenario: true,
        },
      }),
      this.prisma.conversation.count({ where }),
    ]);

    return {
      data,
      total,
      page: query.page,
      limit: query.limit,
      totalPages: Math.ceil(total / query.limit),
    };
  }

  async updateEndData(
    id: string,
    summary: string,
    score: number,
  ): Promise<Conversation> {
    return this.prisma.conversation.update({
      where: { id },
      data: {
        endedAt: new Date(),
        status: 'completed',
        summary,
        pronunciationScore: score,
      },
    });
  }

  async countTodayConversations(userId: string): Promise<number> {
    const startOfDay = new Date();
    startOfDay.setHours(0, 0, 0, 0);

    return this.prisma.conversation.count({
      where: {
        userId,
        startedAt: {
          gte: startOfDay,
        },
      },
    });
  }
}
