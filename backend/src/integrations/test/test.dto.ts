import { IsString, IsOptional } from 'class-validator';

export class TestOpenAIDto {
  @IsString()
  message: string;

  @IsString()
  @IsOptional()
  persona?: string;
}

export class TestElevenLabsDto {
  @IsString()
  text: string;

  @IsString()
  @IsOptional()
  voiceId?: string;
}

export class TestAppStoreDto {
  @IsString()
  receiptData: string;
}

export class TestPlayStoreDto {
  @IsString()
  productId: string;

  @IsString()
  purchaseToken: string;
}
