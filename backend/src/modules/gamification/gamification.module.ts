import { Module } from '@nestjs/common';
import { XpService } from './xp/xp.service';
import { StreakService } from './streak/streak.service';
import { BadgeService } from './badge/badge.service';
import { RankingService } from './ranking/ranking.service';
import { StreakController } from './streak/streak.controller';
import { BadgeController } from './badge/badge.controller';
import { RankingController } from './ranking/ranking.controller';
import { PrismaModule } from '../../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [XpService, StreakService, BadgeService, RankingService],
  controllers: [StreakController, BadgeController, RankingController],
  exports: [XpService, StreakService, BadgeService, RankingService],
})
export class GamificationModule {}
