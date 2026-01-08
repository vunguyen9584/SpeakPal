import { IsString, IsEnum, IsOptional } from 'class-validator';

export class PurchaseRequestDto {
  @IsEnum(['ios', 'android'])
  platform: 'ios' | 'android';

  @IsString()
  @IsOptional()
  receipt?: string; // iOS receipt

  @IsString()
  @IsOptional()
  productId?: string; // Android product ID

  @IsString()
  @IsOptional()
  purchaseToken?: string; // Android purchase token
}

export class VerificationResult {
  success: boolean;
  expiryTime: Date;
  autoRenewing: boolean;
  orderId: string;
  platform: 'ios' | 'android';
  error?: string;
}
