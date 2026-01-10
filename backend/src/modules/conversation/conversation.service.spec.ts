import { Test, TestingModule } from '@nestjs/testing';
import { ConversationService } from './conversation.service';
import { ConversationRepository } from './conversation.repository';
import { JwtService } from '@nestjs/jwt';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import { ConfigService } from '@nestjs/config';
import { ConversationMode } from '@prisma/client';
import { ForbiddenException, NotFoundException } from '@nestjs/common';

describe('ConversationService', () => {
  let service: ConversationService;
  let repo: jest.Mocked<ConversationRepository>;
  let jwt: jest.Mocked<JwtService>;
  let cache: jest.Mocked<any>;

  const mockDate = new Date();
  const mockConversation = {
    id: 'convo-123',
    userId: 'user-123',
    mode: ConversationMode.FREE_TALK,
    status: 'active',
    startedAt: mockDate,
    topic: 'test topic'
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ConversationService,
        {
          provide: ConversationRepository,
          useValue: {
            create: jest.fn(),
            findById: jest.fn(),
            countTodayConversations: jest.fn(),
            updateEndData: jest.fn(),
            findByUser: jest.fn()
          }
        },
        {
          provide: JwtService,
          useValue: {
            sign: jest.fn()
          }
        },
        {
          provide: CACHE_MANAGER,
          useValue: {
            set: jest.fn(),
            get: jest.fn(),
            del: jest.fn()
          }
        },
        {
          provide: ConfigService,
          useValue: {
            get: jest.fn((key) => {
              if (key === 'WS_JWT_SECRET') return 'secret';
              if (key === 'WEBSOCKET_URL') return 'ws://localhost';
              return null;
            })
          }
        }
      ]
    }).compile();

    service = module.get<ConversationService>(ConversationService);
    repo = module.get(ConversationRepository);
    jwt = module.get(JwtService);
    cache = module.get(CACHE_MANAGER);
  });

  describe('createSession', () => {
    const dto = { mode: ConversationMode.FREE_TALK, topic: 'test' };

    it('should create session successfully for premium user', async () => {
      repo.create.mockResolvedValue(mockConversation as any);
      jwt.sign.mockReturnValue('ws-token');

      const result = await service.createSession('user-123', dto, 'premium');

      expect(result).toBeDefined();
      expect(result.token).toBe('ws-token');
      expect(repo.create).toHaveBeenCalled();
      expect(cache.set).toHaveBeenCalled();
    });

    it('should enforce limit for free user', async () => {
      repo.countTodayConversations.mockResolvedValue(3);

      await expect(service.createSession('user-123', dto, 'free'))
        .rejects.toThrow(ForbiddenException);
    });

    it('should allow free user below limit', async () => {
      repo.countTodayConversations.mockResolvedValue(2);
      repo.create.mockResolvedValue(mockConversation as any);
      jwt.sign.mockReturnValue('ws-token');

      const result = await service.createSession('user-123', dto, 'free');

      expect(result).toBeDefined();
    });
  });

  describe('endSession', () => {
    it('should end session successfully', async () => {
      repo.findById.mockResolvedValue(mockConversation as any);
      repo.updateEndData.mockResolvedValue({ ...mockConversation, endedAt: new Date() } as any);

      await service.endSession('user-123', 'convo-123');

      expect(repo.updateEndData).toHaveBeenCalled();
      expect(cache.del).toHaveBeenCalled();
    });

    it('should throw NotFound if convo not found', async () => {
      repo.findById.mockResolvedValue(null);
      await expect(service.endSession('user-123', 'convo-123'))
        .rejects.toThrow(NotFoundException);
    });

    it('should throw Forbidden if user mismatch', async () => {
      repo.findById.mockResolvedValue({ ...mockConversation, userId: 'other' } as any);
      await expect(service.endSession('user-123', 'convo-123'))
        .rejects.toThrow(ForbiddenException);
    });
  });
});
