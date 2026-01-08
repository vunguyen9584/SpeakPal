import { Test, TestingModule } from '@nestjs/testing';
import { NotificationService } from '../notification.service';
import { FCMService } from '../../../integrations/firebase/fcm.service';
import { PrismaService } from '../../../prisma/prisma.service';
import { NotificationType } from '../notification.types';

describe('NotificationService', () => {
  let service: NotificationService;
  let fcmService: FCMService;
  let prisma: PrismaService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        NotificationService,
        {
          provide: FCMService,
          useValue: {
            sendPush: jest.fn(),
            sendBatchPush: jest.fn(),
          },
        },
        {
          provide: PrismaService,
          useValue: {},
        },
      ],
    }).compile();

    service = module.get<NotificationService>(NotificationService);
    fcmService = module.get<FCMService>(FCMService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('send', () => {
    it('should send notification successfully', async () => {
      jest.spyOn(fcmService, 'sendPush').mockResolvedValue(true);

      const result = await service.send(
        'user123',
        NotificationType.STREAK_REMINDER,
      );

      expect(result).toBe(true);
      expect(fcmService.sendPush).toHaveBeenCalled();
    });

    it('should render template with variables', async () => {
      jest.spyOn(fcmService, 'sendPush').mockResolvedValue(true);

      await service.send('user123', NotificationType.BADGE_EARNED, {
        badgeName: 'First Conversation',
      });

      expect(fcmService.sendPush).toHaveBeenCalledWith(
        expect.any(String),
        expect.objectContaining({
          body: expect.stringContaining('First Conversation'),
        }),
      );
    });

    it('should handle FCM failure', async () => {
      jest.spyOn(fcmService, 'sendPush').mockResolvedValue(false);

      const result = await service.send(
        'user123',
        NotificationType.STREAK_REMINDER,
      );

      expect(result).toBe(false);
    });
  });

  describe('sendBatch', () => {
    it('should send notifications to multiple users', async () => {
      jest.spyOn(fcmService, 'sendPush').mockResolvedValue(true);

      const result = await service.sendBatch(
        ['user1', 'user2', 'user3'],
        NotificationType.WEEKLY_REPORT,
      );

      expect(result.successCount).toBe(3);
      expect(result.failureCount).toBe(0);
    });

    it('should handle partial failures', async () => {
      jest
        .spyOn(fcmService, 'sendPush')
        .mockResolvedValueOnce(true)
        .mockResolvedValueOnce(false)
        .mockResolvedValueOnce(true);

      const result = await service.sendBatch(
        ['user1', 'user2', 'user3'],
        NotificationType.WEEKLY_REPORT,
      );

      expect(result.successCount).toBe(2);
      expect(result.failureCount).toBe(1);
    });
  });
});
