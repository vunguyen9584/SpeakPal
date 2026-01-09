import {
  Injectable,
  OnModuleInit,
  OnModuleDestroy,
  Logger,
} from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class PrismaService
  extends PrismaClient
  implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(PrismaService.name);
  private pool: Pool;
  private initialized = false;

  constructor(private config: ConfigService) {
    const connectionString = config.get<string>('DATABASE_URL');

    if (!connectionString) {
      throw new Error(
        'DATABASE_URL is not configured. Please set DATABASE_URL environment variable.',
      );
    }

    // Create a connection pool
    const pool = new Pool({ connectionString });

    // Create the adapter
    const adapter = new PrismaPg(pool);

    super({
      adapter,
      log: ['error'],
    });

    this.pool = pool;
  }

  async onModuleInit() {
    try {
      await this.$connect();
      this.initialized = true;
      this.logger.log('Database connection established successfully');
    } catch (error) {
      this.logger.error(
        `Failed to connect to database: ${(error as Error).message}`,
      );
      throw error;
    }
  }

  async onModuleDestroy() {
    if (this.initialized) {
      await this.$disconnect();
    }
    await this.pool.end();
  }

  /**
   * Check if the service is connected
   */
  isConnected(): boolean {
    return this.initialized;
  }
}
