import { Test, TestingModule } from '@nestjs/testing';
import { ChallengeService } from '../challenge/challenge.service';
import { ChallengeRepository } from '../challenge/challenge.repository';
import { PrismaService } from '../../../prisma/prisma.service';
import { NotFoundException } from '@nestjs/common';

describe('ChallengeService', () => {
  let service: ChallengeService;
  let repository: jest.Mocked<ChallengeRepository>;
  let prisma: jest.Mocked<PrismaService>;

  beforeEach(async () => {
    const mockRepository = {
      findTodayChallenges: jest.fn(),
      createUserChallenge: jest.fn(),
      markCompleted: jest.fn(),
      updateProgress: jest.fn(),
    };

    const mockPrisma = {
      userChallenge: {
        findUnique: jest.fn(),
        update: jest.fn(),
      },
    };

    const module: TestingModule = await Test.createTestingModule({
      providers:
[
        ChallengeService,
        {
          provide: ChallengeRepository,
          useValue: mockRepository,
        },
        {
          provide: PrismaService,
          useValue: mockPrisma,
        },
      ],
    }).compile();

    service = module.get<ChallengeService>(ChallengeService);
    repository = module.get(ChallengeRepository);
    prisma = module.get(PrismaService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('getTodayChallenge', () => {
    it('should return existing challenges if available', async () => {
      const mockChallenges = [
        {
          id: 'challenge-1',
          userId: 'user-1',
          challengeId: 'ch-1',
          assignedDate: new Date(),
          currentProgress: 2,
          status: 'ACTIVE' as any,
          completedAt: null,
          createdAt: new Date(),
          user: null,
          challenge: {
            id: 'ch-1',
            type: 'conversation' as any,
            title: 'Complete Conversations',
            titleJa: '会話を完了する',
            description: 'Complete 5 conversations',
            condition: { target: 5 },
            xpReward: 50,
            isActive: true,
            createdAt: new Date(),
            userChallenges: [],
          },
        },
      ];

      repository.findTodayChallenges.mockResolvedValue(mockChallenges as any);

      const result = await service.getTodayChallenge('user-1');

      expect(repository.findTodayChallenges).toHaveBeenCalledWith('user-1');
      expect(result).toHaveLength(1);
    });

    it('should generate new challenges if none exist', async () => {
      repository.findTodayChallenges.mockResolvedValue([]);
      repository.createUserChallenge.mockResolvedValue({} as any);

      const result = await service.getTodayChallenge('user-1');

      expect(repository.findTodayChallenges).toHaveBeenCalledWith('user-1');
      // Should create 3 challenges
      expect(repository.createUserChallenge).toHaveBeenCalled();
    });
  });

  describe('generateDailyChallenge', () => {
    beforeEach(() => {
      repository.createUserChallenge.mockResolvedValue({} as any);
    });

    it('should generate 3 challenges', async () => {
      const result = await service.generateDailyChallenge('user-1');

      expect(result).toHaveLength(3);
      expect(repository.createUserChallenge).toHaveBeenCalledTimes(3);
    });

    it('should create challenges with correct XP rewards', async () => {
      await service.generateDailyChallenge('user-1');

      const calls = (repository.createUserChallenge as jest.Mock).mock.calls;

      // Verify XP rewards: 50, 30, 60
      const xpRewards = calls.map(call => call[3]);
      expect(xpRewards).toContain(50); // conversation
      expect(xpRewards).toContain(30); // vocabulary
      expect(xpRewards).toContain(60); // time
    });
  });

  describe('completeChallenge', () => {
    it('should complete challenge and award XP', async () => {
      const mockUserChallenge = {
        id: 'challenge-1',
        userId: 'user-1',
        challengeId: 'ch-1',
        assignedDate: new Date(),
        currentProgress: 5,
        status: 'ACTIVE' as any,
        completedAt: null,
        createdAt: new Date(),
        xpReward: 50, // Include xpReward directly for the test
        completed: false, // Include completed directly for the test
      };

      (prisma.userChallenge.findUnique as jest.Mock).mockResolvedValue(mockUserChallenge);
      repository.markCompleted.mockResolvedValue({
        ...mockUserChallenge,
        status: 'COMPLETED' as any,
        completedAt: new Date(),
      } as any);

      const result = await service.completeChallenge('user-1', 'challenge-1');

      expect(prisma.userChallenge.findUnique).toHaveBeenCalledWith({
        where: { id: 'challenge-1' },
      });
      expect(repository.markCompleted).toHaveBeenCalledWith('challenge-1');
      expect(result.xpEarned).toBe(50);
      expect(result.completed).toBe(true);
    });

    it('should throw NotFoundException if challenge not found', async () => {
      (prisma.userChallenge.findUnique as jest.Mock).mockResolvedValue(null);

      await expect(
        service.completeChallenge('user-1', 'challenge-1'),
      ).rejects.toThrow(NotFoundException);

      expect(repository.markCompleted).not.toHaveBeenCalled();
    });

    it('should throw NotFoundException if user does not own challenge', async () => {
      const mockChallenge = {
        id: 'challenge-1',
        userId: 'other-user',
        challengeId: 'ch-1',
        status: 'ACTIVE',
        currentProgress: 0,
        challenge: { xpReward: 50 },
        completed: false,
      };

      (prisma.userChallenge.findUnique as jest.Mock).mockResolvedValue(mockChallenge);

      await expect(
        service.completeChallenge('user-1', 'challenge-1'),
      ).rejects.toThrow(NotFoundException);

      expect(repository.markCompleted).not.toHaveBeenCalled();
    });

    it('should return 0 XP if challenge already completed', async () => {
      const mockChallenge = {
        id: 'challenge-1',
        userId: 'user-1',
        status: 'COMPLETED',
        completedAt: new Date(),
        challenge: { xpReward: 50 },
        completed: true,
      };

      (prisma.userChallenge.findUnique as jest.Mock).mockResolvedValue(mockChallenge);

      const result = await service.completeChallenge('user-1', 'challenge-1');

      expect(result.xpEarned).toBe(0);
      expect(result.completed).toBe(true);
      expect(repository.markCompleted).not.toHaveBeenCalled();
    });
  });

  describe('updateProgress', () => {
    it('should update challenge progress', async () => {
      const mockChallenge = {
        id: 'challenge-1',
        userId: 'user-1',
        challengeId: 'ch-1',
        currentProgress: 0,
        status: 'ACTIVE',
      };

      const mockUpdated = {
        ...mockChallenge,
        currentProgress: 3,
        challenge: {
          type: 'conversation',
          title: 'Complete Conversations',
          description: 'Complete 5 conversations',
          xpReward: 50,
          condition: { target: 5 },
        },
      };

      (prisma.userChallenge.findUnique as jest.Mock).mockResolvedValue(mockChallenge);
      repository.updateProgress.mockResolvedValue(mockUpdated as any);

      const result = await service.updateProgress('user-1', 'challenge-1', 3);

      expect(prisma.userChallenge.findUnique).toHaveBeenCalledWith({
        where: { id: 'challenge-1' },
      });
      expect(repository.updateProgress).toHaveBeenCalledWith('challenge-1', 3);
      expect(result).toBeDefined();
    });

    it('should throw NotFoundException if challenge not found', async () => {
      (prisma.userChallenge.findUnique as jest.Mock).mockResolvedValue(null);

      await expect(
        service.updateProgress('user-1', 'challenge-1', 3),
      ).rejects.toThrow(NotFoundException);

      expect(repository.updateProgress).not.toHaveBeenCalled();
    });

    it('should throw NotFoundException if user does not own challenge', async () => {
      const mockChallenge = {
        id: 'challenge-1',
        userId: 'other-user',
      };

      (prisma.userChallenge.findUnique as jest.Mock).mockResolvedValue(mockChallenge);

      await expect(
        service.updateProgress('user-1', 'challenge-1', 3),
      ).rejects.toThrow(NotFoundException);

      expect(repository.updateProgress).not.toHaveBeenCalled();
    });
  });

  describe('Progress Tracking', () => {
    it('should handle incremental progress updates', async () => {
      const mockChallenge = {
        id: 'challenge-1',
        userId: 'user-1',
        currentProgress: 0,
      };

      (prisma.userChallenge.findUnique as jest.Mock).mockResolvedValue(mockChallenge);

      for (let i = 1; i <= 5; i++) {
        repository.updateProgress.mockResolvedValue({
          ...mockChallenge,
          currentProgress: i,
          challenge: {
            type: 'conversation',
            title: 'Complete Conversations',
            description: 'Complete conversations',
            xpReward: 50,
            condition: { target: 5 },
          },
        } as any);

        const result = await service.updateProgress('user-1', 'challenge-1', i);
        expect(result).toBeDefined();
      }
    });
  });
});
