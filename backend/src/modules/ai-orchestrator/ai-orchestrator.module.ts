import { Module } from '@nestjs/common';
import { AIOrchestrator } from './ai-orchestrator.service';
import { STTService } from './stt.service';
import { LLMService } from './llm.service';
import { TTSService } from './tts.service';
import { StreamingHandler } from './streaming-handler';
import { FallbackHandler } from './fallback-handler';

@Module({
  providers: [
    AIOrchestrator,
    STTService,
    LLMService,
    TTSService,
    StreamingHandler,
    FallbackHandler,
  ],
  exports: [
    AIOrchestrator,
    STTService,
    LLMService,
    TTSService,
    StreamingHandler,
    FallbackHandler,
  ],
})
export class AIOrchestratorModule {}
