import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { CacheModule } from '@nestjs/cache-manager';
import { ConversationController } from './conversation.controller';
import { ConversationService } from './conversation.service';
import { ConversationGateway } from './conversation.gateway';
import { ConversationRepository } from './conversation.repository';
import { TurnRepository } from './turn.repository';
import { TurnService } from './turn.service';
import { XPCalculatorService } from './xp-calculator.service';
import { WsRateLimiter } from './ws-rate-limiter';
import { PrismaModule } from '../../common/services/prisma.module';

@Module({
  imports: [
    PrismaModule,
    JwtModule.register({}), // Will use config from service
    CacheModule.register(),
  ],
  controllers: [ConversationController],
  providers: [
    ConversationService,
    ConversationGateway,
    ConversationRepository,
    TurnRepository,
    TurnService,
    XPCalculatorService,
    WsRateLimiter,
  ],
  exports: [
    ConversationService,
    ConversationRepository,
    TurnRepository,
    TurnService,
    XPCalculatorService,
    WsRateLimiter,
  ],
})
export class ConversationModule {}
