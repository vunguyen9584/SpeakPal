import { Module } from '@nestjs/common';
import { CacheModule as NestCacheModule } from '@nestjs/cache-manager';
import { ConfigModule, ConfigService } from '@nestjs/config';
import * as redisStore from 'cache-manager-redis-store';
import { CacheService } from './cache.service';

@Module({
  imports: [
    NestCacheModule.registerAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        store: redisStore,
        url: configService.get<string>('redis.url'),
        ttl: 60 * 60, // 1 hour default TTL
        max: 100, // Maximum number of items in cache
      }),
      isGlobal: true,
    }),
  ],
  providers: [CacheService],
  exports: [CacheService],
})
export class CacheModule {}
