import { Controller, Get, Post, Body, Query, Request } from '@nestjs/common';
import type { RequestWithUser } from '../common/interfaces/request.interface';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { QuickResponseService } from './services/quick-response.service';
import { StartQuickResponseSessionDto, SubmitQuickResponseDto } from './dto';
import { PracticeType } from '@prisma/client';

@Controller('api/v1/quick-response')
@ApiTags('Quick Response Practice')
@ApiBearerAuth()
export class QuickResponseController {
  constructor(private readonly service: QuickResponseService) {}

  /**
   * POST /api/v1/quick-response/start
   * Start a new quick response session
   */
  @Post('start')
  @ApiOperation({
    summary: 'クイックレスポンスセッション開始 (Start Quick Response Session)',
  })
  async startSession(
    @Body() dto: StartQuickResponseSessionDto,
    @Request() req: RequestWithUser,
  ): Promise<unknown> {
    const userId = req.user.userId || req.user.id || 'demo-user';
    const userPlan = req.user.subscription?.plan || 'FREE';

    return this.service.startSession(
      userId,
      dto.practiceType,
      dto.difficulty,
      userPlan,
    );
  }

  /**
   * POST /api/v1/quick-response/submit
   * Submit quick response session results
   */
  @Post('submit')
  @ApiOperation({
    summary: 'クイックレスポンス結果送信 (Submit Quick Response Results)',
  })
  async submitResult(
    @Body() dto: SubmitQuickResponseDto,
    @Request() req: RequestWithUser,
  ): Promise<unknown> {
    const userId = req.user.userId || req.user.id || 'demo-user';

    // Determine practice type from session (would normally fetch from session store)
    const practiceType = PracticeType.WORD_ASSOCIATION;

    return this.service.submitResult(
      userId,
      dto.sessionId,
      practiceType,
      dto.totalScore,
      dto.correctCount,
      dto.maxChain,
      dto.durationSec,
      dto.details,
    );
  }

  /**
   * GET /api/v1/quick-response/history
   * Get user's quick response history
   */
  @Get('history')
  @ApiOperation({
    summary: 'クイックレスポンス履歴取得 (Get Quick Response History)',
  })
  async getHistory(
    @Query('practiceType') practiceType: PracticeType,
    @Query('limit') limit: number = 20,
    @Request() req: RequestWithUser,
  ): Promise<unknown[]> {
    const userId = req.user.userId || req.user.id || 'demo-user';

    return this.service.getHistory(userId, practiceType, limit);
  }
}
