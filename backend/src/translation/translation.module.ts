import { Module } from '@nestjs/common';
import { TranslationController } from './translation.controller';
import { TranslationService } from './services/translation.service';
import {
  TranslationQuestionRepository,
  TranslationResultRepository,
  IntentQuestionRepository,
} from './repositories';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  controllers: [TranslationController],
  providers: [
    TranslationService,
    TranslationQuestionRepository,
    TranslationResultRepository,
    IntentQuestionRepository,
  ],
  exports: [TranslationService],
})
export class TranslationModule {}
