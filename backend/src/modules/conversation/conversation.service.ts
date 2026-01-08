import {
  Injectable,
  ForbiddenException,
  NotFoundException,
  Inject,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import type { Cache } from 'cache-manager';
import { ConversationRepository } from './conversation.repository';
import { CreateConversationDto } from './dto/create-conversation.dto';
import { ConversationResponseDto } from './dto/conversation-response.dto';
import { Conversation } from '@prisma/client';
import { ConfigService } from '@nestjs/config';

const USAGE_LIMIT_FREE = 3; // 3 conversations per day for free users
const SESSION_TTL = 30 * 60; // 30 minutes in seconds
const WS_TOKEN_EXPIRY = '1h';

@Injectable()
export class ConversationService {
  constructor(
    private readonly conversationRepo: ConversationRepository,
    private readonly jwtService: JwtService,
    @Inject(CACHE_MANAGER) private readonly cacheManager: Cache,
    private readonly configService: ConfigService,
  ) {}

  async createSession(
    userId: string,
    dto: CreateConversationDto,
    userPlan: string = 'free',
  ): Promise<ConversationResponseDto> {
    // Check usage limit for free users
    if (userPlan === 'free') {
      const todayCount =
        await this.conversationRepo.countTodayConversations(userId);
      if (todayCount >= USAGE_LIMIT_FREE) {
        throw new ForbiddenException(
          `Daily conversation limit reached(${USAGE_LIMIT_FREE} / day).Upgrade to Premium for unlimited conversations.`,
        );
      }
    }

    // Create conversation
    const conversation = await this.conversationRepo.create(userId, dto);

    // Generate short-lived WebSocket token
    const wsToken = this.jwtService.sign(
      {
        userId,
        conversationId: conversation.id,
        type: 'websocket',
      },
      {
        secret: this.configService.get('WS_JWT_SECRET'),
        expiresIn: WS_TOKEN_EXPIRY,
      },
    );

    // Cache active session in Redis
    await this.cacheSession(conversation.id, {
      userId,
      conversationId: conversation.id,
      startedAt: conversation.startedAt,
      mode: conversation.mode,
    });

    // Build WebSocket URL
    const wsUrl = `${this.configService.get('WEBSOCKET_URL')}/conversation`;

    return new ConversationResponseDto({
      id: conversation.id,
      mode: conversation.mode,
      status: conversation.endedAt ? 'ended' : 'active', // Inferred from endedAt
      websocketUrl: wsUrl,
      token: wsToken,
      // persona: undefined, // TODO: Add persona relation to Conversation model
      topic: conversation.topic,
      startedAt: conversation.startedAt,
    });
  }

  async getActiveSession(conversationId: string): Promise<any> {
    const session = await this.cacheManager.get(`session:${conversationId}`);
    if (!session) {
      throw new NotFoundException('Session not found or expired');
    }
    return session;
  }

  async endSession(
    userId: string,
    conversationId: string,
    summary?: string,
    score?: number,
  ): Promise<Conversation> {
    // Verify ownership
    const conversation = await this.conversationRepo.findById(conversationId);
    if (!conversation) {
      throw new NotFoundException('Conversation not found');
    }
    if (conversation.userId !== userId) {
      throw new ForbiddenException('Not authorized to end this conversation');
    }

    // Update conversation with end data
    const updated = await this.conversationRepo.updateEndData(
      conversationId,
      summary || '',
      score || 0,
    );

    // Clear cache
    await this.clearSession(conversationId);

    return updated;
  }

  private async cacheSession(
    conversationId: string,
    sessionData: any,
  ): Promise<void> {
    await this.cacheManager.set(
      `session:${conversationId}`,
      sessionData,
      SESSION_TTL * 1000, // Convert to milliseconds
    );
  }

  private async clearSession(conversationId: string): Promise<void> {
    await this.cacheManager.del(`session:${conversationId}`);
  }

  async listConversations(userId: string, query: any): Promise<any> {
    return this.conversationRepo.findByUser(userId, {
      page: query.page || 1,
      limit: query.limit || 10,
      mode: query.mode,
    });
  }

  async getConversation(
    userId: string,
    conversationId: string,
  ): Promise<Conversation> {
    const conversation = await this.conversationRepo.findById(conversationId);
    if (!conversation) {
      throw new NotFoundException('Conversation not found');
    }
    if (conversation.userId !== userId) {
      throw new ForbiddenException(
        'Not authorized to access this conversation',
      );
    }
    return conversation;
  }
}
