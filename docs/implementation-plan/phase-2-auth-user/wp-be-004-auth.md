# WP-BE-004: Auth Module

## Overview

- **ID**: WP-BE-004
- **Description**: JWT, OAuth, guards, login/register
- **Dependencies**: WP-BE-003, WP-INF-004
- **Estimated Days**: 4
- **Total Tasks**: 8
- **DD References**:
  - `05-module-design/auth-module.md`
  - `08-api-design/auth-apis.md`
  - `10-security-design.md`

---

## Tasks

### Task 1: Create Auth Module Structure

- **ID**: WP-BE-004-T001
- **Type**: setup
- **Description**: Khởi tạo module structure cho Auth
- **Commands**:
  ```bash
  cd backend
  nest g module modules/auth
  nest g controller modules/auth
  nest g service modules/auth
  ```
- **Files to Create**:
  - `backend/src/modules/auth/auth.module.ts`
  - `backend/src/modules/auth/auth.controller.ts`
  - `backend/src/modules/auth/auth.service.ts`
- **Estimated Hours**: 1

---

### Task 2: Create Auth DTOs

- **ID**: WP-BE-004-T002
- **Type**: feature
- **Description**: Tạo Request/Response DTOs cho auth endpoints
- **Files to Create**:
  - `backend/src/modules/auth/dto/register.dto.ts`
    ```typescript
    export class RegisterDto {
      @IsEmail()
      email: string;

      @IsString()
      @MinLength(8)
      password: string;

      @IsString()
      @IsOptional()
      username?: string;
    }
    ```
  - `backend/src/modules/auth/dto/login.dto.ts`
  - `backend/src/modules/auth/dto/token.dto.ts`
  - `backend/src/modules/auth/dto/forgot-password.dto.ts`
  - `backend/src/modules/auth/dto/reset-password.dto.ts`
  - `backend/src/modules/auth/dto/oauth.dto.ts`
- **DD Reference**: `08-api-design/auth-apis.md`
- **Estimated Hours**: 2

---

### Task 3: Implement JWT Strategy

- **ID**: WP-BE-004-T003
- **Type**: feature
- **Description**: Implement Passport JWT strategy cho access & refresh tokens
- **Commands**:
  ```bash
  npm install @nestjs/passport passport passport-jwt @nestjs/jwt
  npm install -D @types/passport-jwt
  ```
- **Files to Create**:
  - `backend/src/modules/auth/strategies/jwt.strategy.ts`
    ```typescript
    @Injectable()
    export class JwtStrategy extends PassportStrategy(Strategy) {
      constructor(private configService: ConfigService) {
        super({
          jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
          ignoreExpiration: false,
          secretOrKey: configService.get("JWT_SECRET"),
        });
      }

      async validate(payload: JwtPayload) {
        return { userId: payload.sub, email: payload.email };
      }
    }
    ```
  - `backend/src/modules/auth/strategies/jwt-refresh.strategy.ts`
  - `backend/src/modules/auth/interfaces/jwt-payload.interface.ts`
- **DD Reference**: `10-security-design.md`
- **Estimated Hours**: 3

---

### Task 4: Implement Auth Guards

- **ID**: WP-BE-004-T004
- **Type**: feature
- **Description**: Tạo JWT auth guard và roles guard
- **Files to Create**:
  - `backend/src/modules/auth/guards/jwt-auth.guard.ts`
    ```typescript
    @Injectable()
    export class JwtAuthGuard extends AuthGuard("jwt") {
      canActivate(context: ExecutionContext) {
        const isPublic = this.reflector.getAllAndOverride<boolean>(
          IS_PUBLIC_KEY,
          [context.getHandler(), context.getClass()]
        );
        if (isPublic) return true;
        return super.canActivate(context);
      }
    }
    ```
  - `backend/src/modules/auth/guards/roles.guard.ts`
  - `backend/src/modules/auth/guards/subscription.guard.ts` - Check premium access
- **Estimated Hours**: 2

---

### Task 5: Implement Register & Login

- **ID**: WP-BE-004-T005
- **Type**: feature
- **Description**: Implement registration và login endpoints
- **Files to Modify**:
  - `backend/src/modules/auth/auth.service.ts`

    ```typescript
    async register(dto: RegisterDto): Promise<TokensDto> {
      // Check email exists
      // Hash password
      // Create user
      // Generate tokens
      // Return tokens
    }

    async login(dto: LoginDto): Promise<TokensDto> {
      // Find user by email
      // Verify password
      // Generate tokens
      // Update lastLoginAt
      // Return tokens
    }

    async logout(userId: string, refreshToken: string): Promise<void> {
      // Invalidate refresh token
    }
    ```

  - `backend/src/modules/auth/auth.controller.ts`
