// Gamification Feature Barrel File
library;

// Domain Models
export 'domain/models/badge.dart';
export 'domain/models/streak.dart';
export 'domain/models/ranking.dart';

// Domain Repositories
export 'domain/repositories/gamification_repository.dart';

// Data Repositories
export 'data/repositories/gamification_repository_impl.dart';

// Presentation
export 'presentation/providers/gamification_providers.dart';
export 'presentation/screens/badges_collection_screen.dart';
export 'presentation/screens/leaderboard_screen.dart';
export 'presentation/widgets/confetti_animation.dart';
export 'presentation/widgets/streak_calendar.dart';
export 'presentation/widgets/streak_widget.dart';
export 'presentation/widgets/badge_detail_modal.dart';
export 'presentation/widgets/level_up_animation.dart';
