import { Global, Module, Provider, Injectable } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { OnModuleInit, OnModuleDestroy, Logger } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';
import { Test, TestingModuleBuilder } from '@nestjs/testing';
import { FirebaseService } from '../src/integrations/firebase/firebase.service';
import { PrismaService } from '../src/prisma/prisma.service';
import { AppModule } from '../src/app.module';

/**
 * Mock FirebaseService for testing
 * Provides stub implementations that don't require actual Firebase credentials
 */
@Injectable()
export class MockFirebaseService {
    onModuleInit() {
        // No-op for tests
    }

    async verifyIdToken(
        _idToken: string,
    ): Promise<{ uid: string; email: string }> {
        return {
            uid: 'test-uid-123',
            email: 'test@example.com',
        };
    }

    async getUser(_uid: string): Promise<{
        uid: string;
        email: string;
        displayName: string;
    }> {
        return {
            uid: 'test-uid-123',
            email: 'test@example.com',
            displayName: 'Test User',
        };
    }
}

/**
 * Test PrismaService for E2E testing
 * Uses the same driver adapter pattern as production but with better error handling
 */
@Injectable()
export class TestPrismaService
    extends PrismaClient
    implements OnModuleInit, OnModuleDestroy {
    private readonly logger = new Logger(TestPrismaService.name);
    private pool: Pool;
    private initialized = false;

    constructor(configService: ConfigService) {
        const connectionString = configService.get<string>('DATABASE_URL');

        if (!connectionString) {
            console.warn(
                'Test database not configured. Set DATABASE_URL to a valid test database.',
            );
        }

        // Create a connection pool - will fail gracefully if DB not available
        const pool = new Pool({
            connectionString:
                connectionString ||
                'postgresql://test:test@localhost:5432/speakpal_test',
        });

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
            this.logger.log('Test database connection established');
        } catch (error) {
            this.logger.warn(
                `Test database connection failed: ${(error as Error).message}`,
            );
            // Don't throw in tests - allows tests to check for connection before operations
        }
    }

    async onModuleDestroy() {
        if (this.initialized) {
            try {
                await this.$disconnect();
            } catch {
                // Ignore errors during cleanup
            }
        }
        try {
            await this.pool.end();
        } catch {
            // Ignore pool cleanup errors
        }
    }

    isConnected(): boolean {
        return this.initialized;
    }
}

/**
 * Get test providers for overriding external services
 */
export function getTestProviders(): Provider[] {
    return [
        {
            provide: FirebaseService,
            useClass: MockFirebaseService,
        },
        {
            provide: PrismaService,
            useClass: TestPrismaService,
        },
    ];
}

/**
 * Create a TestingModuleBuilder with all external services mocked
 * Usage:
 *   const moduleFixture = await createTestingModule().compile();
 *   app = moduleFixture.createNestApplication();
 *   await app.init();
 */
export function createTestingModule(): TestingModuleBuilder {
    return Test.createTestingModule({
        imports: [AppModule],
    })
        .overrideProvider(FirebaseService)
        .useClass(MockFirebaseService)
        .overrideProvider(PrismaService)
        .useClass(TestPrismaService);
}

/**
 * Test module configuration for E2E tests
 * Provides mocked external services while using real business logic
 */
@Global()
@Module({
    imports: [
        ConfigModule.forRoot({
            isGlobal: true,
            envFilePath: ['.env.test', '.env'],
        }),
    ],
    providers: [ConfigService, ...getTestProviders()],
    exports: [ConfigService, FirebaseService, PrismaService],
})
export class TestHelperModule { }
