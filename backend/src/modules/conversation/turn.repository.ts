import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import {
  ConversationTurn,
  Speaker,
  CorrectionType,
  Severity,
} from '@prisma/client';

export interface Correction {
  type: CorrectionType;
  original: string;
  corrected: string;
  explanation: string;
  severity: Severity;
}

@Injectable()
export class TurnRepository {
  constructor(private prisma: PrismaService) {}

  async addTurn(
    conversationId: string,
    speaker: Speaker,
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

  async getLastTurn(conversationId: string): Promise<ConversationTurn | null> {
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
        corrections: {
          deleteMany: {},
          create: corrections.map((c) => ({
            type: c.type,
            originalText: c.original,
            correctedText: c.corrected,
            explanation: c.explanation,
            severity: c.severity,
          })),
        },
      },
    });
  }

  async getNextSequence(conversationId: string): Promise<number> {
    const lastTurn = await this.getLastTurn(conversationId);
    return lastTurn ? lastTurn.sequence + 1 : 1;
  }
}
