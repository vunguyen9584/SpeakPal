import {
  Controller,
  Get,
  Post,
  Body,
  Query,
  Request,
  Param,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { ShadowingService } from './services/shadowing.service';
import { GetShadowingContentQueryDto, SubmitShadowingResultDto } from './dto';
import { ContentType, Level } from '@prisma/client';

@Controller('api/v1/shadowing')
@ApiTags('Shadowing Practice')
@ApiBearerAuth()
export class ShadowingController {
  constructor(private readonly service: ShadowingService) {}

  /**
   * GET /api/v1/shadowing/content
   * Get shadowing content for practice
   */
  @Get('content')
  @ApiOperation({
    summary: 'シャドーイングコンテンツ取得 (Get Shadowing Content)',
  })
  async getContent(
    @Query() query: GetShadowingContentQueryDto,
    @Request() req: any,
  ): Promise<any> {
    const userId = (req.user?.id as string) || 'demo-user';
    const userPlan = (req.user?.subscription?.plan as string) || 'FREE';

    return this.service.getShadowingContent(
      userId,
      query.contentType,
      query.level,
      userPlan,
    );
  }

  /**
   * POST /api/v1/shadowing/submit
   * Submit shadowing practice result
   */
  @Post('submit')
  @ApiOperation({ summary: 'シャドーイング結果送信 (Submit Shadowing Result)' })
  async submitResult(
    @Body() dto: SubmitShadowingResultDto,
    @Request() req: any,
  ): Promise<any> {
    const userId = (req.user?.id as string) || 'demo-user';

    return this.service.submitResult(
      userId,
      dto.contentId,
      dto.followingScore,
      dto.pronunciationScore,
      dto.rhythmScore,
      dto.durationSec,
      dto.details,
    );
  }

  /**
   * GET /api/v1/shadowing/list
   * Get list of available shadowing contents
   */
  @Get('list')
  @ApiOperation({
    summary: 'シャドーイングリスト取得 (Get Shadowing Content List)',
  })
  async getContentList(
    @Query('contentType') contentType: ContentType,
    @Query('level') level: Level,
    @Query('isPremium') isPremium: boolean,
    @Query('limit') limit: number = 20,
  ): Promise<any[]> {
    return this.service.getContentList(contentType, level, isPremium, limit);
  }

  /**
   * GET /api/v1/shadowing/history
   * Get user's shadowing practice history
   */
  @Get('history')
  @ApiOperation({ summary: 'シャドーイング履歴取得 (Get Shadowing History)' })
  async getHistory(
    @Query('limit') limit: number = 20,
    @Request() req: any,
  ): Promise<any[]> {
    const userId = req.user?.id || 'demo-user';

    return this.service.getHistory(userId, limit);
  }
}
