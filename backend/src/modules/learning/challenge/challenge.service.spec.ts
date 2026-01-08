import { Test, TestingModule } from '@nestjs/testing';
import { ChallengeService } from './challenge.service';
import { PrismaService } from '../../../prisma/prisma.service';
import { ChallengeRepository } from './challenge.repository';

describe('ChallengeService', () => {
  let service: ChallengeService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ChallengeService,
        {
          provide: ChallengeRepository,
          useValue: {},
        },
        {
          provide: PrismaService,
          useValue: {},
        },
      ],
    }).compile();

    service = module.get<ChallengeService>(ChallengeService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
