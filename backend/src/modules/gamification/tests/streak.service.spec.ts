import { Test, TestingModule } from '@nestjs/testing';
import { StreakService } from '../streak/streak.service';
import { PrismaService } from '../../../prisma/prisma.service';
import { BadRequestException } from '@nestjs/common';

describe('StreakService', () => {
  let service: StreakService;
  let prisma: jest.Mocked<PrismaService>;

  const mockUser = {
    id: 'user-1',
    email: 'test@example.com',
    username: 'testuser',
    totalXp: 0,
    level: 1,
    currentStreak: 0,
    longestStreak: 0,
    streakFreezeCount: 2,
    lastActivityDate: null,
  };

  beforeEach(async () => {
    const mockPrisma = {
      user: {
        findUnique: jest.fn(),
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
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        lastActivityDate: null,
        currentStreak: 0,
      });
      (prisma.user.update as jest.Mock).mockResolvedValue({
        ...mockUser,
        currentStreak: 1,
        longestStreak: 1,
      });

      const result = await service.recordActivity('user-1');

      expect(prisma.user.update).toHaveBeenCalledWith({
        where: { id: 'user-1' },
        data: expect.objectContaining({
          currentStreak: 1,
          longestStreak: 1,
        }),
      });
    });

    it('should increment streak when activity was yesterday', async () => {
      const yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);
      yesterday.setHours(0, 0, 0, 0);

      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        lastActivityDate: yesterday,
        currentStreak: 5,
        longestStreak: 10,
      });
      (prisma.user.update as jest.Mock).mockResolvedValue({
        ...mockUser,
        currentStreak: 6,
        longestStreak: 10,
      });

      await service.recordActivity('user-1');

      expect(prisma.user.update).toHaveBeenCalledWith({
        where: { id: 'user-1' },
        data: expect.objectContaining({
          currentStreak: 6,
        }),
      });
    });

    it('should return existing data when already recorded today', async () => {
      const today = new Date();
      today.setHours(0, 0, 0, 0);

      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        lastActivityDate: today,
        currentStreak: 7,
        longestStreak: 10,
      });

      const result = await service.recordActivity('user-1');

      expect(result.currentStreak).toBe(7);
      expect(prisma.user.update).not.toHaveBeenCalled();
    });

    it('should use freeze when gap exists and freezes available', async () => {
      const twoDaysAgo = new Date();
      twoDaysAgo.setDate(twoDaysAgo.getDate() - 2);
      twoDaysAgo.setHours(0, 0, 0, 0);

      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        lastActivityDate: twoDaysAgo,
        currentStreak: 10,
        longestStreak: 15,
        streakFreezeCount: 1,
      });
      (prisma.user.update as jest.Mock).mockResolvedValue({
        ...mockUser,
        streakFreezeCount: 0,
      });

      await service.recordActivity('user-1');

      // Should use freeze
      expect(prisma.user.update).toHaveBeenCalledWith({
        where: { id: 'user-1' },
        data: {
          streakFreezeCount: 0,
        },
      });
    });

    it('should reset streak to 1 when gap exists and no freezes', async () => {
      const threeDaysAgo = new Date();
      threeDaysAgo.setDate(threeDaysAgo.getDate() - 3);
      threeDaysAgo.setHours(0, 0, 0, 0);

      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        lastActivityDate: threeDaysAgo,
        currentStreak: 10,
        longestStreak: 15,
        streakFreezeCount: 0,
      });
      (prisma.user.update as jest.Mock).mockResolvedValue({
        ...mockUser,
        currentStreak: 1,
      });

      await service.recordActivity('user-1');

      expect(prisma.user.update).toHaveBeenCalledWith({
        where: { id: 'user-1' },
        data: expect.objectContaining({
          currentStreak: 1,
        }),
      });
    });

    it('should update longest streak when current exceeds it', async () => {
      const yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);
      yesterday.setHours(0, 0, 0, 0);

      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        lastActivityDate: yesterday,
        currentStreak: 20,
        longestStreak: 20,
      });
      (prisma.user.update as jest.Mock).mockResolvedValue({
        ...mockUser,
        currentStreak: 21,
        longestStreak: 21,
      });

      await service.recordActivity('user-1');

      expect(prisma.user.update).toHaveBeenCalledWith({
        where: { id: 'user-1' },
        data: expect.objectContaining({
          currentStreak: 21,
          longestStreak: 21,
        }),
      });
    });

    it('should not update longest streak when current is below it', async () => {
      const yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);
      yesterday.setHours(0, 0, 0, 0);

      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        lastActivityDate: yesterday,
        currentStreak: 5,
        longestStreak: 30,
      });
      (prisma.user.update as jest.Mock).mockResolvedValue({
        ...mockUser,
        currentStreak: 6,
        longestStreak: 30,
      });

      await service.recordActivity('user-1');

      expect(prisma.user.update).toHaveBeenCalledWith({
        where: { id: 'user-1' },
        data: expect.objectContaining({
          currentStreak: 6,
          longestStreak: 30,
        }),
      });
    });

    it('should throw error if user not found', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue(null);

      await expect(service.recordActivity('user-1')).rejects.toThrow(
        'User not found',
      );
    });
  });

  describe('getStreakStatus', () => {
    it('should return current streak status', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        currentStreak: 5,
        longestStreak: 10,
        streakFreezeCount: 2,
        lastActivityDate: new Date(),
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
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        currentStreak: 3,
      });

      let status = await service.getStreakStatus('user-1');
      expect(status.nextMilestone).toBe(7);
      expect(status.daysUntilMilestone).toBe(4);

      // Streak 10 -> next milestone is 30
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        currentStreak: 10,
      });

      status = await service.getStreakStatus('user-1');
      expect(status.nextMilestone).toBe(30);
      expect(status.daysUntilMilestone).toBe(20);

      // Streak 50 -> next milestone is 100
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        currentStreak: 50,
      });

      status = await service.getStreakStatus('user-1');
      expect(status.nextMilestone).toBe(100);
      expect(status.daysUntilMilestone).toBe(50);
    });

    it('should return last milestone when beyond all milestones', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        currentStreak: 150,
      });

      const status = await service.getStreakStatus('user-1');
      expect(status.nextMilestone).toBe(100);
    });

    it('should throw error if user not found', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue(null);

      await expect(service.getStreakStatus('user-1')).rejects.toThrow(
        'User not found',
      );
    });
  });

  describe('useFreeze', () => {
    it('should use freeze when available', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        streakFreezeCount: 2,
      });
      (prisma.user.update as jest.Mock).mockResolvedValue({
        ...mockUser,
        streakFreezeCount: 1,
      });

      const result = await service.useFreeze('user-1');

      expect(result.success).toBe(true);
      expect(result.message).toBe('Streak freeze used successfully');
      expect(prisma.user.update).toHaveBeenCalledWith({
        where: { id: 'user-1' },
        data: {
          streakFreezeCount: 1,
        },
      });
    });

    it('should throw error when no freezes available', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        streakFreezeCount: 0,
      });

      await expect(service.useFreeze('user-1')).rejects.toThrow(
        BadRequestException,
      );
      await expect(service.useFreeze('user-1')).rejects.toThrow(
        'No streak freezes available',
      );
    });

    it('should throw error if user not found', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue(null);

      await expect(service.useFreeze('user-1')).rejects.toThrow(
        'User not found',
      );
    });
  });

  describe('awardFreeze', () => {
    it('should award 1 freeze by default', async () => {
      (prisma.user.update as jest.Mock).mockResolvedValue({});

      await service.awardFreeze('user-1');

      expect(prisma.user.update).toHaveBeenCalledWith({
        where: { id: 'user-1' },
        data: {
          streakFreezeCount: {
            increment: 1,
          },
        },
      });
    });

    it('should award multiple freezes when specified', async () => {
      (prisma.user.update as jest.Mock).mockResolvedValue({});

      await service.awardFreeze('user-1', 3);

      expect(prisma.user.update).toHaveBeenCalledWith({
        where: { id: 'user-1' },
        data: {
          streakFreezeCount: {
            increment: 3,
          },
        },
      });
    });
  });

  describe('Streak Milestones', () => {
    it('should recognize 7-day milestone', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        currentStreak: 7,
      });

      const status = await service.getStreakStatus('user-1');
      expect(status.currentStreak).toBe(7);
      expect(status.nextMilestone).toBe(30);
    });

    it('should recognize 30-day milestone', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        currentStreak: 30,
      });

      const status = await service.getStreakStatus('user-1');
      expect(status.currentStreak).toBe(30);
      expect(status.nextMilestone).toBe(100);
    });

    it('should recognize 100-day milestone', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        currentStreak: 100,
      });

      const status = await service.getStreakStatus('user-1');
      expect(status.currentStreak).toBe(100);
      expect(status.nextMilestone).toBe(100);
    });
  });

  describe('Integration Scenarios', () => {
    it('should handle full streak progression with freeze', async () => {
      // Day 1: Start streak
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        lastActivityDate: null,
        currentStreak: 0,
      });
      (prisma.user.update as jest.Mock).mockResolvedValue({
        ...mockUser,
        currentStreak: 1,
      });

      await service.recordActivity('user-1');

      // Day 2: Continue streak
      const day1 = new Date();
      day1.setDate(day1.getDate() - 1);
      day1.setHours(0, 0, 0, 0);

      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        lastActivityDate: day1,
        currentStreak: 1,
      });
      (prisma.user.update as jest.Mock).mockResolvedValue({
        ...mockUser,
        currentStreak: 2,
      });

      await service.recordActivity('user-1');

      // Day 4: Missed day 3, but have freeze
      const day2 = new Date();
      day2.setDate(day2.getDate() - 2);
      day2.setHours(0, 0, 0, 0);

      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        lastActivityDate: day2,
        currentStreak: 2,
        streakFreezeCount: 1,
      });
      (prisma.user.update as jest.Mock).mockResolvedValue({
        ...mockUser,
        streakFreezeCount: 0,
      });

      await service.recordActivity('user-1');

      // Freeze should be used
      expect(prisma.user.update).toHaveBeenCalledWith({
        where: { id: 'user-1' },
        data: {
          streakFreezeCount: 0,
        },
      });
    });

    it('should handle streak reset when no freeze available', async () => {
      const threeDaysAgo = new Date();
      threeDaysAgo.setDate(threeDaysAgo.getDate() - 3);
      threeDaysAgo.setHours(0, 0, 0, 0);

      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        lastActivityDate: threeDaysAgo,
        currentStreak: 25,
        longestStreak: 30,
        streakFreezeCount: 0,
      });
      (prisma.user.update as jest.Mock).mockResolvedValue({
        ...mockUser,
        currentStreak: 1,
        longestStreak: 30,
      });

      await service.recordActivity('user-1');

      expect(prisma.user.update).toHaveBeenCalledWith({
        where: { id: 'user-1' },
        data: expect.objectContaining({
          currentStreak: 1,
          longestStreak: 30, // Should preserve longest
        }),
      });
    });
  });
});
