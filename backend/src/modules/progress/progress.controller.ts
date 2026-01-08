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
  constructor(private readonly statsService: StatsService) {}

  @Get('stats')
  @ApiOperation({ summary: 'Get user statistics' })
  async getStats(@CurrentUser('userId') userId: string) {
    return this.statsService.getUserStats(userId);
  }
}
