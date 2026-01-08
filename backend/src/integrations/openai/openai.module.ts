import { Module } from '@nestjs/common';
import { OpenAIClient } from './openai.client';
import { OpenAIService } from './openai.service';

@Module({
  providers: [OpenAIClient, OpenAIService],
  exports: [OpenAIService],
})
export class OpenAIModule {}
