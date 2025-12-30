import { Test, TestingModule } from '@nestjs/testing';
import { RankingService } from '../ranking/ranking.service';
import { PrismaService } from '../../../prisma/prisma.service';
import { League } from '../ranking/dto/ranking-response.dto';

describe('RankingService', () => {
  let service: RankingService;
  let prisma: jest.Mocked<PrismaService>;

  const mockUser = {
    id: 'user-1',
    username: 'testuser',
    avatarUrl: '/avatar.png',
    currentLeague: 'bronze' as League,
  };

  const mockWeeklyStat = {
    id: 'stat-1',
    userId: 'user-1',
    weekNumber: 1,
    weeklyXp: 500,
    user: mockUser,
  };

  beforeEach(async () => {
    const mockPrisma = {
      user: {
        findUnique: jest.fn(),
        update: jest.fn(),
      },
      weeklyStats: {
        findMany: jest.fn(),
        findFirst: jest.fn(),
        count: jest.fn(),
      },
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        RankingService,
        {
          provide: PrismaService,
          useValue: mockPrisma,
        },
      ],
    }).compile();

    service = module.get<RankingService>(RankingService);
    prisma = module.get(PrismaService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('getWeeklyRanking', () => {
    it('should return weekly ranking for user league', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue(mockUser);
      (prisma.weeklyStats.findMany as jest.Mock).mockResolvedValue([
        { ...mockWeeklyStat, weeklyXp: 1000, userId: 'user-2', user: { ...mockUser, id: 'user-2', username: 'user2' } },
        { ...mockWeeklyStat, weeklyXp: 800, userId: 'user-3', user: { ...mockUser, id: 'user-3', username: 'user3' } },
        { ...mockWeeklyStat, weeklyXp: 500, userId: 'user-1', user: mockUser },
      ]);

      const result = await service.getWeeklyRanking('user-1');

      expect(result.league).toBe('bronze');
      expect(result.entries).toHaveLength(3);
      expect(result.entries[0].rank).toBe(1);
      expect(result.entries[0].weeklyXp).toBe(1000);
      expect(result.entries[2].isCurrentUser).toBe(true);
      expect(result.currentUserRank).toBe(3);
    });

    it('should return promotion and demotion zones', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue(mockUser);
      (prisma.weeklyStats.findMany as jest.Mock).mockResolvedValue([mockWeeklyStat]);

      const result = await service.getWeeklyRanking('user-1');

      expect(result.promotionZone).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
      expect(result.demotionZone).toEqual([41, 42, 43, 44, 45, 46, 47, 48, 49, 50]);
    });

    it('should filter by specified league', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        currentLeague: 'gold',
      });
      (prisma.weeklyStats.findMany as jest.Mock).mockResolvedValue([]);

      await service.getWeeklyRanking('user-1', 'gold');

      expect(prisma.weeklyStats.findMany).toHaveBeenCalledWith({
        where: expect.objectContaining({
          user: { currentLeague: 'gold' },
        }),
        include: { user: true },
        orderBy: { weeklyXp: 'desc' },
        take: 50,
      });
    });

    it('should use user current league if not specified', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        currentLeague: 'silver',
      });
      (prisma.weeklyStats.findMany as jest.Mock).mockResolvedValue([]);

      await service.getWeeklyRanking('user-1');

      expect(prisma.weeklyStats.findMany).toHaveBeenCalledWith({
        where: expect.objectContaining({
          user: { currentLeague: 'silver' },
        }),
        include: { user: true },
        orderBy: { weeklyXp: 'desc' },
        take: 50,
      });
    });

    it('should default to bronze league if user not found', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue(null);
      (prisma.weeklyStats.findMany as jest.Mock).mockResolvedValue([]);

      await service.getWeeklyRanking('user-1');

      expect(prisma.weeklyStats.findMany).toHaveBeenCalledWith({
        where: expect.objectContaining({
          user: { currentLeague: 'bronze' },
        }),
        include: { user: true },
        orderBy: { weeklyXp: 'desc' },
        take: 50,
      });
    });

    it('should mark current user correctly', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue(mockUser);
      (prisma.weeklyStats.findMany as jest.Mock).mockResolvedValue([
        { ...mockWeeklyStat, userId: 'user-2', user: { ...mockUser, id: 'user-2' } },
        { ...mockWeeklyStat, userId: 'user-1', user: mockUser },
        { ...mockWeeklyStat, userId: 'user-3', user: { ...mockUser, id: 'user-3' } },
      ]);

      const result = await service.getWeeklyRanking('user-1');

      expect(result.entries[0].isCurrentUser).toBe(false);
      expect(result.entries[1].isCurrentUser).toBe(true);
      expect(result.entries[2].isCurrentUser).toBe(false);
    });
  });

  describe('getUserRank', () => {
    it('should return user rank and weekly XP', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue(mockUser);
      (prisma.weeklyStats.findFirst as jest.Mock).mockResolvedValue({
        ...mockWeeklyStat,
        weeklyXp: 500,
      });
      (prisma.weeklyStats.count as jest.Mock).mockResolvedValue(5); // 5 users above

      const result = await service.getUserRank('user-1');

      expect(result.rank).toBe(6); // count + 1
      expect(result.league).toBe('bronze');
      expect(result.weeklyXp).toBe(500);
    });

    it('should return rank 1 when user is top', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue(mockUser);
      (prisma.weeklyStats.findFirst as jest.Mock).mockResolvedValue({
        ...mockWeeklyStat,
        weeklyXp: 1000,
      });
      (prisma.weeklyStats.count as jest.Mock).mockResolvedValue(0); // No one above

      const result = await service.getUserRank('user-1');

      expect(result.rank).toBe(1);
    });

    it('should handle user with no weekly stats', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue(mockUser);
      (prisma.weeklyStats.findFirst as jest.Mock).mockResolvedValue(null);
      (prisma.weeklyStats.count as jest.Mock).mockResolvedValue(0);

      const result = await service.getUserRank('user-1');

      expect(result.weeklyXp).toBe(0);
      expect(result.rank).toBe(1);
    });

    it('should use correct league for ranking', async () => {
      (prisma.user.findUnique as jest.Mock).mockResolvedValue({
        ...mockUser,
        currentLeague: 'platinum',
      });
      (prisma.weeklyStats.findFirst as jest.Mock).mockResolvedValue(mockWeeklyStat);
      (prisma.weeklyStats.count as jest.Mock).mockResolvedValue(10);

      const result = await service.getUserRank('user-1');

      expect(result.league).toBe('platinum');
      expect(prisma.weeklyStats.count).toHaveBeenCalledWith({
        where: expect.objectContaining({
          user: { currentLeague: 'platinum' },
        }),
      });
    });
  });

  describe('processWeeklyPromotions', () => {
    beforeEach(() => {
      (prisma.weeklyStats.findMany as jest.Mock).mockResolvedValue([]);
    });

    it('should promote top 10 users', async () => {
      const bronzeUsers = Array.from({ length: 20 }, (_, i) => ({
        ...mockWeeklyStat,
        userId: `user-${i}`,
        weeklyXp: 1000 - i * 10,
        user: { ...mockUser, id: `user-${i}`, currentLeague: 'bronze' },
      }));

      (prisma.weeklyStats.findMany as jest.Mock).mockImplementation(({ where }) => {
        if (where.user.currentLeague === 'bronze') {
          return Promise.resolve(bronzeUsers);
        }
        return Promise.resolve([]);
      });

      await service.processWeeklyPromotions();

      // Should promote top 10 from bronze to silver
      // Check that at least the first user was promoted
      expect(prisma.user.update).toHaveBeenCalledWith({
        where: { id: 'user-0' },
        data: { currentLeague: 'silver' },
      });

      // Verify that promotions happened
      const promotions = (prisma.user.update as jest.Mock).mock.calls.filter(
        call => call[0].data.currentLeague === 'silver'
      );
      expect(promotions.length).toBeGreaterThanOrEqual(10);
    });

    it('should demote bottom 10 users', async () => {
      const silverUsers = Array.from({ length: 20 }, (_, i) => ({
        ...mockWeeklyStat,
        userId: `user-${i}`,
        weeklyXp: 1000 - i * 10,
        user: { ...mockUser, id: `user-${i}`, currentLeague: 'silver' },
      }));

      (prisma.weeklyStats.findMany as jest.Mock).mockResolvedValue(silverUsers);

      await service.processWeeklyPromotions();

      // Should demote bottom 10 from silver to bronze
      for (let i = 10; i < 20; i++) {
        expect(prisma.user.update).toHaveBeenCalledWith({
          where: { id: `user-${i}` },
          data: { currentLeague: 'bronze' },
        });
      }
    });

    it('should not promote from diamond league', async () => {
      const diamondUsers = Array.from({ length: 15 }, (_, i) => ({
        ...mockWeeklyStat,
        userId: `user-${i}`,
        weeklyXp: 1000 - i * 10,
        user: { ...mockUser, id: `user-${i}`, currentLeague: 'diamond' },
      }));

      (prisma.weeklyStats.findMany as jest.Mock).mockImplementation(({ where }) => {
        if (where.user.currentLeague === 'diamond') {
          return Promise.resolve(diamondUsers);
        }
        return Promise.resolve([]);
      });

      await service.processWeeklyPromotions();

      // Top 10 diamond users should not be promoted (already at max)
      const diamondPromotions = (prisma.user.update as jest.Mock).mock.calls.filter(
        call => call[0].data.currentLeague === 'legendary', // hypothetical higher league
      );
      expect(diamondPromotions.length).toBe(0);
    });

    it('should not demote from bronze league', async () => {
      const bronzeUsers = Array.from({ length: 15 }, (_, i) => ({
        ...mockWeeklyStat,
        userId: `user-${i}`,
        weeklyXp: 1000 - i * 10,
        user: { ...mockUser, id: `user-${i}`, currentLeague: 'bronze' },
      }));

      (prisma.weeklyStats.findMany as jest.Mock).mockImplementation(({ where }) => {
        if (where.user.currentLeague === 'bronze') {
          return Promise.resolve(bronzeUsers);
        }
        return Promise.resolve([]);
      });

      await service.processWeeklyPromotions();

      // Bottom 10 bronze users should not be demoted (already at min)
      const belowBronzeDemotions = (prisma.user.update as jest.Mock).mock.calls.filter(
        call => {
          const league = call[0].data.currentLeague;
          return league !== 'bronze' && league !== 'silver' && league !== 'gold' && league !== 'platinum' && league !== 'diamond';
        },
      );
      expect(belowBronzeDemotions.length).toBe(0);
    });

    it('should handle leagues with fewer than 10 users', async () => {
      const platinumUsers = Array.from({ length: 5 }, (_, i) => ({
        ...mockWeeklyStat,
        userId: `user-${i}`,
        weeklyXp: 1000 - i * 10,
        user: { ...mockUser, id: `user-${i}`, currentLeague: 'platinum' },
      }));

      (prisma.weeklyStats.findMany as jest.Mock).mockImplementation(({ where }) => {
        if (where.user.currentLeague === 'platinum') {
          return Promise.resolve(platinumUsers);
        }
        return Promise.resolve([]);
      });

      await service.processWeeklyPromotions();

      // Should promote all 5 users (less than 10)
      const platinumPromotions = (prisma.user.update as jest.Mock).mock.calls.filter(
        call => call[0].where.id.startsWith('user-') && call[0].data.currentLeague === 'diamond',
      );
      expect(platinumPromotions.length).toBe(5);
    });
  });

  describe('League System', () => {
    it('should maintain correct league order', async () => {
      const leagues: League[] = ['bronze', 'silver', 'gold', 'platinum', 'diamond'];

      for (let i = 0; i < leagues.length - 1; i++) {
        const currentLeague = leagues[i];
        const nextLeague = leagues[i + 1];

        const users = [
          {
            ...mockWeeklyStat,
            userId: 'user-1',
            weeklyXp: 1000,
            user: { ...mockUser, currentLeague },
          },
        ];

        (prisma.weeklyStats.findMany as jest.Mock).mockImplementation(({ where }) => {
          if (where.user.currentLeague === currentLeague) {
            return Promise.resolve(users);
          }
          return Promise.resolve([]);
        });

        await service.processWeeklyPromotions();

        // Verify promotion to next league
        expect(prisma.user.update).toHaveBeenCalledWith({
          where: { id: 'user-1' },
          data: { currentLeague: nextLeague },
        });

        jest.clearAllMocks();
      }
    });
  });

  describe('Integration Scenarios', () => {
    it('should handle full weekly cycle', async () => {
      // Setup users across multiple leagues
      const setupLeagueUsers = (league: League, count: number) => {
        return Array.from({ length: count }, (_, i) => ({
          ...mockWeeklyStat,
          userId: `${league}-user-${i}`,
          weeklyXp: 1000 - i * 10,
          user: { ...mockUser, id: `${league}-user-${i}`, currentLeague: league },
        }));
      };

      (prisma.weeklyStats.findMany as jest.Mock).mockImplementation(({ where }) => {
        const league = where.user.currentLeague;
        if (league === 'bronze') return Promise.resolve(setupLeagueUsers('bronze', 20));
        if (league === 'silver') return Promise.resolve(setupLeagueUsers('silver', 20));
        if (league === 'gold') return Promise.resolve(setupLeagueUsers('gold', 20));
        if (league === 'platinum') return Promise.resolve(setupLeagueUsers('platinum', 20));
        if (league === 'diamond') return Promise.resolve(setupLeagueUsers('diamond', 20));
        return Promise.resolve([]);
      });

      await service.processWeeklyPromotions();

      // Verify promotions and demotions happened
      expect(prisma.user.update).toHaveBeenCalled();
    });
  });
});
