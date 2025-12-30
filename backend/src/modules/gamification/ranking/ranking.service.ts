import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';
import { RankingResponseDto, RankingEntryDto, League } from './dto/ranking-response.dto';

const LEAGUE_ORDER: League[] = ['bronze', 'silver', 'gold', 'platinum', 'diamond'];

@Injectable()
export class RankingService {
  constructor(private readonly prisma: PrismaService) {}

  async getWeeklyRanking(userId: string, league?: League): Promise<RankingResponseDto> {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    const currentLeague = league || (user?.currentLeague as League) || 'bronze';
    const weekNumber = this.getCurrentWeekNumber();

    const weeklyStats = await this.prisma.weeklyStats.findMany({
      where: {
        weekNumber,
        user: { currentLeague: currentLeague },
      },
      include: { user: true },
      orderBy: { weeklyXp: 'desc' },
      take: 50,
    });

    const entries: RankingEntryDto[] = weeklyStats.map((stat, index) => ({
      rank: index + 1,
      userId: stat.userId,
      username: stat.user.username,
      avatarUrl: stat.user.avatarUrl || '',
      weeklyXp: stat.weeklyXp,
      isCurrentUser: stat.userId === userId,
    }));

    const currentUserRank = entries.findIndex((e) => e.userId === userId) + 1;

    return {
      league: currentLeague,
      weekNumber,
      entries,
      currentUserRank: currentUserRank > 0 ? currentUserRank : undefined,
      promotionZone: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
      demotionZone: [41, 42, 43, 44, 45, 46, 47, 48, 49, 50],
    };
  }

  async getUserRank(userId: string): Promise<{ rank: number; league: League; weeklyXp: number }> {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    const weekNumber = this.getCurrentWeekNumber();

    const userStat = await this.prisma.weeklyStats.findFirst({
      where: { userId, weekNumber },
    });

    const rank = await this.prisma.weeklyStats.count({
      where: {
        weekNumber,
        weeklyXp: { gt: userStat?.weeklyXp || 0 },
        user: { currentLeague: user?.currentLeague },
      },
    });

    return {
      rank: rank + 1,
      league: (user?.currentLeague as League) || 'bronze',
      weeklyXp: userStat?.weeklyXp || 0,
    };
  }

  async processWeeklyPromotions(): Promise<void> {
    const weekNumber = this.getCurrentWeekNumber() - 1;

    for (const league of LEAGUE_ORDER) {
      const stats = await this.prisma.weeklyStats.findMany({
        where: {
          weekNumber,
          user: { currentLeague: league },
        },
        include: { user: true },
        orderBy: { weeklyXp: 'desc' },
      });

      // Promote top 10
      for (let i = 0; i < Math.min(10, stats.length); i++) {
        const nextLeagueIndex = LEAGUE_ORDER.indexOf(league) + 1;
        if (nextLeagueIndex < LEAGUE_ORDER.length) {
          await this.prisma.user.update({
            where: { id: stats[i].userId },
            data: { currentLeague: LEAGUE_ORDER[nextLeagueIndex] },
          });
        }
      }

      // Demote bottom 10
      if (stats.length > 10) {
        for (let i = Math.max(0, stats.length - 10); i < stats.length; i++) {
          const prevLeagueIndex = LEAGUE_ORDER.indexOf(league) - 1;
          if (prevLeagueIndex >= 0) {
            await this.prisma.user.update({
              where: { id: stats[i].userId },
              data: { currentLeague: LEAGUE_ORDER[prevLeagueIndex] },
            });
          }
        }
      }
    }
  }

  private getCurrentWeekNumber(): number {
    const now = new Date();
    const onejan = new Date(now.getFullYear(), 0, 1);
    return Math.ceil(((now.getTime() - onejan.getTime()) / 86400000 + onejan.getDay() + 1) / 7);
  }
}

