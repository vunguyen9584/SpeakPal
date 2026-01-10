import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { PrismaService } from '../../prisma/prisma.service';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { FirebaseService } from '../../integrations/firebase/firebase.service';
import { CacheService } from '../../cache/cache.service';
import { ConflictException, UnauthorizedException, BadRequestException } from '@nestjs/common';
import * as bcrypt from 'bcrypt';

jest.mock('bcrypt');

describe('AuthService', () => {
  let service: AuthService;
  let prismaService: PrismaService;
  let jwtService: JwtService;
  let firebaseService: FirebaseService;

  const mockUser = {
    id: 'user-id',
    email: 'test@example.com',
    username: 'testuser',
    passwordHash: 'hashedPassword',
    level: 'BEGINNER',
    totalXp: 0,
    currentLevelXp: 0,
    league: 'BRONZE',
    isVerified: true,
  };

  const mockTokens = {
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
    expiresIn: 900,
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        {
          provide: PrismaService,
          useValue: {
            user: {
              findUnique: jest.fn(),
              findFirst: jest.fn(),
              create: jest.fn(),
              update: jest.fn(),
            },
          },
        },
        {
          provide: JwtService,
          useValue: {
            sign: jest.fn().mockReturnValue('mock-token'),
            verify: jest.fn(),
          },
        },
        {
          provide: ConfigService,
          useValue: {
            get: jest.fn((key) => {
              if (key === 'JWT_SECRET') return 'secret';
              if (key === 'JWT_REFRESH_SECRET') return 'refresh_secret';
              if (key === 'JWT_EXPIRES_IN') return '15m';
              if (key === 'JWT_REFRESH_EXPIRES_IN') return '7d';
              return null;
            }),
          },
        },
        {
          provide: CacheService,
          useValue: {
            set: jest.fn(),
            get: jest.fn(),
            del: jest.fn(),
          },
        },
        {
          provide: FirebaseService,
          useValue: {
            verifyIdToken: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
    prismaService = module.get<PrismaService>(PrismaService);
    jwtService = module.get<JwtService>(JwtService);
    firebaseService = module.get<FirebaseService>(FirebaseService);

    // Mock bcrypt
    (bcrypt.hash as jest.Mock).mockResolvedValue('hashedPassword');
    (bcrypt.compare as jest.Mock).mockResolvedValue(true);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('register', () => {
    const registerDto = {
      email: 'test@example.com',
      password: 'password123',
      username: 'testuser',
    };

    it('should successfully register a new user', async () => {
      jest.spyOn(prismaService.user, 'findUnique').mockResolvedValue(null);
      jest.spyOn(prismaService.user, 'findFirst').mockResolvedValue(null);
      jest.spyOn(prismaService.user, 'create').mockResolvedValue(mockUser as any);
      jest.spyOn(jwtService, 'sign').mockReturnValue('mock-token');

      const result = await service.register(registerDto);

      expect(result).toHaveProperty('accessToken');
      expect(prismaService.user.create).toHaveBeenCalled();
    });

    it('should throw ConflictException if email exists', async () => {
      jest.spyOn(prismaService.user, 'findUnique').mockResolvedValue(mockUser as any);

      await expect(service.register(registerDto)).rejects.toThrow(ConflictException);
    });
  });

  describe('login', () => {
    const loginDto = {
      email: 'test@example.com',
      password: 'password123',
    };

    it('should return tokens for valid credentials', async () => {
      jest.spyOn(prismaService.user, 'findUnique').mockResolvedValue(mockUser as any);
      (bcrypt.compare as jest.Mock).mockResolvedValue(true);
      jest.spyOn(prismaService.user, 'update').mockResolvedValue(mockUser as any);

      const result = await service.login(loginDto);

      expect(result).toHaveProperty('accessToken');
    });

    it('should throw UnauthorizedException for invalid user', async () => {
      jest.spyOn(prismaService.user, 'findUnique').mockResolvedValue(null);

      await expect(service.login(loginDto)).rejects.toThrow(UnauthorizedException);
    });

    it('should throw UnauthorizedException for invalid password', async () => {
      jest.spyOn(prismaService.user, 'findUnique').mockResolvedValue(mockUser as any);
      (bcrypt.compare as jest.Mock).mockResolvedValue(false);

      await expect(service.login(loginDto)).rejects.toThrow(UnauthorizedException);
    });
  });

  describe('oauthLogin', () => {
    const oauthDto = {
      idToken: 'firebase-id-token',
      provider: 'google',
    };

    const firebaseUser = {
      uid: 'firebase-uid',
      email: 'test@example.com',
      name: 'Test User',
      picture: 'pic-url',
    };

    it('should login existing user via OAuth', async () => {
      jest.spyOn(firebaseService, 'verifyIdToken').mockResolvedValue(firebaseUser as any);
      jest.spyOn(prismaService.user, 'findUnique').mockResolvedValue(mockUser as any);
      jest.spyOn(prismaService.user, 'update').mockResolvedValue(mockUser as any);

      const result = await service.oauthLogin(oauthDto);

      expect(result).toHaveProperty('accessToken');
      expect(prismaService.user.create).not.toHaveBeenCalled();
    });

    it('should create and login new user via OAuth', async () => {
      jest.spyOn(firebaseService, 'verifyIdToken').mockResolvedValue(firebaseUser as any);
      jest.spyOn(prismaService.user, 'findUnique').mockResolvedValue(null); // User not found
      jest.spyOn(prismaService.user, 'findFirst').mockResolvedValue(null); // Username not found
      jest.spyOn(prismaService.user, 'create').mockResolvedValue(mockUser as any);
      jest.spyOn(prismaService.user, 'update').mockResolvedValue(mockUser as any);

      const result = await service.oauthLogin(oauthDto);

      expect(result).toHaveProperty('accessToken');
      expect(prismaService.user.create).toHaveBeenCalled();
    });

    it('should throw BadRequestException if email is missing in token', async () => {
      jest.spyOn(firebaseService, 'verifyIdToken').mockResolvedValue({ ...firebaseUser, email: undefined } as any);

      await expect(service.oauthLogin(oauthDto)).rejects.toThrow(BadRequestException);
    });
  });
});
