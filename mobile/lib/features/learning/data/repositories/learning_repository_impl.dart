import '../../domain/repositories/learning_repository.dart';
import '../../domain/models/vocabulary.dart';
import '../../domain/models/scenario.dart';
import '../../domain/models/challenge.dart';
import '../../../../core/services/api_client.dart';

class LearningRepositoryImpl implements LearningRepository {
  final ApiClient _apiClient;

  LearningRepositoryImpl(this._apiClient);

  @override
  Future<List<Vocabulary>> getVocabularies({
    int page = 1,
    int limit = 20,
    String? srsLevel,
    String? search,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (srsLevel != null) 'srsLevel': srsLevel,
      if (search != null) 'search': search,
    };

    final response = await _apiClient.get('/vocabularies', queryParams: queryParams);
    final data = (response['data'] as List).map((e) => Vocabulary.fromJson(e)).toList();
    return data;
  }

  @override
  Future<Vocabulary> addVocabulary(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/vocabularies', data: data);
    return Vocabulary.fromJson(response);
  }

  @override
  Future<List<Vocabulary>> getDueVocabularies() async {
    final response = await _apiClient.get('/vocabularies/due');
    return (response as List).map((e) => Vocabulary.fromJson(e)).toList();
  }

  @override
  Future<Map<String, dynamic>> recordReview(String vocabularyId, String result) async {
    return await _apiClient.post(
      '/vocabularies/$vocabularyId/review',
      data: {'result': result},
    );
  }

  @override
  Future<List<Scenario>> getScenarios({String? category, String? difficulty}) async {
    final queryParams = {
      if (category != null) 'category': category,
      if (difficulty != null) 'difficulty': difficulty,
    };

    final response = await _apiClient.get('/scenarios', queryParams: queryParams);
    return (response as List).map((e) => Scenario.fromJson(e)).toList();
  }

  @override
  Future<Scenario> getScenario(String id) async {
    final response = await _apiClient.get('/scenarios/$id');
    return Scenario.fromJson(response);
  }

  @override
  Future<List<UserChallenge>> getTodayChallenges() async {
    final response = await _apiClient.get('/challenges/today');
    return (response as List).map((e) => UserChallenge.fromJson(e)).toList();
  }
}
