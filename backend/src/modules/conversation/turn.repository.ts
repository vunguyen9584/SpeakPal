import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../common/services/prisma.service';
import { ConversationTurn, TurnSpeaker } from '@prisma/client';

export interface Correction {
  type: string;
  original: string;
  corrected: string;
  explanation: string;
  severity: string;
}

@Injectable()
export class TurnRepository {
  constructor(private prisma: PrismaService) {}

  async addTurn(
    conversationId: string,
    speaker: TurnSpeaker,
    content: string,
    sequence: number,
  ): Promise<ConversationTurn> {
    return this.prisma.conversationTurn.create({
      data: {
        conversationId,
        speaker,
        content,
        sequence,
      },
    });
  }

  async getTurns(conversationId: string): Promise<ConversationTurn[]> {
    return this.prisma.conversationTurn.findMany({
      where: { conversationId },
      orderBy: { sequence: 'asc' },
    });
  }

  async getLastTurn(
    conversationId: string,
  ): Promise<ConversationTurn | null> {
    return this.prisma.conversationTurn.findFirst({
      where: { conversationId },
      orderBy: { sequence: 'desc' },
    });
  }

  async attachCorrections(
    turnId: string,
    corrections: Correction[],
  ): Promise<void> {
    await this.prisma.conversationTurn.update({
      where: { id: turnId },
      data: {
        corrections: corrections as any, // JSONB field
      },
    });
  }

  async getNextSequence(conversationId: string): Promise<number> {
    const lastTurn = await this.getLastTurn(conversationId);
    return lastTurn ? lastTurn.sequence + 1 : 1;
  }
}
