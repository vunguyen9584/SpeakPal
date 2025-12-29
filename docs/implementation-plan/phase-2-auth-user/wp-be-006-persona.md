# WP-BE-006: Persona Module

## Overview

- **ID**: WP-BE-006
- **Description**: AI persona management
- **Dependencies**: WP-BE-005
- **Estimated Days**: 2
- **Total Tasks**: 5
- **DD References**:
  - `05-module-design.md#persona`
  - `08-api-design.md#user`
  - `07-database-design/user-tables.md`

---

## Tasks

### Task 1: Create Persona Module Structure

- **ID**: WP-BE-006-T001
- **Type**: setup
- **Description**: Khởi tạo module structure cho Persona
- **Commands**:
  ```bash
  nest g module modules/persona
  nest g controller modules/persona
  nest g service modules/persona
  ```
- **Files to Create**:
  - `backend/src/modules/persona/persona.module.ts`
  - `backend/src/modules/persona/persona.controller.ts`
  - `backend/src/modules/persona/persona.service.ts`
  - `backend/src/modules/persona/persona.repository.ts`
- **Estimated Hours**: 1

---

### Task 2: Create Persona DTOs

- **ID**: WP-BE-006-T002
- **Type**: feature
- **Description**: Tạo Request/Response DTOs cho persona
- **Files to Create**:
  - `backend/src/modules/persona/dto/create-persona.dto.ts`
    ```typescript
    export class CreatePersonaDto {
      @IsString()
      @MaxLength(50)
      name: string;

      @IsEnum(Voice)
      voice: Voice;

      @IsEnum(Personality)
      personality: Personality;

      @IsEnum(Level)
      targetLevel: Level;
    }
    ```
  - `backend/src/modules/persona/dto/update-persona.dto.ts`
  - `backend/src/modules/persona/dto/persona-response.dto.ts`
- **Enums**:
  ```typescript
  enum Voice {
    MALE_US,
    FEMALE_US,
    MALE_UK,
    FEMALE_UK,
  }
  enum Personality {
    FRIENDLY,
    PROFESSIONAL,
    CASUAL,
    STRICT,
  }
  ```
- **Estimated Hours**: 1.5

---

### Task 3: Implement Persona Service

- **ID**: WP-BE-006-T003
- **Type**: feature
- **Description**: Implement persona business logic
- **Files to Create/Modify**:
  - `backend/src/modules/persona/persona.repository.ts`
  - `backend/src/modules/persona/persona.service.ts`
    ```typescript
    @Injectable()
    export class PersonaService {
      constructor(private personaRepository: PersonaRepository) {}

      async create(userId: string, dto: CreatePersonaDto): Promise<PersonaDto> {
        // Check persona limit (max 5 per user for free, unlimited for premium)
        // Create persona
        // If first persona, set as default
      }

      async findAll(userId: string): Promise<PersonaDto[]> {
        return this.personaRepository.findByUserId(userId);
      }

      async findById(userId: string, id: string): Promise<PersonaDto> {
        const persona = await this.personaRepository.findById(id);
        if (!persona || persona.userId !== userId) {
          throw new NotFoundException("Persona not found");
        }
        return persona;
      }

      async update(
        userId: string,
        id: string,
        dto: UpdatePersonaDto
      ): Promise<PersonaDto> {
        await this.findById(userId, id); // Verify ownership
        return this.personaRepository.update(id, dto);
      }

      async delete(userId: string, id: string): Promise<void> {
        const persona = await this.findById(userId, id);
        if (persona.isDefault) {
          throw new BadRequestException("Cannot delete default persona");
        }
        await this.personaRepository.delete(id);
      }

      async setDefault(userId: string, id: string): Promise<PersonaDto> {
        await this.findById(userId, id);
        // Unset current default
        await this.personaRepository.unsetAllDefaults(userId);
        // Set new default
        return this.personaRepository.update(id, { isDefault: true });
      }
    }
    ```
- **Estimated Hours**: 3

---

### Task 4: Implement Persona Controller

- **ID**: WP-BE-006-T004
- **Type**: feature
- **Description**: Tạo REST API endpoints cho persona
- **Files to Modify**:
  - `backend/src/modules/persona/persona.controller.ts`
    ```typescript
    @Controller("personas")
    @UseGuards(JwtAuthGuard)
    export class PersonaController {
      constructor(private personaService: PersonaService) {}

      @Get()
      async findAll(@CurrentUser() user: JwtPayload): Promise<PersonaDto[]> {
        return this.personaService.findAll(user.userId);
      }

      @Post()
      async create(
        @CurrentUser() user: JwtPayload,
        @Body() dto: CreatePersonaDto
      ): Promise<PersonaDto> {
        return this.personaService.create(user.userId, dto);
      }

      @Get(":id")
      async findById(
        @CurrentUser() user: JwtPayload,
        @Param("id") id: string
      ): Promise<PersonaDto> {
        return this.personaService.findById(user.userId, id);
      }

      @Put(":id")
      async update(
        @CurrentUser() user: JwtPayload,
        @Param("id") id: string,
        @Body() dto: UpdatePersonaDto
      ): Promise<PersonaDto> {
        return this.personaService.update(user.userId, id, dto);
      }

      @Delete(":id")
      async delete(
        @CurrentUser() user: JwtPayload,
        @Param("id") id: string
      ): Promise<void> {
        return this.personaService.delete(user.userId, id);
      }

      @Put(":id/default")
      async setDefault(
        @CurrentUser() user: JwtPayload,
        @Param("id") id: string
      ): Promise<PersonaDto> {
        return this.personaService.setDefault(user.userId, id);
      }
    }
    ```
- **Endpoints**:
  - `GET /personas` - List all personas
  - `POST /personas` - Create new persona
  - `GET /personas/:id` - Get persona by ID
  - `PUT /personas/:id` - Update persona
  - `DELETE /personas/:id` - Delete persona
  - `PUT /personas/:id/default` - Set as default
- **DD Reference**: `08-api-design.md#personas`
- **Estimated Hours**: 2

---

### Task 5: Add Unit Tests

- **ID**: WP-BE-006-T005
- **Type**: test
- **Description**: Unit tests cho PersonaService
- **Files to Create**:
  - `backend/src/modules/persona/persona.service.spec.ts`
- **Test Cases**:
  - create: should create persona successfully
  - create: should set first persona as default
  - create: should enforce limit for free users
  - delete: should not delete default persona
  - setDefault: should unset previous default
- **Estimated Hours**: 2

---

## Task Summary

| Task ID        | Name                    | Type    | Est. Hours | Status |
| -------------- | ----------------------- | ------- | ---------- | ------ |
| WP-BE-006-T001 | Create Module Structure | setup   | 1          | ⬜     |
| WP-BE-006-T002 | Create Persona DTOs     | feature | 1.5        | ⬜     |
| WP-BE-006-T003 | Implement Service       | feature | 3          | ⬜     |
| WP-BE-006-T004 | Implement Controller    | feature | 2          | ⬜     |
| WP-BE-006-T005 | Add Unit Tests          | test    | 2          | ⬜     |
| **Total**      |                         |         | **9.5**    |        |

---

_DD References: 05-module-design.md#persona, 08-api-design.md#personas_
