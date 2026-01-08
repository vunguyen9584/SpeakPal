import { Test, TestingModule } from '@nestjs/testing';
import { ScenarioService } from './scenario.service';
import { ScenarioRepository } from './scenario.repository';

describe('ScenarioService', () => {
  let service: ScenarioService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ScenarioService,
        {
          provide: ScenarioRepository,
          useValue: {},
        },
      ],
    }).compile();

    service = module.get<ScenarioService>(ScenarioService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
