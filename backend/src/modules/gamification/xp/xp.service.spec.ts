import { Test, TestingModule } from '@nestjs/testing';
import { XpService } from './xp.service';
import { PrismaService } from '../../../prisma/prisma.service';

describe('XpService', () => {
  let service: XpService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        XpService,
        {
          provide: PrismaService,
          useValue: {},
        },
      ],
    }).compile();

    service = module.get<XpService>(XpService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
