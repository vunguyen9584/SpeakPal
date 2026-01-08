import { Test, TestingModule } from '@nestjs/testing';
import { PlanService } from '../plan.service';
import { PrismaService } from '../../../prisma/prisma.service';

describe('PlanService', () => {
    let service: PlanService;
    let prisma: PrismaService;

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                PlanService,
                {
                    provide: PrismaService,
                    useValue: {
                        subscription: {
                            findUnique: jest.fn(),
                        },
                    },
                },
            ],
        }).compile();

        service = module.get<PlanService>(PlanService);
        prisma = module.get<PrismaService>(PrismaService);
    });

    it('should be defined', () => {
        expect(service).toBeDefined();
    });

    describe('getCurrentPlan', () => {
        it('should return free plan when no subscription exists', async () => {
            jest.spyOn(prisma.subscription, 'findUnique').mockResolvedValue(null);

            const plan = await service.getCurrentPlan('user123');
            expect(plan).toBe('free');
        });

        it('should return premium plan when active subscription exists', async () => {
            const futureDate = new Date();
            futureDate.setMonth(futureDate.getMonth() + 1);

            jest.spyOn(prisma.subscription, 'findUnique').mockResolvedValue({
                id: 'sub123',
                userId: 'user123',
                plan: 'premium',
                status: 'active',
                expiresAt: futureDate,
                autoRenewing: true,
                orderId: 'order123',
                platform: 'ios',
                createdAt: new Date(),
                updatedAt: new Date(),
            } as any);

            const plan = await service.getCurrentPlan('user123');
            expect(plan).toBe('premium');
        });

        it('should return free plan when subscription is expired', async () => {
            const pastDate = new Date();
            pastDate.setMonth(pastDate.getMonth() - 1);

            jest.spyOn(prisma.subscription, 'findUnique').mockResolvedValue({
                id: 'sub123',
                userId: 'user123',
                plan: 'premium',
                status: 'active',
                expiresAt: pastDate,
                autoRenewing: false,
                orderId: 'order123',
                platform: 'ios',
                createdAt: new Date(),
                updatedAt: new Date(),
            } as any);

            const plan = await service.getCurrentPlan('user123');
            expect(plan).toBe('free');
        });
    });

    describe('checkFeatureAccess', () => {
        it('should allow unlimited conversations for premium users', async () => {
            jest.spyOn(service, 'getCurrentPlan').mockResolvedValue('premium');

            const hasAccess = await service.checkFeatureAccess(
                'user123',
                'unlimitedVocabulary',
            );
            expect(hasAccess).toBe(true);
        });

        it('should deny unlimited conversations for free users', async () => {
            jest.spyOn(service, 'getCurrentPlan').mockResolvedValue('free');

            const hasAccess = await service.checkFeatureAccess(
                'user123',
                'unlimitedVocabulary',
            );
            expect(hasAccess).toBe(false);
        });
    });
});
