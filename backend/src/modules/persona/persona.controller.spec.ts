import { Test, TestingModule } from '@nestjs/testing';
import { PersonaController } from './persona.controller';
import { PersonaService } from './persona.service';
import { Voice, Personality, Level } from '@prisma/client';
import { CreatePersonaDto } from './dto/create-persona.dto';
import { UpdatePersonaDto } from './dto/update-persona.dto';

describe('PersonaController', () => {
  let controller: PersonaController;
  let service: jest.Mocked<PersonaService>;

  const mockUser = { userId: 'user-123' };

  const mockPersonaDto = {
    id: 'persona-123',
    userId: 'user-123',
    name: 'Test Persona',
    voice: Voice.VOICE_1,
    personality: Personality.CHEERFUL,
    targetLevel: Level.INTERMEDIATE,
    isDefault: false,
    createdAt: new Date(),
  };

  beforeEach(async () => {
    const mockPersonaService = {
      create: jest.fn(),
      findAll: jest.fn(),
      findById: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
      setDefault: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [PersonaController],
      providers: [
        {
          provide: PersonaService,
          useValue: mockPersonaService,
        },
      ],
    }).compile();

    controller = module.get<PersonaController>(PersonaController);
    service = module.get(PersonaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('findAll', () => {
    it('should call service.findAll with userId and return results', async () => {
      const personas = [mockPersonaDto, { ...mockPersonaDto, id: 'persona-456' }];
      service.findAll.mockResolvedValue(personas);

      const result = await controller.findAll(mockUser);

      expect(service.findAll).toHaveBeenCalledWith(mockUser.userId);
      expect(result).toEqual(personas);
      expect(result).toHaveLength(2);
    });
  });

  describe('create', () => {
    it('should call service.create with userId and dto, return created persona', async () => {
      const createDto: CreatePersonaDto = {
        name: 'New Persona',
        voice: Voice.VOICE_2,
        personality: Personality.STRICT,
        targetLevel: Level.ADVANCED,
      };
      const createdPersona = { ...mockPersonaDto, ...createDto };
      service.create.mockResolvedValue(createdPersona);

      const result = await controller.create(mockUser, createDto);

      expect(service.create).toHaveBeenCalledWith(mockUser.userId, createDto);
      expect(result).toEqual(createdPersona);
    });
  });

  describe('findById', () => {
    it('should call service.findById with userId and id, return persona', async () => {
      service.findById.mockResolvedValue(mockPersonaDto);

      const result = await controller.findById(mockUser, mockPersonaDto.id);

      expect(service.findById).toHaveBeenCalledWith(
        mockUser.userId,
        mockPersonaDto.id,
      );
      expect(result).toEqual(mockPersonaDto);
    });
  });

  describe('update', () => {
    it('should call service.update with userId, id and dto, return updated persona', async () => {
      const updateDto: UpdatePersonaDto = {
        name: 'Updated Name',
        voice: Voice.VOICE_3,
      };
      const updatedPersona = { ...mockPersonaDto, ...updateDto };
      service.update.mockResolvedValue(updatedPersona);

      const result = await controller.update(
        mockUser,
        mockPersonaDto.id,
        updateDto,
      );

      expect(service.update).toHaveBeenCalledWith(
        mockUser.userId,
        mockPersonaDto.id,
        updateDto,
      );
      expect(result).toEqual(updatedPersona);
    });
  });

  describe('delete', () => {
    it('should call service.delete with userId and id', async () => {
      service.delete.mockResolvedValue(undefined);

      await controller.delete(mockUser, mockPersonaDto.id);

      expect(service.delete).toHaveBeenCalledWith(
        mockUser.userId,
        mockPersonaDto.id,
      );
    });
  });

  describe('setDefault', () => {
    it('should call service.setDefault with userId and id, return updated persona', async () => {
      const defaultPersona = { ...mockPersonaDto, isDefault: true };
      service.setDefault.mockResolvedValue(defaultPersona);

      const result = await controller.setDefault(mockUser, mockPersonaDto.id);

      expect(service.setDefault).toHaveBeenCalledWith(
        mockUser.userId,
        mockPersonaDto.id,
      );
      expect(result).toEqual(defaultPersona);
      expect(result.isDefault).toBe(true);
    });
  });
});
