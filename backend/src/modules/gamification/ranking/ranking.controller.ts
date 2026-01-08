import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { RankingService } from './ranking.service';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../../common/decorators/current-user.decorator';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { League } from './dto/ranking-response.dto';

@ApiTags('Gamification - Rankings')
@ApiBearerAuth()
@Controller('rankings')
@UseGuards(JwtAuthGuard)
export class RankingController {
  constructor(private readonly rankingService: RankingService) {}

  @Get('weekly')
  @ApiOperation({ summary: 'Get weekly leaderboard' })
  async getWeeklyRanking(
    @CurrentUser('userId') userId: string,
    @Query('league') league?: League,
  ) {
    return this.rankingService.getWeeklyRanking(userId, league);
  }
}
