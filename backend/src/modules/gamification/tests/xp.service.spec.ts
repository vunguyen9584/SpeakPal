import { Test, TestingModule } from '@nestjs/testing';
import { XpService } from '../xp/xp.service';
import { PrismaService } from '../../../prisma/prisma.service';

describe('XpService', () => {
  let service: XpService;
  let prisma: jest.Mocked<PrismaService>;

  const mockUser = {
    id: 'user-1',
    email: 'test@example.com',
    username: 'testuser',
    totalXp: 0,
    level: 1,
    currentStreak: 0,
    longestStreak: 0,
    streakFreezeCount: 0,
    lastActivityDate: null,
  };

  beforeEach(async () => {
    const mockPrisma = {
      user: {
        findUnique: jest.fn(),
        update: jest.fn(),
      },
      xPHistory: {
        create: jest.fn(),
      },
      weeklyStats: {
        findFirst: jest.fn(),
        update: jest.fn(),
        create: jest.fn(),
      },
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        XpService,
        {
          provide: PrismaService,
          useValue: mockPrisma,
        },
      ],
    }).compile();

    service = module.get<XpService>(XpService);
    prisma = module.get(PrismaService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('calculateLevel', () => {
    it('should return level 1 for 0-199 XP', () => {
      expect(service.calculateLevel(0)).toBe(1);
      expect(service.calculateLevel(100)).toBe(1);
      expect(service.calculateLevel(199)).toBe(1);
    });

    it('should return level 2 for 200-399 XP', () => {
      expect(service.calculateLevel(200)).toBe(2);
      expect(service.calculateLevel(300)).toBe(2);
      expect(service.calculateLevel(399)).toBe(2);
    });

    it('should return level 5 for 800-999 XP', () => {
      expect(service.calculateLevel(800)).toBe(5);
      expect(service.calculateLevel(900)).toBe(5);
      expect(service.calculateLevel(999)).toBe(5);
    });

    it('should return level 10 for 1800-1999 XP', () => {
      expect(service.calculateLevel(1800)).toBe(10);
      expect(service.calculateLevel(1900)).toBe(10);
      expect(service.calculateLevel(1999)).toBe(10);
    });

    it('should handle large XP values', () => {
      expect(service.calculateLevel(10000)).toBe(51);
    });
  });

  describe('xpForNextLevel', () => {
    it('should return 200 XP for level 1', () => {
      expect(service.xpForNextLevel(1)).toBe(200);
    });

    it('should return 400 XP for level 2', () => {
      expect(service.xpForNextLevel(2)).toBe(400);
    });

    it('should return 1000 XP for level 5', () => {
      expect(service.xpForNextLevel(5)).toBe(1000);
    });

    it('should return 2000 XP for level 10', () => {
      expect(service.xpForNextLevel(10)).toBe(2000);
    });
  });

  describe('progressToNextLevel', () => {
    it('should return 0% at start of level', () => {
      expect(service.progressToNextLevel(0)).toBe(0);
      expect(service.progressToNextLevel(200)).toBe(0);
      expect(service.progressToNextLevel(400)).toBe(0);
    });

    it('should return 50% at halfway through level', () => {
      expect(service.progressToNextLevel(100)).toBe(50);
      expect(service.progressToNextLevel(300)).toBe(50);
    });

    it('should return 99% near end of level', () => {
      expect(service.progressToNextLevel(199)).toBe(99);
      expect(service.progressToNextLevel(399)).toBe(99);
    });

    it('should return 25% at quarter through level', () => {
      expect(service.progressToNextLevel(50)).toBe(25);
      expect(service.progressToNextLevel(250)).toBe(25);
    });
  });

  describe('addXP', () => {
    beforeEach(() => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue(mockUser);
      (prisma.user.update as jest.Mock).mockResolvedValue({
        ...mockUser,
        totalXp: 100,
        level: 1,
      });
      (prisma.xPHistory.create as jest.Mock).mockResolvedValue({});
      (prisma.weeklyStats.findFirst as jest.Mock).mockResolvedValue(null);
      (prisma.weeklyStats.create as jest.Mock).mockResolvedValue({});
    });

    it('should add XP without leveling up', async () => {
      const result = await service.addXP('user-1', 100, 'conversation');

      expect(result.leveledUp).toBe(false);
      expect(result.newLevel).toBe(1);
      expect(result.totalXp).toBe(100);
      expect(prisma.user.update).toHaveBeenCalledWith({
        where: { id: 'user-1' },
        data: {
          totalXp: 100,
          level: 1,
        },
      });
    });

    it('should level up when crossing threshold', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        totalXp: 150,
        level: 1,
      });
      (prisma.user.update as jest.Mock).mockResolvedValue({
        ...mockUser,
        totalXp: 250,
        level: 2,
      });

      const result = await service.addXP('user-1', 100, 'conversation');

      expect(result.leveledUp).toBe(true);
      expect(result.newLevel).toBe(2);
      expect(result.totalXp).toBe(250);
    });

    it('should create XP history entry', async () => {
      await service.addXP('user-1', 50, 'vocabulary_review');

      expect(prisma.xPHistory.create).toHaveBeenCalledWith({
        data: {
          userId: 'user-1',
          amount: 50,
          source: 'vocabulary_review',
          totalXpAfter: 50,
        },
      });
    });

    it('should update weekly stats when they exist', async () => {
      const existingWeeklyStats = {
        id: 'stats-1',
        userId: 'user-1',
        weekNumber: 1,
        weeklyXp: 100,
      };

      (prisma.weeklyStats.findFirst as jest.Mock).mockResolvedValue(existingWeeklyStats);

      await service.addXP('user-1', 50, 'challenge');

      expect(prisma.weeklyStats.update).toHaveBeenCalledWith({
        where: { id: 'stats-1' },
        data: {
          weeklyXp: 150,
        },
      });
    });

    it('should create weekly stats when they do not exist', async () => {
      (prisma.weeklyStats.findFirst as jest.Mock).mockResolvedValue(null);

      await service.addXP('user-1', 50, 'challenge');

      expect(prisma.weeklyStats.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          userId: 'user-1',
          weeklyXp: 50,
        }),
      });
    });

    it('should throw error if user not found', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue(null);

      await expect(service.addXP('user-1', 100, 'test')).rejects.toThrow('User not found');
    });

    it('should handle multiple level ups', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        totalXp: 100,
        level: 1,
      });
      (prisma.user.update as jest.Mock).mockResolvedValue({
        ...mockUser,
        totalXp: 700,
        level: 4,
      });

      const result = await service.addXP('user-1', 600, 'badge_bonus');

      expect(result.leveledUp).toBe(true);
      expect(result.newLevel).toBe(4);
      expect(result.totalXp).toBe(700);
    });
  });

  describe('getUserXpStats', () => {
    it('should return correct XP stats for level 1 user', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        totalXp: 150,
        level: 1,
      });

      const stats = await service.getUserXpStats('user-1');

      expect(stats.totalXp).toBe(150);
      expect(stats.level).toBe(1);
      expect(stats.xpToNextLevel).toBe(50); // 200 - 150
      expect(stats.progressPercent).toBe(75); // 150/200 * 100
    });

    it('should return correct XP stats for level 5 user', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        totalXp: 900,
        level: 5,
      });

      const stats = await service.getUserXpStats('user-1');

      expect(stats.totalXp).toBe(900);
      expect(stats.level).toBe(5);
      expect(stats.xpToNextLevel).toBe(900); // xpForNextLevel(5) - (900 % 200) = 1000 - 100 = 900
      expect(stats.progressPercent).toBe(50); // 100/200 * 100
    });

    it('should handle user at exact level boundary', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        totalXp: 1000,
        level: 6,
      });

      const stats = await service.getUserXpStats('user-1');

      expect(stats.totalXp).toBe(1000);
      expect(stats.level).toBe(6);
      expect(stats.xpToNextLevel).toBe(1200); // xpForNextLevel(6) - (1000 % 200) = 1200 - 0 = 1200
      expect(stats.progressPercent).toBe(0);
    });

    it('should throw error if user not found', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue(null);

      await expect(service.getUserXpStats('user-1')).rejects.toThrow('User not found');
    });
  });

  describe('Level Formula Verification', () => {
    it('should correctly calculate cumulative XP for levels', () => {
      // Level 1 = 0-199 XP
      // Level 2 = 200-399 XP
      // Level 3 = 400-599 XP
      // Level N starts at (N-1) * 200 XP

      expect(service.calculateLevel(0)).toBe(1);
      expect(service.calculateLevel(199)).toBe(1);
      expect(service.calculateLevel(200)).toBe(2);
      expect(service.calculateLevel(399)).toBe(2);
      expect(service.calculateLevel(400)).toBe(3);
      expect(service.calculateLevel(599)).toBe(3);
      expect(service.calculateLevel(600)).toBe(4);
      expect(service.calculateLevel(799)).toBe(4);
      expect(service.calculateLevel(800)).toBe(5);
    });

    it('should match level formula: Level N requires N * 200 XP total', () => {
      // To reach Level 5, need to complete Level 4 = 4 * 200 = 800 XP
      // To reach Level 10, need to complete Level 9 = 9 * 200 = 1800 XP

      expect(service.calculateLevel(800)).toBe(5);
      expect(service.calculateLevel(1800)).toBe(10);
      expect(service.calculateLevel(2000)).toBe(11);
    });
  });

  describe('Integration Scenarios', () => {
    it('should handle full progression from level 1 to level 3', async () => {
      let currentXp = 0;
      let currentLevel = 1;

      // Add 100 XP - should stay at level 1
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        totalXp: currentXp,
        level: currentLevel,
      });
      (prisma.user.update as jest.Mock).mockResolvedValue({
        ...mockUser,
        totalXp: 100,
        level: 1,
      });
      (prisma.xPHistory.create as jest.Mock).mockResolvedValue({});
      (prisma.weeklyStats.findFirst as jest.Mock).mockResolvedValue(null);
      (prisma.weeklyStats.create as jest.Mock).mockResolvedValue({});

      let result = await service.addXP('user-1', 100, 'test');
      expect(result.leveledUp).toBe(false);
      expect(result.newLevel).toBe(1);

      // Add 150 XP - should level up to 2
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        totalXp: 100,
        level: 1,
      });
      (prisma.user.update as jest.Mock).mockResolvedValue({
        ...mockUser,
        totalXp: 250,
        level: 2,
      });

      result = await service.addXP('user-1', 150, 'test');
      expect(result.leveledUp).toBe(true);
      expect(result.newLevel).toBe(2);

      // Add 200 XP - should level up to 3
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        totalXp: 250,
        level: 2,
      });
      (prisma.user.update as jest.Mock).mockResolvedValue({
        ...mockUser,
        totalXp: 450,
        level: 3,
      });

      result = await service.addXP('user-1', 200, 'test');
      expect(result.leveledUp).toBe(true);
      expect(result.newLevel).toBe(3);
    });
  });
});
