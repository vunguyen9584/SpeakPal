import { Module } from '@nestjs/common';
import { ProgressController } from './progress.controller';
import { StatsService } from './stats/stats.service';
import { ReportService } from './report/report.service';
import { HistoryService } from './history/history.service';
import { PrismaModule } from '../../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  controllers: [ProgressController],
  providers: [StatsService, ReportService, HistoryService],
  exports: [StatsService],
})
export class ProgressModule {}
