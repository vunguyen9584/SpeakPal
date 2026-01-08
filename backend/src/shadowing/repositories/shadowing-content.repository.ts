import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { ShadowingContent, Level, ContentType, Prisma } from '@prisma/client';

@Injectable()
export class ShadowingContentRepository {
  private readonly logger = new Logger(ShadowingContentRepository.name);

  constructor(private readonly prisma: PrismaService) {}

  /**
   * Find random shadowing content
   */
  async findRandomContent(
    contentType: ContentType,
    level: Level,
    isPremiumUser: boolean = false,
  ): Promise<ShadowingContent | null> {
    try {
      const contents = await this.prisma.$queryRaw<ShadowingContent[]>`
        SELECT * FROM shadowing_contents
        WHERE content_type = ${contentType}
          AND level = ${level}
          AND is_active = true
          AND (is_premium = false OR ${isPremiumUser} = true)
        ORDER BY RANDOM()
        LIMIT 1
      `;

      return contents[0] || null;
    } catch (error) {
      this.logger.error(
        `Error finding random content: ${(error as Error).message}`,
      );
      throw error;
    }
  }

  /**
   * Find shadowing content by ID
   */
  async findById(id: string): Promise<ShadowingContent | null> {
    return this.prisma.shadowingContent.findUnique({
      where: { id },
    });
  }

  /**
   * Get all shadowing contents with filters
   */
  async findAll(filters: {
    contentType?: ContentType;
    level?: Level;
    isPremium?: boolean;
    limit?: number;
  }): Promise<ShadowingContent[]> {
    return this.prisma.shadowingContent.findMany({
      where: {
        ...(filters.contentType && { contentType: filters.contentType }),
        ...(filters.level && { level: filters.level }),
        ...(filters.isPremium !== undefined && {
          isPremium: filters.isPremium,
        }),
        isActive: true,
      },
      take: filters.limit || 20,
      orderBy: {
        createdAt: 'desc',
      },
    });
  }
}
