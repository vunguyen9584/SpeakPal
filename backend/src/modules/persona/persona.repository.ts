import { Injectable } from '@nestjs/common';
import { Persona, Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class PersonaRepository {
  constructor(private prisma: PrismaService) {}

  async findById(id: string): Promise<Persona | null> {
    return this.prisma.persona.findUnique({
      where: { id },
    });
  }

  async findByUserId(userId: string): Promise<Persona[]> {
    return this.prisma.persona.findMany({
      where: { userId },
      orderBy: { createdAt: 'asc' },
    });
  }

  async countByUserId(userId: string): Promise<number> {
    return this.prisma.persona.count({
      where: { userId },
    });
  }

  async create(data: Prisma.PersonaCreateInput): Promise<Persona> {
    return this.prisma.persona.create({
      data,
    });
  }

  async update(id: string, data: Prisma.PersonaUpdateInput): Promise<Persona> {
    return this.prisma.persona.update({
      where: { id },
      data,
    });
  }

  async delete(id: string): Promise<Persona> {
    return this.prisma.persona.delete({
      where: { id },
    });
  }

  async unsetAllDefaults(userId: string): Promise<void> {
    await this.prisma.persona.updateMany({
      where: {
        userId,
        isDefault: true,
      },
      data: {
        isDefault: false,
      },
    });
  }

  async findDefault(userId: string): Promise<Persona | null> {
    return this.prisma.persona.findFirst({
      where: {
        userId,
        isDefault: true,
      },
    });
  }
}
