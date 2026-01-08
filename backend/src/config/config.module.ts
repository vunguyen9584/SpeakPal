import { Module } from '@nestjs/common';
import { ConfigModule as NestConfigModule } from '@nestjs/config';
import configuration from './configuration';
import externalServicesConfig from './external-services.config';
import { validate } from './validation';

@Module({
  imports: [
    NestConfigModule.forRoot({
      isGlobal: true,
      load: [configuration, externalServicesConfig],
      validate,
      envFilePath: '.env',
    }),
  ],
})
export class ConfigModule {}
