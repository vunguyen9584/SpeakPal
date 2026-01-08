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
    level: 'BEGINNER', // User model uses Enum, but Service uses numeric calculation based on totalXP
    currentStreak: 0,
    league: 'BRONZE',
  };

  beforeEach(async () => {
    const mockPrisma = {
      user: {
        findUnique: jest.fn(),
        update: jest.fn(),
      },
      userRanking: {
        findUnique: jest.fn(),
        update: jest.fn(),
        create: jest.fn(),
      },
      // Removed obsolete weeklyStats and xPHistory if they are not used in service or schema
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
      expect(service.calculateLevel(199)).toBe(1);
    });

    it('should return level 2 for 200-399 XP', () => {
      expect(service.calculateLevel(200)).toBe(2);
      expect(service.calculateLevel(399)).toBe(2);
    });
  });

  describe('progressToNextLevel', () => {
    it('should return 0% at start of level', () => {
      expect(service.progressToNextLevel(0)).toBe(0);
      expect(service.progressToNextLevel(200)).toBe(0);
    });

    it('should return 50% at halfway through level', () => {
      expect(service.progressToNextLevel(100)).toBe(50);
      expect(service.progressToNextLevel(300)).toBe(50);
    });
  });

  describe('addXP', () => {
    beforeEach(() => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue(mockUser);
      (prisma.user.update as jest.Mock).mockResolvedValue({
        ...mockUser,
        totalXp: 100,
      });
      (prisma.userRanking.findUnique as jest.Mock).mockResolvedValue(null);
      (prisma.userRanking.create as jest.Mock).mockResolvedValue({});
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
        },
      });
    });

    it('should level up when crossing threshold', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        totalXp: 190,
      });
      (prisma.user.update as jest.Mock).mockResolvedValue({
        ...mockUser,
        totalXp: 290,
      });

      const result = await service.addXP('user-1', 100, 'conversation');

      expect(result.leveledUp).toBe(true);
      expect(result.newLevel).toBe(2); // 290 XP is level 2
      expect(result.totalXp).toBe(290);
    });

    it('should update userRanking when it exists', async () => {
      const existingRanking = { id: 'ranking-1', weeklyXp: 100 };
      (prisma.userRanking.findUnique as jest.Mock).mockResolvedValue(existingRanking);

      await service.addXP('user-1', 50, 'test');

      expect(prisma.userRanking.update).toHaveBeenCalledWith({
        where: { id: 'ranking-1' },
        data: { weeklyXp: { increment: 50 } },
      });
    });

    it('should create userRanking when it does not exist', async () => {
      (prisma.userRanking.findUnique as jest.Mock).mockResolvedValue(null);

      await service.addXP('user-1', 50, 'test');

      expect(prisma.userRanking.create).toHaveBeenCalled();
    });
  });

  describe('getUserXpStats', () => {
    it('should return correct XP stats for level 1 user', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        totalXp: 150,
      });

      const stats = await service.getUserXpStats('user-1');

      expect(stats.totalXp).toBe(150);
      expect(stats.level).toBe(1);
      expect(stats.xpToNextLevel).toBe(50); // 200 - 150
      expect(stats.progressPercent).toBe(75);
    });

    it('should return correct XP stats for level 5 user', async () => {
      // Level 5 starts at 800 XP (4 * 200).
      // If user has 900 XP.
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        totalXp: 900,
      });

      const stats = await service.getUserXpStats('user-1');

      expect(stats.totalXp).toBe(900);
      expect(stats.level).toBe(5);
      // Remainder: 900 % 200 = 100. Needed: 200. Remaining: 100.
      expect(stats.xpToNextLevel).toBe(100);
      expect(stats.progressPercent).toBe(50);
    });

    it('should handle user at exact level boundary', async () => {
      // Level 6 starts at 1000 XP.
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        totalXp: 1000,
      });

      const stats = await service.getUserXpStats('user-1');

      expect(stats.totalXp).toBe(1000);
      expect(stats.level).toBe(6);
      expect(stats.xpToNextLevel).toBe(200); // 0 progress, 200 needed
      expect(stats.progressPercent).toBe(0);
    });
  });
});
