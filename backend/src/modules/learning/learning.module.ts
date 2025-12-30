import { Module } from '@nestjs/common';
import { VocabularyController } from './vocabulary/vocabulary.controller';
import { ScenarioController } from './scenario/scenario.controller';
import { ChallengeController } from './challenge/challenge.controller';
import { VocabularyService } from './vocabulary/vocabulary.service';
import { ScenarioService } from './scenario/scenario.service';
import { ChallengeService } from './challenge/challenge.service';
import { SrsService } from './srs/srs.service';
import { VocabularyRepository } from './vocabulary/vocabulary.repository';
import { ScenarioRepository } from './scenario/scenario.repository';
import { ChallengeRepository } from './challenge/challenge.repository';
import { PrismaModule } from '../../common/prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  controllers: [VocabularyController, ScenarioController, ChallengeController],
  providers: [
    VocabularyService,
    VocabularyRepository,
    ScenarioService,
    ScenarioRepository,
    ChallengeService,
    ChallengeRepository,
    SrsService,
  ],
  exports: [VocabularyService, ScenarioService, ChallengeService],
})
export class LearningModule {}
