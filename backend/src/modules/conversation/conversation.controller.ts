import {
  Controller,
  Get,
  Post,
  Param,
  Query,
  Body,
  UseGuards,
  Req,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { ConversationService } from './conversation.service';
import { TurnService } from './turn.service';
import { CreateConversationDto } from './dto/create-conversation.dto';
import { ConversationResponseDto } from './dto/conversation-response.dto';
import { ConversationSummaryDto } from './dto/conversation-summary.dto';
import { TurnDto } from './dto/turn.dto';
import { ListConversationsQueryDto } from './dto/list-conversations-query.dto';

@ApiTags('conversations')
@Controller('conversations')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class ConversationController {
  constructor(
    private readonly conversationService: ConversationService,
    private readonly turnService: TurnService,
  ) {}

  @Get()
  @ApiOperation({ summary: 'List user conversations' })
  @ApiResponse({
    status: 200,
    description: 'Returns paginated conversation list',
  })
  async list(@Req() req, @Query() query: ListConversationsQueryDto) {
    const userId = req.user.id;
    return this.conversationService.listConversations(userId, query);
  }

  @Post()
  @ApiOperation({ summary: 'Start new conversation' })
  @ApiResponse({
    status: 201,
    description: 'Conversation created successfully',
    type: ConversationResponseDto,
  })
  @ApiResponse({
    status: 403,
    description: 'Daily limit reached for free users',
  })
  async create(
    @Req() req,
    @Body() dto: CreateConversationDto,
  ): Promise<ConversationResponseDto> {
    const userId = req.user.id;
    const userPlan = req.user.subscriptionPlan || 'free';
    return this.conversationService.createSession(userId, dto, userPlan);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get conversation details' })
  @ApiResponse({ status: 200, description: 'Returns conversation details' })
  @ApiResponse({ status: 404, description: 'Conversation not found' })
  @ApiResponse({ status: 403, description: 'Not authorized' })
  async get(@Req() req, @Param('id') id: string) {
    const userId = req.user.id;
    return this.conversationService.getConversation(userId, id);
  }

  @Post(':id/end')
  @ApiOperation({ summary: 'End conversation' })
  @ApiResponse({
    status: 200,
    description: 'Conversation ended successfully',
    type: ConversationSummaryDto,
  })
  @ApiResponse({ status: 404, description: 'Conversation not found' })
  @ApiResponse({ status: 403, description: 'Not authorized' })
  async end(@Req() req, @Param('id') id: string) {
    const userId = req.user.id;
    // TODO: Calculate summary and score from conversation data
    const summary = 'Conversation summary will be generated here';
    const score = 0;
    await this.conversationService.endSession(userId, id, summary, score);

    // TODO: Return full summary with XP calculation
    return new ConversationSummaryDto({
      id,
      summary,
      durationSeconds: 0,
      pronunciationScore: score,
      xpEarned: 0,
      corrections: [],
    });
  }

  @Get(':id/turns')
  @ApiOperation({ summary: 'Get conversation turns' })
  @ApiResponse({
    status: 200,
    description: 'Returns all turns in the conversation',
    type: [TurnDto],
  })
  @ApiResponse({ status: 404, description: 'Conversation not found' })
  @ApiResponse({ status: 403, description: 'Not authorized' })
  async getTurns(@Req() req, @Param('id') id: string): Promise<TurnDto[]> {
    const userId = req.user.id;
    // Verify ownership first
    await this.conversationService.getConversation(userId, id);

    const turns = await this.turnService.getTurns(id);
    return turns.map((turn) => new TurnDto(turn));
  }
}

