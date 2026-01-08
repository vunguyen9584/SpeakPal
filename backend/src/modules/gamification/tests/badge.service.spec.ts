import { Test, TestingModule } from '@nestjs/testing';
import { BadgeService } from '../badge/badge.service';
import { PrismaService } from '../../../prisma/prisma.service';

describe('BadgeService', () => {
  let service: BadgeService;
  let prisma: jest.Mocked<PrismaService>;

  const mockBadge = {
    id: 'badge-1',
    code: 'STREAK_7',
    name: '7 Day Streak',
    nameJa: '7日連続',
    description: 'Maintain a 7-day streak',
    category: 'streak',
    xpBonus: 100,
    iconUrl: '/badges/streak_7.png',
    condition: 'currentStreak >= 7',
    createdAt: new Date(),
  };

  const mockUserBadge = {
    id: 'user-badge-1',
    userId: 'user-1',
    badgeId: 'badge-1',
    earnedAt: new Date(),
    badge: mockBadge,
  };

  beforeEach(async () => {
    const mockPrisma = {
      badge: {
        findMany: jest.fn(),
        findUnique: jest.fn(),
      },
      userBadge: {
        findMany: jest.fn(),
        findFirst: jest.fn(),
        create: jest.fn(),
      },
      user: {
        findUnique: jest.fn(),
      },
      conversation: {
        count: jest.fn(),
      },
      vocabulary: {
        count: jest.fn(),
      },
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        BadgeService,
        {
          provide: PrismaService,
          useValue: mockPrisma,
        },
      ],
    }).compile();

    service = module.get<BadgeService>(BadgeService);
    prisma = module.get(PrismaService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('listAll', () => {
    it('should return all badges', async () => {
      const badges = [
        mockBadge,
        { ...mockBadge, id: 'badge-2', code: 'LEVEL_5' },
      ];
      (prisma.badge.findMany as jest.Mock).mockResolvedValue(badges);

      const result = await service.listAll();

      expect(result).toHaveLength(2);
      expect(result[0].code).toBe('STREAK_7');
      expect(result[1].code).toBe('LEVEL_5');
      expect(prisma.badge.findMany).toHaveBeenCalledWith({
        orderBy: { category: 'asc' },
      });
    });

    it('should return empty array when no badges exist', async () => {
      (prisma.badge.findMany as jest.Mock).mockResolvedValue([]);

      const result = await service.listAll();

      expect(result).toHaveLength(0);
    });
  });

  describe('listUserBadges', () => {
    it('should return user earned badges', async () => {
      (prisma.userBadge.findMany as jest.Mock).mockResolvedValue([
        mockUserBadge,
      ]);

      const result = await service.listUserBadges('user-1');

      expect(result).toHaveLength(1);
      expect(result[0].badge.code).toBe('STREAK_7');
      expect(result[0].earnedAt).toBeDefined();
      expect(prisma.userBadge.findMany).toHaveBeenCalledWith({
        where: { userId: 'user-1' },
        include: { badge: true },
        orderBy: { earnedAt: 'desc' },
      });
    });

    it('should return empty array when user has no badges', async () => {
      (prisma.userBadge.findMany as jest.Mock).mockResolvedValue([]);

      const result = await service.listUserBadges('user-1');

      expect(result).toHaveLength(0);
    });
  });

  describe('checkAndAward', () => {
    beforeEach(() => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        id: 'user-1',
        currentStreak: 7,
        level: 5,
      });
      (prisma.conversation.count as jest.Mock).mockResolvedValue(10);
      (prisma.vocabulary.count as jest.Mock).mockResolvedValue(50);
    });

    it('should award badge when condition is met', async () => {
      (prisma.userBadge.findFirst as jest.Mock).mockResolvedValue(null);
      (prisma.badge.findUnique as jest.Mock).mockResolvedValue(mockBadge);
      (prisma.userBadge.create as jest.Mock).mockResolvedValue(mockUserBadge);

      const earnedBadges = await service.checkAndAward('user-1', 'streak');

      expect(earnedBadges.length).toBeGreaterThan(0);
    });

    it('should not award badge if already earned', async () => {
      (prisma.userBadge.findFirst as jest.Mock).mockResolvedValue(
        mockUserBadge,
      );

      const earnedBadges = await service.checkAndAward('user-1', 'streak');

      expect(prisma.userBadge.create).not.toHaveBeenCalled();
    });

    it('should return empty array if user not found', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue(null);

      const earnedBadges = await service.checkAndAward('user-1', 'level');

      expect(earnedBadges).toEqual([]);
    });
  });

  describe('awardBadge', () => {
    it('should award badge to user', async () => {
      (prisma.badge.findUnique as jest.Mock).mockResolvedValue(mockBadge);
      (prisma.userBadge.findFirst as jest.Mock).mockResolvedValue(null);
      (prisma.userBadge.create as jest.Mock).mockResolvedValue(mockUserBadge);

      await service.awardBadge('user-1', 'STREAK_7');

      expect(prisma.userBadge.create).toHaveBeenCalledWith({
        data: {
          userId: 'user-1',
          badgeId: 'badge-1',
        },
      });
    });

    it('should not award duplicate badge', async () => {
      (prisma.badge.findUnique as jest.Mock).mockResolvedValue(mockBadge);
      (prisma.userBadge.findFirst as jest.Mock).mockResolvedValue(
        mockUserBadge,
      );

      await service.awardBadge('user-1', 'STREAK_7');

      expect(prisma.userBadge.create).not.toHaveBeenCalled();
    });

    it('should handle badge not found', async () => {
      (prisma.badge.findUnique as jest.Mock).mockResolvedValue(null);

      await service.awardBadge('user-1', 'INVALID_BADGE');

      expect(prisma.userBadge.create).not.toHaveBeenCalled();
    });
  });

  describe('getProgress', () => {
    it('should calculate progress for streak badge', async () => {
      (prisma.badge.findUnique as jest.Mock).mockResolvedValue({
        ...mockBadge,
        condition: 'currentStreak >= 7',
      });
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        id: 'user-1',
        currentStreak: 5,
        level: 3,
      });
      (prisma.conversation.count as jest.Mock).mockResolvedValue(10);
      (prisma.vocabulary.count as jest.Mock).mockResolvedValue(30);

      const progress = await service.getProgress('user-1', 'STREAK_7');

      expect(progress.current).toBe(5);
      expect(progress.target).toBe(7);
      expect(progress.percent).toBe(71); // 5/7 * 100
    });

    it('should calculate progress for level badge', async () => {
      (prisma.badge.findUnique as jest.Mock).mockResolvedValue({
        ...mockBadge,
        code: 'LEVEL_10',
        condition: 'level >= 10',
      });
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        id: 'user-1',
        currentStreak: 5,
        level: 7,
      });
      (prisma.conversation.count as jest.Mock).mockResolvedValue(10);
      (prisma.vocabulary.count as jest.Mock).mockResolvedValue(30);

      const progress = await service.getProgress('user-1', 'LEVEL_10');

      expect(progress.current).toBe(7);
      expect(progress.target).toBe(10);
      expect(progress.percent).toBe(70);
    });

    it('should calculate progress for conversation badge', async () => {
      (prisma.badge.findUnique as jest.Mock).mockResolvedValue({
        ...mockBadge,
        code: 'CONV_100',
        condition: 'conversationCount >= 100',
      });
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        id: 'user-1',
        currentStreak: 5,
        level: 7,
      });
      (prisma.conversation.count as jest.Mock).mockResolvedValue(50);
      (prisma.vocabulary.count as jest.Mock).mockResolvedValue(30);

      const progress = await service.getProgress('user-1', 'CONV_100');

      expect(progress.current).toBe(50);
      expect(progress.target).toBe(100);
      expect(progress.percent).toBe(50);
    });

    it('should cap progress at 100%', async () => {
      (prisma.badge.findUnique as jest.Mock).mockResolvedValue({
        ...mockBadge,
        condition: 'currentStreak >= 7',
      });
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        id: 'user-1',
        currentStreak: 15,
        level: 3,
      });
      (prisma.conversation.count as jest.Mock).mockResolvedValue(10);
      (prisma.vocabulary.count as jest.Mock).mockResolvedValue(30);

      const progress = await service.getProgress('user-1', 'STREAK_7');

      expect(progress.current).toBe(15);
      expect(progress.percent).toBe(100);
    });

    it('should throw error if badge not found', async () => {
      (prisma.badge.findUnique as jest.Mock).mockResolvedValue(null);

      await expect(service.getProgress('user-1', 'INVALID')).rejects.toThrow(
        'Badge not found',
      );
    });
  });

  describe('Badge Condition Checking', () => {
    beforeEach(() => {
      (prisma.userBadge.findFirst as jest.Mock).mockResolvedValue(null);
      (prisma.badge.findUnique as jest.Mock).mockResolvedValue(mockBadge);
      (prisma.userBadge.create as jest.Mock).mockResolvedValue(mockUserBadge);
    });

    it('should check streak condition correctly', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        id: 'user-1',
        currentStreak: 7,
        level: 1,
      });
      (prisma.conversation.count as jest.Mock).mockResolvedValue(0);
      (prisma.vocabulary.count as jest.Mock).mockResolvedValue(0);

      const earnedBadges = await service.checkAndAward('user-1', 'streak');

      // Should check badges based on streak
      expect(prisma.user.findUnique).toHaveBeenCalled();
    });

    it('should check level condition correctly', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        id: 'user-1',
        currentStreak: 0,
        level: 10,
      });
      (prisma.conversation.count as jest.Mock).mockResolvedValue(0);
      (prisma.vocabulary.count as jest.Mock).mockResolvedValue(0);

      const earnedBadges = await service.checkAndAward('user-1', 'level');

      expect(prisma.user.findUnique).toHaveBeenCalled();
    });

    it('should check conversation count condition correctly', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        id: 'user-1',
        currentStreak: 0,
        level: 1,
      });
      (prisma.conversation.count as jest.Mock).mockResolvedValue(100);
      (prisma.vocabulary.count as jest.Mock).mockResolvedValue(0);

      const earnedBadges = await service.checkAndAward(
        'user-1',
        'conversation',
      );

      expect(prisma.conversation.count).toHaveBeenCalledWith({
        where: { userId: 'user-1' },
      });
    });

    it('should check vocabulary count condition correctly', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        id: 'user-1',
        currentStreak: 0,
        level: 1,
      });
      (prisma.conversation.count as jest.Mock).mockResolvedValue(0);
      (prisma.vocabulary.count as jest.Mock).mockResolvedValue(500);

      const earnedBadges = await service.checkAndAward('user-1', 'vocabulary');

      expect(prisma.vocabulary.count).toHaveBeenCalledWith({
        where: { userId: 'user-1' },
      });
    });
  });

  describe('Integration Scenarios', () => {
    it('should award multiple badges when conditions are met', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        id: 'user-1',
        currentStreak: 30,
        level: 10,
      });
      (prisma.conversation.count as jest.Mock).mockResolvedValue(100);
      (prisma.vocabulary.count as jest.Mock).mockResolvedValue(50);
      (prisma.userBadge.findFirst as jest.Mock).mockResolvedValue(null);
      (prisma.badge.findUnique as jest.Mock).mockResolvedValue(mockBadge);
      (prisma.userBadge.create as jest.Mock).mockResolvedValue(mockUserBadge);

      const earnedBadges = await service.checkAndAward('user-1', 'streak');

      // User with 30 streak should be eligible for multiple streak badges
      expect(prisma.user.findUnique).toHaveBeenCalled();
    });

    it('should prevent duplicate badge awards', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        id: 'user-1',
        currentStreak: 7,
        level: 5,
      });
      (prisma.conversation.count as jest.Mock).mockResolvedValue(10);
      (prisma.vocabulary.count as jest.Mock).mockResolvedValue(50);
      (prisma.userBadge.findFirst as jest.Mock).mockResolvedValue(
        mockUserBadge,
      ); // Already earned
      (prisma.badge.findUnique as jest.Mock).mockResolvedValue(mockBadge);

      const earnedBadges = await service.checkAndAward('user-1', 'streak');

      expect(prisma.userBadge.create).not.toHaveBeenCalled();
    });
  });
});
