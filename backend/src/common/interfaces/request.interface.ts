export interface RequestUser {
  id?: string;
  userId?: string;
  email: string;
  subscriptionPlan?: string;
  subscriptionTier?: string;
  roles?: string[];
  subscription?: {
    plan?: string;
  };
}

export interface RequestWithUser extends Request {
  user: RequestUser;
}
