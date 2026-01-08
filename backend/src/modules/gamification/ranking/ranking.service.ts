import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';
import {
  RankingResponseDto,
  RankingEntryDto,
  League as DtoLeague,
} from './dto/ranking-response.dto';
import { League as PrismaLeague, Prisma } from '@prisma/client';

const LEAGUE_ORDER: DtoLeague[] = [
  DtoLeague.BRONZE,
  DtoLeague.SILVER,
  DtoLeague.GOLD,
  DtoLeague.PLATINUM,
  DtoLeague.DIAMOND,
];

@Injectable()
export class RankingService {
  constructor(private readonly prisma: PrismaService) {}

  async getWeeklyRanking(
    userId: string,
    league?: DtoLeague,
  ): Promise<RankingResponseDto> {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    const currentLeague =
      league || (user?.league as unknown as DtoLeague) || DtoLeague.BRONZE;
    const weekNumber = this.getCurrentWeekNumber();
    const year = new Date().getFullYear();

    const rankings = (await this.prisma.userRanking.findMany({
      where: {
        weekNumber,
        year,
        league: currentLeague as unknown as PrismaLeague,
      },
      include: { user: true },
      orderBy: { weeklyXp: 'desc' },
      take: 50,
    })) as unknown as Array<{
      id: string;
      userId: string;
      weeklyXp: number;
      user: { username: string | null };
    }>;

    const entries: RankingEntryDto[] = rankings.map((ranking, index) => ({
      rank: index + 1,
      userId: ranking.userId,
      username: ranking.user.username || 'User',
      avatarUrl: '', // avatarUrl not in schema
      weeklyXp: ranking.weeklyXp,
      isCurrentUser: ranking.userId === userId,
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

  async getUserRank(
    userId: string,
  ): Promise<{ rank: number; league: PrismaLeague; weeklyXp: number }> {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    const weekNumber = this.getCurrentWeekNumber();
    const year = new Date().getFullYear();

    const userRanking = await this.prisma.userRanking.findFirst({
      where: { userId, weekNumber, year },
    });

    const rank = await this.prisma.userRanking.count({
      where: {
        weekNumber,
        year,
        weeklyXp: { gt: userRanking?.weeklyXp || 0 },
        league: user?.league,
      },
    });

    return {
      rank: rank + 1,
      league: user?.league || PrismaLeague.BRONZE,
      weeklyXp: userRanking?.weeklyXp || 0,
    };
  }

  async processWeeklyPromotions(): Promise<void> {
    const weekNumber = this.getCurrentWeekNumber() - 1;
    const year = new Date().getFullYear();

    for (const league of LEAGUE_ORDER) {
      const rankings = await this.prisma.userRanking.findMany({
        where: {
          weekNumber,
          year,
          league: league as unknown as Prisma.EnumLeagueFilter,
        },
        include: { user: true },
        orderBy: { weeklyXp: 'desc' },
      });

      // Promote top 10
      for (let i = 0; i < Math.min(10, rankings.length); i++) {
        const nextLeagueIndex = LEAGUE_ORDER.indexOf(league) + 1;
        if (nextLeagueIndex < LEAGUE_ORDER.length) {
          await this.prisma.user.update({
            where: { id: rankings[i].userId },
            data: {
              league: LEAGUE_ORDER[nextLeagueIndex] as unknown as PrismaLeague,
            },
          });
        }
      }

      // Demote bottom 10
      if (rankings.length > 10) {
        for (
          let i = Math.max(0, rankings.length - 10);
          i < rankings.length;
          i++
        ) {
          const prevLeagueIndex = LEAGUE_ORDER.indexOf(league) - 1;
          if (prevLeagueIndex >= 0) {
            await this.prisma.user.update({
              where: { id: rankings[i].userId },
              data: {
                league: LEAGUE_ORDER[
                  prevLeagueIndex
                ] as unknown as PrismaLeague,
              },
            });
          }
        }
      }
    }
  }

  private getCurrentWeekNumber(): number {
    const now = new Date();
    const onejan = new Date(now.getFullYear(), 0, 1);
    return Math.ceil(
      ((now.getTime() - onejan.getTime()) / 86400000 + onejan.getDay() + 1) / 7,
    );
  }
}
