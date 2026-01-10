import { Test, TestingModule } from '@nestjs/testing';
import { XpService } from './xp.service';
import { PrismaService } from '../../../prisma/prisma.service';
import { League } from '@prisma/client';

describe('XpService', () => {
  let service: XpService;
  let prisma: jest.Mocked<any>;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        XpService,
        {
          provide: PrismaService,
          useValue: {
            user: {
              findUnique: jest.fn(),
              update: jest.fn(),
            },
            userRanking: {
              findUnique: jest.fn(),
              update: jest.fn(),
              create: jest.fn(),
            },
          },
        },
      ],
    }).compile();

    service = module.get<XpService>(XpService);
    prisma = module.get(PrismaService);
  });

  describe('calculateLevel', () => {
    it('should calculate level 1 for 0 XP', () => {
      expect(service.calculateLevel(0)).toBe(1);
    });
    it('should calculate level 2 for 200 XP', () => {
      expect(service.calculateLevel(200)).toBe(2);
    });
  });

  describe('addXP', () => {
    const mockUser = {
      id: 'user-123',
      totalXp: 0,
      league: League.BRONZE,
    };

    it('should add xp and return new state', async () => {
      prisma.user.findUnique.mockResolvedValue(mockUser);
      prisma.user.update.mockResolvedValue({ ...mockUser, totalXp: 100 });
      prisma.userRanking.findUnique.mockResolvedValue(null);

      const result = await service.addXP('user-123', 100, 'test');

      expect(result.totalXp).toBe(100);
      expect(result.leveledUp).toBe(false);
      expect(prisma.user.update).toHaveBeenCalled();
    });

    it('should detect level up', async () => {
      prisma.user.findUnique.mockResolvedValue({ ...mockUser, totalXp: 190 }); // Level 1
      prisma.user.update.mockResolvedValue({ ...mockUser, totalXp: 210 });

      const result = await service.addXP('user-123', 20, 'test'); // 190 + 20 = 210 -> Level 2

      expect(result.leveledUp).toBe(true);
      expect(result.newLevel).toBe(2);
    });
  });
});
