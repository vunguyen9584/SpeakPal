import { Test, TestingModule } from '@nestjs/testing';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { OAuthDto } from './dto/oauth.dto';

describe('AuthController', () => {
  let controller: AuthController;
  let authService: AuthService;

  const mockTokens = {
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
    expiresIn: 900,
    user: {
      id: 'user-id',
      email: 'test@example.com',
      username: 'testuser',
      level: 'BEGINNER',
      totalXp: 0,
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AuthController],
      providers: [
        {
          provide: AuthService,
          useValue: {
            register: jest.fn().mockResolvedValue(mockTokens),
            login: jest.fn().mockResolvedValue(mockTokens),
            oauthLogin: jest.fn().mockResolvedValue(mockTokens),
            logout: jest.fn().mockResolvedValue(undefined),
            refreshTokens: jest.fn().mockResolvedValue(mockTokens),
            forgotPassword: jest.fn().mockResolvedValue(undefined),
            resetPassword: jest.fn().mockResolvedValue(undefined),
          },
        },
      ],
    }).compile();

    controller = module.get<AuthController>(AuthController);
    authService = module.get<AuthService>(AuthService);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  describe('register', () => {
    it('should register a user', async () => {
      const dto: RegisterDto = {
        email: 'test@example.com',
        username: 'testuser',
        password: 'password123',
      };

      const result = await controller.register(dto);
      expect(result).toEqual(mockTokens);
      expect(authService.register).toHaveBeenCalledWith(dto);
    });
  });

  describe('login', () => {
    it('should login a user', async () => {
      const dto: LoginDto = {
        email: 'test@example.com',
        password: 'password123',
      };

      const result = await controller.login(dto);
      expect(result).toEqual(mockTokens);
      expect(authService.login).toHaveBeenCalledWith(dto);
    });
  });

  describe('oauth', () => {
    it('should login via oauth', async () => {
      const idToken = 'token';
      const provider = 'google';
      const result = await controller.oauth(provider, idToken);
      expect(result).toEqual(mockTokens);
      expect(authService.oauthLogin).toHaveBeenCalledWith({ idToken, provider });
    });
  });
});
