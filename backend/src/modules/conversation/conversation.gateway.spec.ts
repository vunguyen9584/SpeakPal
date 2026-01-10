import { Test, TestingModule } from '@nestjs/testing';
import { ConversationGateway } from './conversation.gateway';
import { ConversationService } from './conversation.service';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { WsRateLimiter } from './ws-rate-limiter';
import { CACHE_MANAGER } from '@nestjs/cache-manager';

describe('ConversationGateway', () => {
  let gateway: ConversationGateway;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ConversationGateway,
        {
          provide: ConversationService,
          useValue: {
            // Mock methods if needed by gateway init
          },
        },
        {
          provide: JwtService,
          useValue: {},
        },
        {
          provide: ConfigService,
          useValue: {
            get: jest.fn().mockReturnValue([]),
          },
        },
        {
          provide: WsRateLimiter,
          useValue: {}
        },
        {
          provide: CACHE_MANAGER,
          useValue: {}
        }
      ],
    }).compile();

    gateway = module.get<ConversationGateway>(ConversationGateway);
  });

  it('should be defined', () => {
    expect(gateway).toBeDefined();
  });
});
