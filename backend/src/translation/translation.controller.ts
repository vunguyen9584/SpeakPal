import {
  Controller,
  Get,
  Post,
  Query,
  Body,
  UseInterceptors,
  UploadedFile,
  Request,
} from '@nestjs/common';
import type { RequestWithUser } from '../common/interfaces/request.interface';
import { FileInterceptor } from '@nestjs/platform-express';
import {
  ApiTags,
  ApiOperation,
  ApiConsumes,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { TranslationService } from './services/translation.service';
import {
  GetTranslationQuestionQueryDto,
  TranslationAnswerDto,
  TranslationQuestionResponseDto,
  TranslationResultResponseDto,
  GetIntentQuestionQueryDto,
  IntentAnswerDto,
} from './dto';

@Controller('api/v1/translation')
@ApiTags('Translation Practice')
@ApiBearerAuth()
export class TranslationController {
  constructor(private readonly translationService: TranslationService) {}

  /**
   * GET /api/v1/translation/questions
   * Get a translation question for practice
   */
  @Get('questions')
  @ApiOperation({ summary: '翻訳問題取得 (Get Translation Question)' })
  async getQuestion(
    @Query() query: GetTranslationQuestionQueryDto,
    @Request() req: RequestWithUser,
  ): Promise<TranslationQuestionResponseDto> {
    const userId = req.user.userId || req.user.id || 'demo-user';
    const userPlan = req.user.subscription?.plan || 'FREE';

    return this.translationService.getTranslationQuestion(
      userId,
      query.topic,
      query.level,
      userPlan,
    );
  }

  /**
   * POST /api/v1/translation/answers
   * Submit translation answer with audio
   */
  @Post('answers')
  @ApiOperation({ summary: '翻訳回答評価 (Evaluate Translation Answer)' })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('audio'))
  async submitAnswer(
    @Body() dto: TranslationAnswerDto,
    @UploadedFile() audio: Express.Multer.File,
    @Request() req: RequestWithUser,
  ): Promise<TranslationResultResponseDto> {
    const userId = req.user.userId || req.user.id || 'demo-user';
    const userPlan = req.user.subscription?.plan || 'FREE';

    // 1. Transcribe audio (mock for now - would use STT service)
    const transcript = this.mockTranscribe(audio);

    // 2. Evaluate translation
    return this.translationService.evaluateTranslation(
      userId,
      dto.questionId,
      transcript,
      dto.responseTimeSec,
      userPlan,
    );
  }

  /**
   * GET /api/v1/translation/intent-questions
   * Get an intent-based translation question
   */
  @Get('intent-questions')
  @ApiOperation({ summary: '意図問題取得 (Get Intent Question)' })
  async getIntentQuestion(
    @Query() query: GetIntentQuestionQueryDto,
    @Request() req: RequestWithUser,
  ): Promise<unknown> {
    const userId = req.user.userId || req.user.id || 'demo-user';
    const userPlan = req.user.subscription?.plan || 'FREE';

    return this.translationService.getIntentQuestion(
      userId,
      query.category,
      query.level,
      userPlan,
    );
  }

  /**
   * POST /api/v1/translation/intent-answers
   * Submit intent expression answer
   */
  @Post('intent-answers')
  @ApiOperation({ summary: '意図回答評価 (Evaluate Intent Expression)' })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('audio'))
  async submitIntentAnswer(
    @Body() dto: IntentAnswerDto,
    @UploadedFile() audio: Express.Multer.File,
    @Request() req: RequestWithUser,
  ): Promise<unknown> {
    const userId = req.user.userId || req.user.id || 'demo-user';

    // 1. Transcribe audio
    const transcript = this.mockTranscribe(audio);

    // 2. Evaluate intent expression
    return this.translationService.evaluateIntentExpression(
      userId,
      dto.questionId,
      transcript,
    );
  }

  /**
   * Mock audio transcription
   * In production, this would call Deepgram or similar STT service
   */
  private mockTranscribe(audio: Express.Multer.File): string {
    if (!audio) {
      return 'This is a mock transcription for testing';
    }
    // Would actually transcribe audio here
    return 'The weather is nice today';
  }
}