- **Endpoints**:
  - `POST /auth/register` - User registration
  - `POST /auth/login` - User login
  - `POST /auth/logout` - User logout
- **DD Reference**: `08-api-design/auth-apis.md`
- **Estimated Hours**: 4

---

### Task 6: Implement Token Refresh

- **ID**: WP-BE-004-T006
- **Type**: feature
- **Description**: Implement refresh token logic với rotation
- **Files to Modify**:
  - `backend/src/modules/auth/auth.service.ts`
    ```typescript
    async refreshTokens(refreshToken: string): Promise<TokensDto> {
      // Verify refresh token
      // Check if token is in blacklist
      // Generate new access token
      // Generate new refresh token (rotation)
      // Blacklist old refresh token
      // Return new tokens
    }
    ```
- **Endpoints**:
  - `POST /auth/refresh` - Refresh access token
- **Estimated Hours**: 3

---

### Task 7: Implement Password Reset

- **ID**: WP-BE-004-T007
- **Type**: feature
- **Description**: Implement forgot/reset password với email verification
- **Files to Modify**:
  - `backend/src/modules/auth/auth.service.ts`

    ```typescript
    async forgotPassword(dto: ForgotPasswordDto): Promise<void> {
      // Find user by email
      // Generate reset token
      // Save reset token to Redis with expiry
      // Send reset email (or just return for now)
    }

    async resetPassword(dto: ResetPasswordDto): Promise<void> {
      // Verify reset token
      // Hash new password
      // Update user password
      // Invalidate reset token
      // Invalidate all refresh tokens
    }
    ```
- **Endpoints**:
  - `POST /auth/forgot-password`
  - `POST /auth/reset-password`
- **Estimated Hours**: 4

---

### Task 8: Implement Firebase OAuth

- **ID**: WP-BE-004-T008
- **Type**: integration
- **Description**: Integrate Firebase Auth for Google/Apple OAuth
- **Commands**:
  ```bash
  npm install firebase-admin
  ```
- **Files to Create**:
  - `backend/src/integrations/firebase/firebase.module.ts`
  - `backend/src/integrations/firebase/firebase.service.ts`
    ```typescript
    @Injectable()
    export class FirebaseService {
      private app: admin.app.App;

      constructor(private configService: ConfigService) {
        this.app = admin.initializeApp({
          credential: admin.credential.cert({
            projectId: configService.get("FIREBASE_PROJECT_ID"),
            privateKey: configService.get("FIREBASE_PRIVATE_KEY"),
            clientEmail: configService.get("FIREBASE_CLIENT_EMAIL"),
          }),
        });
      }

      async verifyIdToken(idToken: string): Promise<admin.auth.DecodedIdToken> {
        return this.app.auth().verifyIdToken(idToken);
      }
    }
    ```
- **Files to Modify**:
  - `backend/src/modules/auth/auth.service.ts` - Add OAuth login method
  - `backend/src/modules/auth/auth.controller.ts` - Add OAuth endpoint
- **Endpoints**:
  - `POST /auth/oauth/:provider` - OAuth login (google, apple)
- **Estimated Hours**: 5

---

## Task Summary

| Task ID        | Name                     | Type        | Est. Hours | Status |
| -------------- | ------------------------ | ----------- | ---------- | ------ |
| WP-BE-004-T001 | Create Module Structure  | setup       | 1          | ⬜     |
| WP-BE-004-T002 | Create Auth DTOs         | feature     | 2          | ⬜     |
| WP-BE-004-T003 | Implement JWT Strategy   | feature     | 3          | ⬜     |
| WP-BE-004-T004 | Implement Auth Guards    | feature     | 2          | ⬜     |
| WP-BE-004-T005 | Implement Register/Login | feature     | 4          | ⬜     |
| WP-BE-004-T006 | Implement Token Refresh  | feature     | 3          | ⬜     |
| WP-BE-004-T007 | Implement Password Reset | feature     | 4          | ⬜     |
| WP-BE-004-T008 | Implement Firebase OAuth | integration | 5          | ⬜     |
| **Total**      |                          |             | **24**     |        |

---

_DD References: 05-module-design/auth-module.md, 08-api-design/auth-apis.md, 10-security-design.md_
