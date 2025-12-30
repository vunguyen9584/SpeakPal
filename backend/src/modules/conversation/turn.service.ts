import { Injectable, NotFoundException } from '@nestjs/common';
import { TurnRepository, Correction } from './turn.repository';
import { ConversationTurn, TurnSpeaker } from '@prisma/client';

@Injectable()
export class TurnService {
  constructor(private readonly turnRepo: TurnRepository) {}

  async addUserTurn(
    conversationId: string,
    text: string,
  ): Promise<ConversationTurn> {
    const sequence = await this.turnRepo.getNextSequence(conversationId);
    return this.turnRepo.addTurn(conversationId, 'user', text, sequence);
  }

  async addAITurn(
    conversationId: string,
    text: string,
  ): Promise<ConversationTurn> {
    const sequence = await this.turnRepo.getNextSequence(conversationId);
    return this.turnRepo.addTurn(conversationId, 'ai', text, sequence);
  }

  async attachCorrections(
    turnId: string,
    corrections: Correction[],
  ): Promise<void> {
    await this.turnRepo.attachCorrections(turnId, corrections);
  }

  async getTurns(conversationId: string): Promise<ConversationTurn[]> {
    return this.turnRepo.getTurns(conversationId);
  }

  async getLastTurn(
    conversationId: string,
  ): Promise<ConversationTurn | null> {
    return this.turnRepo.getLastTurn(conversationId);
  }
}
