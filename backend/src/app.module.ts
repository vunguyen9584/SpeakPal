import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule } from './config/config.module';
import { PrismaModule } from './prisma/prisma.module';
import { CacheModule } from './cache/cache.module';
import { AuthModule } from './modules/auth/auth.module';
import { UserModule } from './modules/user/user.module';
import { PersonaModule } from './modules/persona/persona.module';
import { ConversationModule } from './modules/conversation/conversation.module';
import { FeedbackModule } from './modules/feedback/feedback.module';
import { LearningModule } from './modules/learning/learning.module';
import { GamificationModule } from './modules/gamification/gamification.module';

@Module({
  imports: [ConfigModule, PrismaModule, CacheModule, AuthModule, UserModule, PersonaModule, ConversationModule, FeedbackModule, LearningModule, GamificationModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
