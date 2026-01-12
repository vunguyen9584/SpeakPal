import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { StatsService } from './stats/stats.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';

@ApiTags('Progress')
@ApiBearerAuth()
@Controller('progress')
@UseGuards(JwtAuthGuard)
export class ProgressController {
  constructor(private readonly statsService: StatsService) { }

  @Get('stats')
  @ApiOperation({ summary: 'Get user statistics' })
  async getStats(@CurrentUser('userId') userId: string) {
    return this.statsService.getUserStats(userId);
  }

  @Get('weekly-report')
  @ApiOperation({ summary: 'Get weekly progress report' })
  async getWeeklyReport(
    @CurrentUser('userId') userId: string,
    @Query('week') week?: string,
  ) {
    const weekOffset = week ? parseInt(week, 10) : 0;
    return this.statsService.getWeeklyReport(userId, weekOffset);
  }

  @Get('monthly-report')
  @ApiOperation({ summary: 'Get monthly progress report' })
  async getMonthlyReport(
    @CurrentUser('userId') userId: string,
    @Query('month') month?: string,
  ) {
    const monthOffset = month ? parseInt(month, 10) : 0;
    return this.statsService.getMonthlyReport(userId, monthOffset);
  }

  @Get('history')
  @ApiOperation({ summary: 'Get learning history with pagination' })
  async getHistory(
    @CurrentUser('userId') userId: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
    @Query('type') type?: 'conversation' | 'vocabulary' | 'shadowing' | 'all',
  ) {
    const pageNum = page ? parseInt(page, 10) : 1;
    const limitNum = limit ? parseInt(limit, 10) : 20;
    return this.statsService.getLearningHistory(userId, pageNum, limitNum, type);
  }
}
