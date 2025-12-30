import { Test, TestingModule } from '@nestjs/testing';
import { HistoryService } from './history.service';
import { PrismaService } from '../../../prisma/prisma.service';
import { HistoryQueryDto } from '../dto/history-query.dto';

describe('HistoryService', () => {
  let service: HistoryService;
  let prisma: jest.Mocked<PrismaService>;

  const mockConversation = {
    id: 'conv-1',
    mode: 'FREETALK',
    topic: 'Daily Life',
    durationSeconds: 300,
    pronunciationScore: 85,
    xpEarned: 50,
    startedAt: new Date('2024-01-15T10:00:00Z'),
    endedAt: new Date('2024-01-15T10:05:00Z'),
  };

  const mockVocabulary = {
    id: 'vocab-1',
    word: 'hello',
    reviewCount: 5,
    srsLevel: 'MATURE',
    updatedAt: new Date('2024-01-14T09:00:00Z'),
  };

  const mockChallenge = {
    id: 'uc-1',
    completedAt: new Date('2024-01-13T08:00:00Z'),
    currentProgress: 10,
    challenge: {
      type: 'CONVERSATION',
      title: 'Chat Master',
      description: 'Complete 10 conversations',
      xpReward: 100,
      targetCount: 10,
    },
  };

  beforeEach(async () => {
    const mockPrisma = {
      conversation: {
        findMany: jest.fn(),
      },
      vocabulary: {
        findMany: jest.fn(),
      },
      userChallenge: {
        findMany: jest.fn(),
      },
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        HistoryService,
        {
          provide: PrismaService,
          useValue: mockPrisma,
        },
      ],
    }).compile();

    service = module.get<HistoryService>(HistoryService);
    prisma = module.get(PrismaService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('queryHistory', () => {
    it('should return all activity types when no filter specified', async () => {
      (prisma.conversation.findMany as jest.Mock).mockResolvedValue([mockConversation]);
      (prisma.vocabulary.findMany as jest.Mock).mockResolvedValue([mockVocabulary]);
      (prisma.userChallenge.findMany as jest.Mock).mockResolvedValue([mockChallenge]);

      const query: HistoryQueryDto = {};
      const result = await service.queryHistory('user-1', query);

      expect(result.data).toHaveLength(3);
      expect(result.total).toBe(3);
      expect(result.data.some(item => item.type === 'conversation')).toBe(true);
      expect(result.data.some(item => item.type === 'vocabulary_review')).toBe(true);
      expect(result.data.some(item => item.type === 'challenge')).toBe(true);
    });

    it('should filter by conversation type only', async () => {
      (prisma.conversation.findMany as jest.Mock).mockResolvedValue([mockConversation]);
      (prisma.vocabulary.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.userChallenge.findMany as jest.Mock).mockResolvedValue([]);

      const query: HistoryQueryDto = { type: 'conversation' };
      const result = await service.queryHistory('user-1', query);

      expect(result.data).toHaveLength(1);
      expect(result.data[0].type).toBe('conversation');
      expect(prisma.vocabulary.findMany).not.toHaveBeenCalled();
      expect(prisma.userChallenge.findMany).not.toHaveBeenCalled();
    });

    it('should filter by vocabulary_review type only', async () => {
      (prisma.conversation.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.vocabulary.findMany as jest.Mock).mockResolvedValue([mockVocabulary]);
      (prisma.userChallenge.findMany as jest.Mock).mockResolvedValue([]);

      const query: HistoryQueryDto = { type: 'vocabulary_review' };
      const result = await service.queryHistory('user-1', query);

      expect(result.data).toHaveLength(1);
      expect(result.data[0].type).toBe('vocabulary_review');
      expect(prisma.conversation.findMany).not.toHaveBeenCalled();
      expect(prisma.userChallenge.findMany).not.toHaveBeenCalled();
    });

    it('should filter by challenge type only', async () => {
      (prisma.conversation.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.vocabulary.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.userChallenge.findMany as jest.Mock).mockResolvedValue([mockChallenge]);

      const query: HistoryQueryDto = { type: 'challenge' };
      const result = await service.queryHistory('user-1', query);

      expect(result.data).toHaveLength(1);
      expect(result.data[0].type).toBe('challenge');
      expect(prisma.conversation.findMany).not.toHaveBeenCalled();
      expect(prisma.vocabulary.findMany).not.toHaveBeenCalled();
    });

    it('should sort items by timestamp descending', async () => {
      const oldConv = { ...mockConversation, startedAt: new Date('2024-01-10T10:00:00Z') };
      const newConv = { ...mockConversation, id: 'conv-2', startedAt: new Date('2024-01-20T10:00:00Z') };

      (prisma.conversation.findMany as jest.Mock).mockResolvedValue([oldConv, newConv]);
      (prisma.vocabulary.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.userChallenge.findMany as jest.Mock).mockResolvedValue([]);

      const query: HistoryQueryDto = {};
      const result = await service.queryHistory('user-1', query);

      expect(result.data[0].timestamp).toEqual(newConv.startedAt);
      expect(result.data[1].timestamp).toEqual(oldConv.startedAt);
    });
  });

  describe('Pagination', () => {
    it('should apply default pagination (page=1, limit=20)', async () => {
      const conversations = Array.from({ length: 30 }, (_, i) => ({
        ...mockConversation,
        id: `conv-${i}`,
      }));

      (prisma.conversation.findMany as jest.Mock).mockResolvedValue(conversations);
      (prisma.vocabulary.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.userChallenge.findMany as jest.Mock).mockResolvedValue([]);

      const query: HistoryQueryDto = {};
      const result = await service.queryHistory('user-1', query);

      expect(result.data).toHaveLength(20);
      expect(result.total).toBe(30);
      expect(result.page).toBe(1);
      expect(result.limit).toBe(20);
    });

    it('should apply custom pagination', async () => {
      const conversations = Array.from({ length: 50 }, (_, i) => ({
        ...mockConversation,
        id: `conv-${i}`,
      }));

      (prisma.conversation.findMany as jest.Mock).mockResolvedValue(conversations);
      (prisma.vocabulary.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.userChallenge.findMany as jest.Mock).mockResolvedValue([]);

      const query: HistoryQueryDto = { page: 2, limit: 10 };
      const result = await service.queryHistory('user-1', query);

      expect(result.data).toHaveLength(10);
      expect(result.page).toBe(2);
      expect(result.limit).toBe(10);
    });

    it('should handle last page with fewer items', async () => {
      const conversations = Array.from({ length: 25 }, (_, i) => ({
        ...mockConversation,
        id: `conv-${i}`,
      }));

      (prisma.conversation.findMany as jest.Mock).mockResolvedValue(conversations);
      (prisma.vocabulary.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.userChallenge.findMany as jest.Mock).mockResolvedValue([]);

      const query: HistoryQueryDto = { page: 3, limit: 10 };
      const result = await service.queryHistory('user-1', query);

      expect(result.data).toHaveLength(5); // 25 total, page 3 with limit 10 = 5 items
      expect(result.total).toBe(25);
    });

    it('should handle empty page', async () => {
      (prisma.conversation.findMany as jest.Mock).mockResolvedValue([mockConversation]);
      (prisma.vocabulary.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.userChallenge.findMany as jest.Mock).mockResolvedValue([]);

      const query: HistoryQueryDto = { page: 10, limit: 20 };
      const result = await service.queryHistory('user-1', query);

      expect(result.data).toHaveLength(0);
      expect(result.total).toBe(1);
    });
  });

  describe('Date Filtering', () => {
    it('should filter by start date only', async () => {
      (prisma.conversation.findMany as jest.Mock).mockResolvedValue([mockConversation]);
      (prisma.vocabulary.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.userChallenge.findMany as jest.Mock).mockResolvedValue([]);

      const query: HistoryQueryDto = { startDate: '2024-01-01' };
      await service.queryHistory('user-1', query);

      expect(prisma.conversation.findMany).toHaveBeenCalledWith(
        expect.objectContaining({
          where: expect.objectContaining({
            createdAt: expect.objectContaining({
              gte: new Date('2024-01-01'),
            }),
          }),
        }),
      );
    });

    it('should filter by end date only', async () => {
      (prisma.conversation.findMany as jest.Mock).mockResolvedValue([mockConversation]);
      (prisma.vocabulary.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.userChallenge.findMany as jest.Mock).mockResolvedValue([]);

      const query: HistoryQueryDto = { endDate: '2024-01-31' };
      await service.queryHistory('user-1', query);

      expect(prisma.conversation.findMany).toHaveBeenCalledWith(
        expect.objectContaining({
          where: expect.objectContaining({
            createdAt: expect.objectContaining({
              lte: new Date('2024-01-31'),
            }),
          }),
        }),
      );
    });

    it('should filter by date range', async () => {
      (prisma.conversation.findMany as jest.Mock).mockResolvedValue([mockConversation]);
      (prisma.vocabulary.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.userChallenge.findMany as jest.Mock).mockResolvedValue([]);

      const query: HistoryQueryDto = { startDate: '2024-01-01', endDate: '2024-01-31' };
      await service.queryHistory('user-1', query);

      expect(prisma.conversation.findMany).toHaveBeenCalledWith(
        expect.objectContaining({
          where: expect.objectContaining({
            createdAt: expect.objectContaining({
              gte: new Date('2024-01-01'),
              lte: new Date('2024-01-31'),
            }),
          }),
        }),
      );
    });
  });

  describe('Activity Details', () => {
    it('should include conversation details', async () => {
      (prisma.conversation.findMany as jest.Mock).mockResolvedValue([mockConversation]);
      (prisma.vocabulary.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.userChallenge.findMany as jest.Mock).mockResolvedValue([]);

      const query: HistoryQueryDto = { type: 'conversation' };
      const result = await service.queryHistory('user-1', query);

      expect(result.data[0].details).toMatchObject({
        mode: 'FREETALK',
        topic: 'Daily Life',
        pronunciationScore: 85,
      });
      expect(result.data[0].duration).toBe(300);
      expect(result.data[0].xpEarned).toBe(50);
    });

    it('should include vocabulary details', async () => {
      (prisma.conversation.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.vocabulary.findMany as jest.Mock).mockResolvedValue([mockVocabulary]);
      (prisma.userChallenge.findMany as jest.Mock).mockResolvedValue([]);

      const query: HistoryQueryDto = { type: 'vocabulary_review' };
      const result = await service.queryHistory('user-1', query);

      expect(result.data[0].details).toMatchObject({
        word: 'hello',
        reviewCount: 5,
        srsLevel: 'MATURE',
      });
      expect(result.data[0].xpEarned).toBe(25); // 5 reviews * 5 XP
    });

    it('should include challenge details', async () => {
      (prisma.conversation.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.vocabulary.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.userChallenge.findMany as jest.Mock).mockResolvedValue([mockChallenge]);

      const query: HistoryQueryDto = { type: 'challenge' };
      const result = await service.queryHistory('user-1', query);

      expect(result.data[0].details).toMatchObject({
        challengeType: 'CONVERSATION',
        title: 'Chat Master',
        description: 'Complete 10 conversations',
        progress: 10,
        targetCount: 10,
      });
      expect(result.data[0].xpEarned).toBe(100);
    });
  });

  describe('Edge Cases', () => {
    it('should handle empty results', async () => {
      (prisma.conversation.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.vocabulary.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.userChallenge.findMany as jest.Mock).mockResolvedValue([]);

      const query: HistoryQueryDto = {};
      const result = await service.queryHistory('user-1', query);

      expect(result.data).toHaveLength(0);
      expect(result.total).toBe(0);
    });

    it('should handle missing optional fields', async () => {
      const minimalConv = {
        id: 'conv-1',
        mode: 'FREETALK',
        topic: null,
        durationSeconds: null,
        pronunciationScore: null,
        xpEarned: 0,
        startedAt: new Date('2024-01-15T10:00:00Z'),
        endedAt: null,
      };

      (prisma.conversation.findMany as jest.Mock).mockResolvedValue([minimalConv]);
      (prisma.vocabulary.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.userChallenge.findMany as jest.Mock).mockResolvedValue([]);

      const query: HistoryQueryDto = {};
      const result = await service.queryHistory('user-1', query);

      expect(result.data[0].duration).toBe(0);
      expect(result.data[0].details.topic).toBeNull();
    });

    it('should filter out challenges without completedAt', async () => {
      const incompleteChallenge = {
        ...mockChallenge,
        completedAt: null,
      };

      (prisma.conversation.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.vocabulary.findMany as jest.Mock).mockResolvedValue([]);
      (prisma.userChallenge.findMany as jest.Mock).mockResolvedValue([incompleteChallenge]);

      const query: HistoryQueryDto = {};
      const result = await service.queryHistory('user-1', query);

      expect(result.data).toHaveLength(0);
    });
  });
});
