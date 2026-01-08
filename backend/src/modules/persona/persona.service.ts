import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { PersonaRepository } from './persona.repository';
import { PrismaService } from '../../prisma/prisma.service';
import { CreatePersonaDto } from './dto/create-persona.dto';
import { UpdatePersonaDto } from './dto/update-persona.dto';
import { PersonaDto } from './dto/persona-response.dto';
import { SubscriptionPlan, Persona } from '@prisma/client';

@Injectable()
export class PersonaService {
  constructor(
    private personaRepository: PersonaRepository,
    private prisma: PrismaService,
  ) {}

  async create(userId: string, dto: CreatePersonaDto): Promise<PersonaDto> {
    // Check current persona count
    const currentCount = await this.personaRepository.countByUserId(userId);

    // Get user's subscription plan
    const subscription = await this.prisma.subscription.findUnique({
      where: { userId },
    });

    // Check persona limit for free users (max 5)
    const plan = subscription?.plan || SubscriptionPlan.FREE;
    if (plan === SubscriptionPlan.FREE && currentCount >= 5) {
      throw new ForbiddenException(
        'Free users can create up to 5 personas. Upgrade to premium for unlimited personas.',
      );
    }

    // Check if this is the first persona
    const isFirstPersona = currentCount === 0;

    // Get user for creating the persona
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Create persona
    const persona = await this.personaRepository.create({
      name: dto.name,
      voice: dto.voice,
      personality: dto.personality,
      targetLevel: dto.targetLevel,
      isDefault: isFirstPersona, // Set first persona as default
      user: {
        connect: { id: userId },
      },
    });

    return this.mapToDto(persona);
  }

  async findAll(userId: string): Promise<PersonaDto[]> {
    const personas = await this.personaRepository.findByUserId(userId);
    return personas.map((persona) => this.mapToDto(persona));
  }

  async findById(userId: string, id: string): Promise<PersonaDto> {
    const persona = await this.personaRepository.findById(id);

    if (!persona) {
      throw new NotFoundException('Persona not found');
    }

    // Verify ownership
    if (persona.userId !== userId) {
      throw new NotFoundException('Persona not found');
    }

    return this.mapToDto(persona);
  }

  async update(
    userId: string,
    id: string,
    dto: UpdatePersonaDto,
  ): Promise<PersonaDto> {
    // Verify ownership first
    await this.findById(userId, id);

    // Update persona
    const updatedPersona = await this.personaRepository.update(id, dto);

    return this.mapToDto(updatedPersona);
  }

  async delete(userId: string, id: string): Promise<void> {
    // Verify ownership
    const persona = await this.findById(userId, id);

    // Cannot delete default persona
    if (persona.isDefault) {
      throw new BadRequestException(
        'Cannot delete default persona. Set another persona as default first.',
      );
    }

    await this.personaRepository.delete(id);
  }

  async setDefault(userId: string, id: string): Promise<PersonaDto> {
    // Verify ownership
    await this.findById(userId, id);

    // Unset all current defaults for this user
    await this.personaRepository.unsetAllDefaults(userId);

    // Set new default
    const updatedPersona = await this.personaRepository.update(id, {
      isDefault: true,
    });

    return this.mapToDto(updatedPersona);
  }

  /**
   * Helper method to map Persona entity to PersonaDto
   */
  private mapToDto(persona: Persona): PersonaDto {
    return {
      id: persona.id,
      userId: persona.userId,
      name: persona.name,
      voice: persona.voice,
      personality: persona.personality,
      targetLevel: persona.targetLevel,
      isDefault: persona.isDefault,
      createdAt: persona.createdAt,
    };
  }
}
