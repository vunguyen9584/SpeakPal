import { Test, TestingModule } from '@nestjs/testing';
import { BadRequestException } from '@nestjs/common';
import { PurchaseService } from '../purchase.service';
import { PrismaService } from '../../../prisma/prisma.service';
import { SubscriptionPlan } from '@prisma/client';

describe('PurchaseService', () => {
  let service: PurchaseService;
  let prisma: PrismaService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PurchaseService,
        {
          provide: PrismaService,
          useValue: {
            subscription: {
              upsert: jest.fn(),
              findUnique: jest.fn(),
              update: jest.fn(),
              updateMany: jest.fn(),
            },
          },
        },
      ],
    }).compile();

    service = module.get<PurchaseService>(PurchaseService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('verifyPurchase', () => {
    it('should verify iOS purchase', async () => {
      const result = await service.verifyPurchase({
        platform: 'ios',
        receipt: 'valid_receipt',
      });

      expect(result.success).toBe(true);
      expect(result.platform).toBe('ios');
      expect(result.expiryTime).toBeInstanceOf(Date);
    });

    it('should verify Android purchase', async () => {
      const result = await service.verifyPurchase({
        platform: 'android',
        productId: 'premium_monthly',
        purchaseToken: 'valid_token',
      });

      expect(result.success).toBe(true);
      expect(result.platform).toBe('android');
      expect(result.expiryTime).toBeInstanceOf(Date);
    });

    it('should fail iOS purchase without receipt', async () => {
      const result = await service.verifyPurchase({
        platform: 'ios',
      });

      expect(result.success).toBe(false);
      expect(result.error).toContain('Receipt is required');
    });

    it('should fail Android purchase without required fields', async () => {
      const result = await service.verifyPurchase({
        platform: 'android',
      });

      expect(result.success).toBe(false);
      expect(result.error).toContain(
        'Product ID and purchase token are required',
      );
    });
  });

  describe('activateSubscription', () => {
    it('should activate subscription on successful verification', async () => {
      const futureDate = new Date();
      futureDate.setMonth(futureDate.getMonth() + 1);

      const verificationResult = {
        success: true,
        expiryTime: futureDate,
        autoRenewing: true,
        orderId: 'order123',
        platform: 'ios' as const,
      };

      jest.spyOn(prisma.subscription, 'upsert').mockResolvedValue({
        id: 'sub123',
        userId: 'user123',
        plan: SubscriptionPlan.PREMIUM,
        status: 'active',
        expiresAt: futureDate,
        autoRenewing: true,
        orderId: 'order123',
        platform: 'ios',
        createdAt: new Date(),
        updatedAt: new Date(),
      } as any);

      await service.activateSubscription('user123', verificationResult);

      expect(prisma.subscription.upsert).toHaveBeenCalledWith(
        expect.objectContaining({
          where: { userId: 'user123' },
          create: expect.objectContaining({
            plan: SubscriptionPlan.PREMIUM,
            status: 'active',
          }),
        }),
      );
    });

    it('should throw error on failed verification', async () => {
      const verificationResult = {
        success: false,
        error: 'Invalid receipt',
        expiryTime: null,
        autoRenewing: false,
        orderId: '',
        platform: 'ios' as const,
      };

      await expect(
        service.activateSubscription('user123', verificationResult),
      ).rejects.toThrow(BadRequestException);
    });
  });

  describe('restorePurchases', () => {
    it('should restore active subscription', async () => {
      const futureDate = new Date();
      futureDate.setMonth(futureDate.getMonth() + 1);

      jest.spyOn(prisma.subscription, 'findUnique').mockResolvedValue({
        id: 'sub123',
        userId: 'user123',
        plan: SubscriptionPlan.PREMIUM,
        status: 'active',
        expiresAt: futureDate,
        autoRenewing: true,
        orderId: 'order123',
        platform: 'ios',
        createdAt: new Date(),
        updatedAt: new Date(),
      } as any);

      const restored = await service.restorePurchases('user123', 'ios');
      expect(restored).toBe(true);
    });

    it('should not restore expired subscription', async () => {
      const pastDate = new Date();
      pastDate.setMonth(pastDate.getMonth() - 1);

      jest.spyOn(prisma.subscription, 'findUnique').mockResolvedValue({
        id: 'sub123',
        userId: 'user123',
        plan: SubscriptionPlan.PREMIUM,
        status: 'expired',
        expiresAt: pastDate,
        autoRenewing: false,
        orderId: 'order123',
        platform: 'ios',
        createdAt: new Date(),
        updatedAt: new Date(),
      } as any);

      const restored = await service.restorePurchases('user123', 'ios');
      expect(restored).toBe(false);
    });
  });

  describe('cancelSubscription', () => {
    it('should cancel auto-renewal', async () => {
      jest.spyOn(prisma.subscription, 'update').mockResolvedValue({} as any);

      await service.cancelSubscription('user123');

      expect(prisma.subscription.update).toHaveBeenCalledWith({
        where: { userId: 'user123' },
        data: {
          status: 'cancelled',
          autoRenewing: false,
        },
      });
    });
  });
});
