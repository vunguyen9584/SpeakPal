import { Test, TestingModule } from '@nestjs/testing';
import { StreakService } from '../streak/streak.service';
import { PrismaService } from '../../../prisma/prisma.service';
import { BadRequestException } from '@nestjs/common';

describe('StreakService', () => {
  let service: StreakService;
  let prisma: jest.Mocked<PrismaService>;

  const mockStreak = {
    id: 'streak-1',
    userId: 'user-1',
    currentStreak: 5,
    longestStreak: 10,
    freezeRemaining: 2,
    lastActivityDate: new Date(),
    createdAt: new Date(),
    updatedAt: new Date(),
  };

  beforeEach(async () => {
    const mockPrisma = {
      streak: {
        findUnique: jest.fn(),
        create: jest.fn(),
        update: jest.fn(),
      },
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        StreakService,
        {
          provide: PrismaService,
          useValue: mockPrisma,
        },
      ],
    }).compile();

    service = module.get<StreakService>(StreakService);
    prisma = module.get(PrismaService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('recordActivity', () => {
    it('should initialize streak to 1 for first time user', async () => {
      // First call returns null (no streak), second call returns created streak
      (prisma.streak.findUnique as jest.Mock)
        .mockResolvedValueOnce(null)
        .mockResolvedValueOnce({
          ...mockStreak,
          currentStreak: 1,
          longestStreak: 1,
          lastActivityDate: new Date(),
        });

      (prisma.streak.create as jest.Mock).mockResolvedValue({
        ...mockStreak,
        currentStreak: 1,
        longestStreak: 1,
      });

      const result = await service.recordActivity('user-1');

      expect(prisma.streak.create).toHaveBeenCalledWith(
        expect.objectContaining({
          data: expect.objectContaining({
            userId: 'user-1',
            currentStreak: 1,
            longestStreak: 1,
          }),
        }),
      );
      expect(result.currentStreak).toBe(1);
    });

    it('should increment streak when activity was yesterday', async () => {
      const yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);
      yesterday.setHours(0, 0, 0, 0);

      const initialStreak = {
        ...mockStreak,
        lastActivityDate: yesterday,
        currentStreak: 5,
        longestStreak: 10,
      };

      const updatedStreak = {
        ...initialStreak,
        currentStreak: 6,
        lastActivityDate: new Date(),
      };

      (prisma.streak.findUnique as jest.Mock)
        .mockResolvedValueOnce(initialStreak)
        .mockResolvedValueOnce(updatedStreak);

      (prisma.streak.update as jest.Mock).mockResolvedValue(updatedStreak);

      await service.recordActivity('user-1');

      expect(prisma.streak.update).toHaveBeenCalledWith({
        where: { userId: 'user-1' },
        data: expect.objectContaining({
          currentStreak: 6,
        }),
      });
    });

    it('should return existing data when already recorded today', async () => {
      const today = new Date();
      today.setHours(0, 0, 0, 0);

      const streak = {
        ...mockStreak,
        lastActivityDate: today,
        currentStreak: 7,
      };

      (prisma.streak.findUnique as jest.Mock).mockResolvedValue(streak);

      const result = await service.recordActivity('user-1');

      expect(result.currentStreak).toBe(7);
      expect(prisma.streak.update).not.toHaveBeenCalled();
    });

    it('should use freeze when gap exists and freezes available', async () => {
      const twoDaysAgo = new Date();
      twoDaysAgo.setDate(twoDaysAgo.getDate() - 2);
      twoDaysAgo.setHours(0, 0, 0, 0);

      const initialStreak = {
        ...mockStreak,
        lastActivityDate: twoDaysAgo,
        currentStreak: 10,
        streakFreezeCount: 1, // field name is freezeRemaining in schema/service? Service uses freezeRemaining.
        freezeRemaining: 1,
      };

      // Note: Test mock object mockStreak has freezeRemaining.

      const frozenStreak = {
        ...initialStreak,
        freezeRemaining: 0,
      };

      const finalStreak = {
        ...frozenStreak,
        lastActivityDate: new Date(),
      };

      (prisma.streak.findUnique as jest.Mock)
        .mockResolvedValueOnce(initialStreak)
        .mockResolvedValueOnce(finalStreak);

      (prisma.streak.update as jest.Mock).mockResolvedValue(finalStreak);

      await service.recordActivity('user-1');

      // First update to use freeze
      expect(prisma.streak.update).toHaveBeenCalledWith({
        where: { userId: 'user-1' },
        data: {
          freezeRemaining: 0,
        },
      });

      // Second update to update date
      expect(prisma.streak.update).toHaveBeenCalledWith({
        where: { userId: 'user-1' },
        data: expect.objectContaining({
          lastActivityDate: expect.any(Date),
        }),
      });
    });

    it('should reset streak to 1 when gap exists and no freezes', async () => {
      const threeDaysAgo = new Date();
      threeDaysAgo.setDate(threeDaysAgo.getDate() - 3);
      threeDaysAgo.setHours(0, 0, 0, 0);

      const initialStreak = {
        ...mockStreak,
        lastActivityDate: threeDaysAgo,
        currentStreak: 10,
        freezeRemaining: 0,
      };

      const resetStreak = {
        ...initialStreak,
        currentStreak: 1,
        lastActivityDate: new Date(),
      };

      (prisma.streak.findUnique as jest.Mock)
        .mockResolvedValueOnce(initialStreak)
        .mockResolvedValueOnce(resetStreak);

      (prisma.streak.update as jest.Mock).mockResolvedValue(resetStreak);

      await service.recordActivity('user-1');

      expect(prisma.streak.update).toHaveBeenCalledWith({
        where: { userId: 'user-1' },
        data: expect.objectContaining({
          currentStreak: 1,
        }),
      });
    });
  });

  describe('getStreakStatus', () => {
    it('should return current streak status', async () => {
      (prisma.streak.findUnique as jest.Mock).mockResolvedValue({
        ...mockStreak,
        currentStreak: 5,
        longestStreak: 10,
        freezeRemaining: 2,
      });

      const status = await service.getStreakStatus('user-1');

      expect(status.currentStreak).toBe(5);
      expect(status.longestStreak).toBe(10);
      expect(status.freezeRemaining).toBe(2);
      expect(status.nextMilestone).toBe(7);
      expect(status.daysUntilMilestone).toBe(2);
    });

    it('should calculate next milestone correctly', async () => {
      // Streak 3 -> next milestone is 7
      (prisma.streak.findUnique as jest.Mock).mockResolvedValue({
        ...mockStreak,
        currentStreak: 3,
      });

      let status = await service.getStreakStatus('user-1');
      expect(status.nextMilestone).toBe(7);

      // Streak 10 -> next milestone is 30
      (prisma.streak.findUnique as jest.Mock).mockResolvedValue({
        ...mockStreak,
        currentStreak: 10,
      });

      status = await service.getStreakStatus('user-1');
      expect(status.nextMilestone).toBe(30);

      // Streak 50 -> next milestone is 100
      (prisma.streak.findUnique as jest.Mock).mockResolvedValue({
        ...mockStreak,
        currentStreak: 50,
      });

      status = await service.getStreakStatus('user-1');
      expect(status.nextMilestone).toBe(100);
    });
  });

  describe('useFreeze', () => {
    it('should use freeze when available', async () => {
      (prisma.streak.findUnique as jest.Mock).mockResolvedValue({
        ...mockStreak,
        freezeRemaining: 2,
      });
      (prisma.streak.update as jest.Mock).mockResolvedValue({
        ...mockStreak,
        freezeRemaining: 1,
      });

      const result = await service.useFreeze('user-1');

      expect(result.success).toBe(true);
      expect(prisma.streak.update).toHaveBeenCalledWith({
        where: { userId: 'user-1' },
        data: {
          freezeRemaining: 1,
        },
      });
    });

    it('should throw error when no freezes available', async () => {
      (prisma.streak.findUnique as jest.Mock).mockResolvedValue({
        ...mockStreak,
        freezeRemaining: 0,
      });

      await expect(service.useFreeze('user-1')).rejects.toThrow(
        BadRequestException,
      );
    });

    it('should throw error if streak not found', async () => {
      (prisma.streak.findUnique as jest.Mock).mockResolvedValue(null);

      await expect(service.useFreeze('user-1')).rejects.toThrow(
        'Streak not found',
      );
    });
  });

  describe('awardFreeze', () => {
    it('should award 1 freeze by default', async () => {
      (prisma.streak.findUnique as jest.Mock).mockResolvedValue(mockStreak);
      (prisma.streak.update as jest.Mock).mockResolvedValue(mockStreak);

      await service.awardFreeze('user-1');

      expect(prisma.streak.update).toHaveBeenCalledWith({
        where: { userId: 'user-1' },
        data: {
          freezeRemaining: {
            increment: 1,
          },
        },
      });
    });

    it('should create streak if not exists when awarding', async () => {
      (prisma.streak.findUnique as jest.Mock).mockResolvedValue(null);
      (prisma.streak.create as jest.Mock).mockResolvedValue(mockStreak);

      await service.awardFreeze('user-1');

      expect(prisma.streak.create).toHaveBeenCalledWith({
        data: {
          userId: 'user-1',
          currentStreak: 0,
          longestStreak: 0,
          freezeRemaining: 1,
        },
      });
    });
  });
});
