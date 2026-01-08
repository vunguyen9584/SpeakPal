import { Controller, Get, UseGuards } from '@nestjs/common';
import { BadgeService } from './badge.service';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../../common/decorators/current-user.decorator';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';

@ApiTags('Gamification - Badges')
@ApiBearerAuth()
@Controller('badges')
@UseGuards(JwtAuthGuard)
export class BadgeController {
  constructor(private readonly badgeService: BadgeService) {}

  @Get()
  @ApiOperation({ summary: 'Get all badges' })
  async listAll() {
    return this.badgeService.listAll();
  }

  @Get('mine')
  @ApiOperation({ summary: 'Get user earned badges' })
  async getMine(@CurrentUser('userId') userId: string) {
    return this.badgeService.listUserBadges(userId);
  }
}
