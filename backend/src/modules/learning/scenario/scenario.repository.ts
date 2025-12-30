import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';
import { Scenario } from '@prisma/client';

@Injectable()
export class ScenarioRepository {
  constructor(private prisma: PrismaService) {}

  async findAll(category?: string, difficulty?: string): Promise<Scenario[]> {
    return this.prisma.scenario.findMany({
      where: {
        ...(category && { category }),
        ...(difficulty && { difficulty }),
      },
      orderBy: { title: 'asc' },
    });
  }

  async findById(id: string): Promise<Scenario | null> {
    return this.prisma.scenario.findUnique({
      where: { id },
    });
  }

  async findByCategory(category: string): Promise<Scenario[]> {
    return this.prisma.scenario.findMany({
      where: { category },
      orderBy: { difficulty: 'asc' },
    });
  }
}
