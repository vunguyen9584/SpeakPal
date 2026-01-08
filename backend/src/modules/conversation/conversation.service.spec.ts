import { Test, TestingModule } from '@nestjs/testing';
import { ConversationService } from './conversation.service';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { ConversationRepository } from './conversation.repository';

describe('ConversationService', () => {
  let service: ConversationService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ConversationService,
        {
          provide: ConversationRepository,
          useValue: {},
        },
        {
          provide: JwtService,
          useValue: {},
        },
        {
          provide: 'CACHE_MANAGER',
          useValue: {},
        },
        {
          provide: ConfigService,
          useValue: {},
        },
      ],
    }).compile();

    service = module.get<ConversationService>(ConversationService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
