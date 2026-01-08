import {
  Controller,
  Post,
  Body,
  UploadedFile,
  UseInterceptors,
  Res,
  BadRequestException,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import type { Response } from 'express';
import { DeepgramService } from '../deepgram/deepgram.service';
import { OpenAIService } from '../openai/openai.service';
import { ElevenLabsService } from '../elevenlabs/elevenlabs.service';
import { AppStoreService } from '../appstore/appstore.service';
import { PlayStoreService } from '../playstore/playstore.service';
import {
  TestOpenAIDto,
  TestElevenLabsDto,
  TestAppStoreDto,
  TestPlayStoreDto,
} from './test.dto';

@Controller('test-integrations')
export class TestIntegrationController {
  constructor(
    private readonly deepgramService: DeepgramService,
    private readonly openaiService: OpenAIService,
    private readonly elevenLabsService: ElevenLabsService,
    private readonly appStoreService: AppStoreService,
    private readonly playStoreService: PlayStoreService,
  ) {}

  @Post('deepgram')
  @UseInterceptors(FileInterceptor('audio'))
  async testDeepgram(@UploadedFile() file: Express.Multer.File) {
    if (!file) {
      throw new BadRequestException('Audio file is required');
    }
    const result = await this.deepgramService.transcribeAudioFile(file.buffer);
    return result;
  }

  @Post('openai')
  async testOpenAI(@Body() dto: TestOpenAIDto) {
    const context = {
      personaId: dto.persona || 'default',
      topic: 'general',
      level: 'intermediate',
      conversationHistory: [{ role: 'user' as const, content: dto.message }],
    };
    const response =
      await this.openaiService.generateConversationResponse(context);
    return { response };
  }

  @Post('elevenlabs')
  async testElevenLabs(@Body() dto: TestElevenLabsDto, @Res() res: Response) {
    const audioBuffer = await this.elevenLabsService.textToSpeech({
      text: dto.text,
      voiceId: dto.voiceId,
    });

    res.set({
      'Content-Type': 'audio/mpeg',
      'Content-Length': audioBuffer.length,
    });
    res.end(audioBuffer);
  }

  @Post('appstore')
  async testAppStore(@Body() dto: TestAppStoreDto) {
    const result = await this.appStoreService.verifyReceipt(dto.receiptData);
    return result;
  }

  @Post('playstore')
  async testPlayStore(@Body() dto: TestPlayStoreDto) {
    const result = await this.playStoreService.verifySubscriptionPurchase({
      packageName: 'com.speakpal.app', // Should match env config
      productId: dto.productId,
      purchaseToken: dto.purchaseToken,
    });
    return result;
  }
}
