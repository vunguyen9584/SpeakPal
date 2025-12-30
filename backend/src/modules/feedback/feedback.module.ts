import { Module } from '@nestjs/common';
import { FeedbackService } from './feedback.service';
import { VocabularyExtractorService } from './vocabulary-extractor.service';

@Module({
  providers: [FeedbackService, VocabularyExtractorService],
  exports: [FeedbackService, VocabularyExtractorService],
})
export class FeedbackModule {}
