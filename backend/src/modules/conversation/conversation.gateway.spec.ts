import { Test, TestingModule } from '@nestjs/testing';
import { ConversationGateway } from './conversation.gateway';
import { ConversationService } from './conversation.service';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';

describe('ConversationGateway', () => {
  let gateway: ConversationGateway;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ConversationGateway,
        {
          provide: ConversationService,
          useValue: {},
        },
        {
          provide: JwtService,
          useValue: {},
        },
        {
          provide: ConfigService,
          useValue: {},
        },
      ],
    }).compile();

    gateway = module.get<ConversationGateway>(ConversationGateway);
  });

  it('should be defined', () => {
    expect(gateway).toBeDefined();
  });
});
