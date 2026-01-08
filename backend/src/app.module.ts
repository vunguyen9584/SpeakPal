import { Module } from '@nestjs/common';
import { ScheduleModule } from '@nestjs/schedule';
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
import { ProgressModule } from './modules/progress/progress.module';
import { SocialModule } from './modules/social/social.module';
import { SubscriptionModule } from './modules/subscription/subscription.module';
import { FirebaseModule } from './integrations/firebase/firebase.module';
import { NotificationModule } from './modules/notification/notification.module';
import { TranslationModule } from './translation/translation.module';
import { QuickResponseModule } from './quick-response/quick-response.module';
import { ShadowingModule } from './shadowing/shadowing.module';

@Module({
  imports: [
    ScheduleModule.forRoot(),
    ConfigModule,
    PrismaModule,
    CacheModule,
    FirebaseModule,
    AuthModule,
    UserModule,
    PersonaModule,
    ConversationModule,
    FeedbackModule,
    LearningModule,
    GamificationModule,
    ProgressModule,
    SocialModule,
    SubscriptionModule,
    NotificationModule,
    TranslationModule,
    QuickResponseModule,
    ShadowingModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
