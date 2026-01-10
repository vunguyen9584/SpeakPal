import 'package:fpdart/fpdart.dart';
import '../../../../core/error/app_error.dart';
import '../models/vocabulary.dart';
import '../models/scenario.dart';
import '../models/challenge.dart';

abstract class LearningRepository {
  // Vocabulary
  Future<Either<AppError, List<Vocabulary>>> getVocabularies({
    int page = 1,
    int limit = 20,
    String? srsLevel,
    String? search,
  });

  Future<Either<AppError, Vocabulary>> addVocabulary(Map<String, dynamic> data);
  Future<Either<AppError, List<Vocabulary>>> getDueVocabularies();
  Future<Either<AppError, Map<String, dynamic>>> recordReview(String vocabularyId, String result);

  // Scenarios
  Future<Either<AppError, List<Scenario>>> getScenarios({String? category, String? difficulty});
  Future<Either<AppError, Scenario>> getScenario(String id);

  // Challenges
  Future<Either<AppError, List<UserChallenge>>> getTodayChallenges();
}

