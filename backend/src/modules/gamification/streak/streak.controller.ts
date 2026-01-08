import { Controller, Get, Post, UseGuards } from '@nestjs/common';
import { StreakService } from './streak.service';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../../common/decorators/current-user.decorator';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';

@ApiTags('Gamification - Streaks')
@ApiBearerAuth()
@Controller('streaks')
@UseGuards(JwtAuthGuard)
export class StreakController {
  constructor(private readonly streakService: StreakService) {}

  @Get()
  @ApiOperation({ summary: 'Get current streak status' })
  async getStreak(@CurrentUser('userId') userId: string) {
    return this.streakService.getStreakStatus(userId);
  }

  @Post('freeze')
  @ApiOperation({ summary: 'Use streak freeze' })
  async useFreeze(@CurrentUser('userId') userId: string) {
    return this.streakService.useFreeze(userId);
  }
}
