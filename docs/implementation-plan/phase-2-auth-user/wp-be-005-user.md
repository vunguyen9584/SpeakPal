# WP-BE-005: User Module

## Overview

- **ID**: WP-BE-005
- **Description**: User CRUD, profile, settings
- **Dependencies**: WP-BE-004
- **Estimated Days**: 3
- **Total Tasks**: 6
- **DD References**:
  - `05-module-design/user-module.md`
  - `08-api-design/user-apis.md`
  - `07-database-design/user-tables.md`

---

## Tasks

### Task 1: Create User Module Structure

- **ID**: WP-BE-005-T001
- **Type**: setup
- **Description**: Khởi tạo module structure cho User
- **Commands**:
  ```bash
  nest g module modules/user
  nest g controller modules/user
  nest g service modules/user
  ```
- **Files to Create**:
  - `backend/src/modules/user/user.module.ts`
  - `backend/src/modules/user/user.controller.ts`
  - `backend/src/modules/user/user.service.ts`
  - `backend/src/modules/user/user.repository.ts`
- **Estimated Hours**: 1

---

### Task 2: Create User DTOs

- **ID**: WP-BE-005-T002
- **Type**: feature
- **Description**: Tạo Request/Response DTOs cho user endpoints
- **Files to Create**:
  - `backend/src/modules/user/dto/user.dto.ts`
    ```typescript
    export class UserDto {
      id: string;
      email: string;
      username?: string;
      level: Level;
      totalXp: number;
      currentLevelXp: number;
      league: League;
      aiSpeed: number;
      confirmationMode: boolean;
      isVerified: boolean;
      createdAt: Date;
    }
    ```
  - `backend/src/modules/user/dto/update-profile.dto.ts`
  - `backend/src/modules/user/dto/update-settings.dto.ts`
  - `backend/src/modules/user/dto/change-password.dto.ts`
  - `backend/src/modules/user/dto/user-stats.dto.ts`
- **DD Reference**: `08-api-design/user-apis.md`
- **Estimated Hours**: 2

---

### Task 3: Implement User Repository

- **ID**: WP-BE-005-T003
- **Type**: feature
- **Description**: Data access layer với Prisma
- **Files to Create**:
  - `backend/src/modules/user/user.repository.ts`
    ```typescript
    @Injectable()
    export class UserRepository {
      constructor(private prisma: PrismaService) {}

      async findById(id: string): Promise<User | null> {
        return this.prisma.user.findUnique({ where: { id } });
      }

      async findByEmail(email: string): Promise<User | null> {
        return this.prisma.user.findUnique({ where: { email } });
      }

      async update(id: string, data: Prisma.UserUpdateInput): Promise<User> {
        return this.prisma.user.update({ where: { id }, data });
      }

      async getStats(id: string): Promise<UserStats> {
        // Get conversation count, vocabulary count, streak, etc.
      }
    }
    ```
- **Estimated Hours**: 2

---

### Task 4: Implement User Service

- **ID**: WP-BE-005-T004
- **Type**: feature
- **Description**: Implement user business logic
- **Files to Modify**:
  - `backend/src/modules/user/user.service.ts`
    ```typescript
    @Injectable()
    export class UserService {
      constructor(
        private userRepository: UserRepository,
        private cacheService: CacheService
      ) {}

      async getProfile(userId: string): Promise<UserDto> {
        const cached = await this.cacheService.get(`user:${userId}`);
        if (cached) return cached;

        const user = await this.userRepository.findById(userId);
        if (!user) throw new NotFoundException("User not found");

        await this.cacheService.set(`user:${userId}`, user, 300);
        return user;
      }

      async updateProfile(
        userId: string,
        dto: UpdateProfileDto
      ): Promise<UserDto> {
        const user = await this.userRepository.update(userId, dto);
        await this.cacheService.del(`user:${userId}`);
        return user;
      }

      async updateSettings(
        userId: string,
        dto: UpdateSettingsDto
      ): Promise<UserDto> {
        // Update aiSpeed, confirmationMode, etc.
      }

      async changePassword(
        userId: string,
        dto: ChangePasswordDto
      ): Promise<void> {
        // Verify current password
        // Hash new password
        // Update password
      }

      async getStats(userId: string): Promise<UserStatsDto> {
        // Get conversation stats
        // Get vocabulary stats
        // Get streak info
        // Get badge count
      }
    }
    ```
- **Estimated Hours**: 4

---

### Task 5: Implement User Controller

- **ID**: WP-BE-005-T005
- **Type**: feature
- **Description**: Tạo REST API endpoints cho user
- **Files to Modify**:
  - `backend/src/modules/user/user.controller.ts`
    ```typescript
    @Controller("users")
    @UseGuards(JwtAuthGuard)
    export class UserController {
      constructor(private userService: UserService) {}

      @Get("me")
      async getProfile(@CurrentUser() user: JwtPayload): Promise<UserDto> {
        return this.userService.getProfile(user.userId);
      }

      @Put("me")
      async updateProfile(
        @CurrentUser() user: JwtPayload,
        @Body() dto: UpdateProfileDto
      ): Promise<UserDto> {
        return this.userService.updateProfile(user.userId, dto);
      }

      @Put("me/password")
      async changePassword(
        @CurrentUser() user: JwtPayload,
        @Body() dto: ChangePasswordDto
      ): Promise<void> {
        return this.userService.changePassword(user.userId, dto);
      }

      @Get("me/stats")
      async getStats(@CurrentUser() user: JwtPayload): Promise<UserStatsDto> {
        return this.userService.getStats(user.userId);
      }

      @Put("me/settings")
      async updateSettings(
        @CurrentUser() user: JwtPayload,
        @Body() dto: UpdateSettingsDto
      ): Promise<UserDto> {
        return this.userService.updateSettings(user.userId, dto);
      }
    }
    ```
- **Endpoints**:
  - `GET /users/me` - Get current user profile
  - `PUT /users/me` - Update profile
  - `PUT /users/me/password` - Change password
  - `GET /users/me/stats` - Get user statistics
  - `PUT /users/me/settings` - Update settings
- **DD Reference**: `08-api-design/user-apis.md`
- **Estimated Hours**: 2

---

### Task 6: Add Unit Tests

- **ID**: WP-BE-005-T006
- **Type**: test
- **Description**: Unit tests cho UserService
- **Files to Create**:
  - `backend/src/modules/user/user.service.spec.ts`
  - `backend/src/modules/user/user.controller.spec.ts`
- **Test Cases**:
  - getProfile: should return user data
  - getProfile: should throw NotFoundException for invalid user
  - updateProfile: should update and invalidate cache
  - changePassword: should verify current password
  - getStats: should aggregate user statistics
- **Estimated Hours**: 3

---

## Task Summary

| Task ID        | Name                    | Type    | Est. Hours | Status |
| -------------- | ----------------------- | ------- | ---------- | ------ |
| WP-BE-005-T001 | Create Module Structure | setup   | 1          | ⬜     |
| WP-BE-005-T002 | Create User DTOs        | feature | 2          | ⬜     |
| WP-BE-005-T003 | Implement Repository    | feature | 2          | ⬜     |
| WP-BE-005-T004 | Implement Service       | feature | 4          | ⬜     |
| WP-BE-005-T005 | Implement Controller    | feature | 2          | ⬜     |
| WP-BE-005-T006 | Add Unit Tests          | test    | 3          | ⬜     |
| **Total**      |                         |         | **14**     |        |

---

_DD References: 05-module-design/user-module.md, 08-api-design/user-apis.md, 07-database-design/user-tables.md_
