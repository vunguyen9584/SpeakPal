import { Test, TestingModule } from '@nestjs/testing';
import { ForbiddenException } from '@nestjs/common';
import { UsageService } from '../usage.service';
import { PlanService } from '../plan.service';
import { PrismaService } from '../../../prisma/prisma.service';

describe('UsageService', () => {
  let service: UsageService;
  let planService: PlanService;
  let prisma: PrismaService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UsageService,
        {
          provide: PlanService,
          useValue: {
            getCurrentPlan: jest.fn(),
          },
        },
        {
          provide: PrismaService,
          useValue: {
            dailyUsage: {
              findUnique: jest.fn(),
              upsert: jest.fn(),
              deleteMany: jest.fn(),
            },
          },
        },
      ],
    }).compile();

    service = module.get<UsageService>(UsageService);
    planService = module.get<PlanService>(PlanService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('checkAndIncrementUsage', () => {
    it('should allow unlimited usage for premium users', async () => {
      jest.spyOn(planService, 'getCurrentPlan').mockResolvedValue('premium');
      jest.spyOn(prisma.dailyUsage, 'upsert').mockResolvedValue({} as any);

      const result = await service.checkAndIncrementUsage(
        'user123',
        'conversation',
      );
      expect(result).toBe(true);
      expect(prisma.dailyUsage.upsert).toHaveBeenCalled();
    });

    it('should enforce limits for free users', async () => {
      jest.spyOn(planService, 'getCurrentPlan').mockResolvedValue('free');
      jest.spyOn(prisma.dailyUsage, 'findUnique').mockResolvedValue({
        id: 'usage123',
        userId: 'user123',
        date: new Date(),
        type: 'conversation',
        count: 3, // At limit
        createdAt: new Date(),
        updatedAt: new Date(),
      } as any);

      await expect(
        service.checkAndIncrementUsage('user123', 'conversation'),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should allow usage when under limit', async () => {
      jest.spyOn(planService, 'getCurrentPlan').mockResolvedValue('free');
      jest.spyOn(prisma.dailyUsage, 'findUnique').mockResolvedValue({
        id: 'usage123',
        userId: 'user123',
        date: new Date(),
        type: 'conversation',
        count: 1, // Under limit
        createdAt: new Date(),
        updatedAt: new Date(),
      } as any);
      jest.spyOn(prisma.dailyUsage, 'upsert').mockResolvedValue({} as any);

      const result = await service.checkAndIncrementUsage(
        'user123',
        'conversation',
      );
      expect(result).toBe(true);
      expect(prisma.dailyUsage.upsert).toHaveBeenCalled();
    });
  });

  describe('getUsageStatus', () => {
    it('should return current usage status', async () => {
      jest.spyOn(planService, 'getCurrentPlan').mockResolvedValue('free');
      jest.spyOn(prisma.dailyUsage, 'findUnique').mockResolvedValue({
        id: 'usage123',
        userId: 'user123',
        date: new Date(),
        type: 'conversation',
        count: 2,
        createdAt: new Date(),
        updatedAt: new Date(),
      } as any);

      const status = await service.getUsageStatus('user123');
      expect(status.conversations.dailyConversationsUsed).toBe(2);
      expect(status.conversations.dailyConversationsLimit).toBe(3);
    });
  });
});
