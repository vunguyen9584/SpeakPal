import { Test, TestingModule } from '@nestjs/testing';
import { FeedbackService } from './feedback.service';
import { ConfigService } from '@nestjs/config';

// Mock global fetch
global.fetch = jest.fn();

describe('FeedbackService', () => {
  let service: FeedbackService;
  let configService: jest.Mocked<ConfigService>;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        FeedbackService,
        {
          provide: ConfigService,
          useValue: {
            get: jest.fn((key, defaultVal) => {
              if (key === 'externalServices.openai.apiKey') return 'key';
              return defaultVal;
            })
          }
        }
      ]
    }).compile();

    service = module.get<FeedbackService>(FeedbackService);
    configService = module.get(ConfigService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('analyzeAndCorrect', () => {
    const mockResponse = {
      choices: [{
        message: {
          content: JSON.stringify({
            corrections: [
              { original: 'hi', correction: 'hello', severity: 'high', explanation: 'informal' }
            ]
          })
        }
      }]
    };

    it('should call openai and return corrections', async () => {
      (global.fetch as jest.Mock).mockResolvedValue({
        ok: true,
        json: async () => mockResponse
      });

      const result = await service.analyzeAndCorrect('hi', { userLevel: 'beginner' });

      expect(result.corrections).toHaveLength(1);
      expect(global.fetch).toHaveBeenCalled();
    });

    it('should handle api error gracefully', async () => {
      (global.fetch as jest.Mock).mockRejectedValue(new Error('API Fail'));

      const result = await service.analyzeAndCorrect('hi', { userLevel: 'beginner' });

      expect(result.corrections).toEqual([]);
      expect(result.overallAccuracy).toBe(100);
    });

    it('should use cache if available', async () => {
      // First call to populate cache
      (global.fetch as jest.Mock).mockResolvedValue({
        ok: true,
        json: async () => mockResponse
      });
      await service.analyzeAndCorrect('hi', { userLevel: 'beginner' });

      // Second call
      await service.analyzeAndCorrect('hi', { userLevel: 'beginner' });

      expect(global.fetch).toHaveBeenCalledTimes(1); // Only once
    });
  });
});
