import '../models/vocabulary.dart';
import '../models/scenario.dart';
import '../models/challenge.dart';

abstract class LearningRepository {
  // Vocabulary
  Future<List<Vocabulary>> getVocabularies({
    int page = 1,
    int limit = 20,
    String? srsLevel,
    String? search,
  });

  Future<Vocabulary> addVocabulary(Map<String, dynamic> data);
  Future<List<Vocabulary>> getDueVocabularies();
  Future<Map<String, dynamic>> recordReview(String vocabularyId, String result);

  // Scenarios
  Future<List<Scenario>> getScenarios({String? category, String? difficulty});
  Future<Scenario> getScenario(String id);

  // Challenges
  Future<List<UserChallenge>> getTodayChallenges();
}
