import { Test, TestingModule } from '@nestjs/testing';
import { VocabularyService } from './vocabulary.service';
import { SrsService } from '../srs/srs.service';
import { VocabularyRepository } from './vocabulary.repository';

describe('VocabularyService', () => {
  let service: VocabularyService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        VocabularyService,
        {
          provide: VocabularyRepository,
          useValue: {},
        },
        {
          provide: SrsService,
          useValue: {
            getInterval: jest.fn(),
            calculateNextReview: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<VocabularyService>(VocabularyService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
