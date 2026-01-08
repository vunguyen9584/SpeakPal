import { Module } from '@nestjs/common';
import { DeepgramClient } from './deepgram.client';
import { DeepgramService } from './deepgram.service';

@Module({
  providers: [DeepgramClient, DeepgramService],
  exports: [DeepgramService],
})
export class DeepgramModule {}
