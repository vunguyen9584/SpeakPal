import 'package:fpdart/fpdart.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/error/error_handler.dart';
import '../../domain/repositories/learning_repository.dart';
import '../../domain/models/vocabulary.dart';
import '../../domain/models/scenario.dart';
import '../../domain/models/challenge.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

class LearningRepositoryImpl implements LearningRepository {
  final ApiClient _apiClient;

  LearningRepositoryImpl(this._apiClient);

  @override
  Future<Either<AppError, List<Vocabulary>>> getVocabularies({
    int page = 1,
    int limit = 20,
    String? srsLevel,
    String? search,
  }) async {
    try {
      final queryParameters = {
        'page': page,
        'limit': limit,
        if (srsLevel != null) 'srsLevel': srsLevel,
        if (search != null) 'search': search,
      };

      final response = await _apiClient.get(ApiEndpoints.vocabularies, queryParameters: queryParameters);
      final data = (response.data['data'] as List).map((e) => Vocabulary.fromJson(e)).toList();
      return Right(data);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  @override
  Future<Either<AppError, Vocabulary>> getVocabulary(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.vocabularyById(id));
      return Right(Vocabulary.fromJson(response.data));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  @override
  Future<Either<AppError, void>> deleteVocabulary(String id) async {
    try {
      await _apiClient.delete(ApiEndpoints.vocabularyById(id));
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  @override
  Future<Either<AppError, Vocabulary>> addVocabulary(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.vocabularies, data: data);
      return Right(Vocabulary.fromJson(response.data));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  @override
  Future<Either<AppError, List<Vocabulary>>> getDueVocabularies() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.vocabularyDue);
      final data = (response.data as List).map((e) => Vocabulary.fromJson(e)).toList();
      return Right(data);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  @override
  Future<Either<AppError, Map<String, dynamic>>> recordReview(String vocabularyId, String result) async {
    try {
      final response = await _apiClient.post(
        '/vocabularies/$vocabularyId/review',
        data: {'result': result},
      );
      return Right(response.data as Map<String, dynamic>);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  @override
  Future<Either<AppError, List<Scenario>>> getScenarios({String? category, String? difficulty}) async {
    try {
      final queryParameters = {
        if (category != null) 'category': category,
        if (difficulty != null) 'difficulty': difficulty,
      };

      final response = await _apiClient.get(ApiEndpoints.scenarios, queryParameters: queryParameters);
      final data = (response.data as List).map((e) => Scenario.fromJson(e)).toList();
      return Right(data);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  @override
  Future<Either<AppError, Scenario>> getScenario(String id) async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.scenarios}/$id'); // ApiEndpoints doesn't have scenarioById yet, but scenarios is defined
      return Right(Scenario.fromJson(response.data));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  @override
  Future<Either<AppError, List<UserChallenge>>> getTodayChallenges() async {
    try {
      final response = await _apiClient.get('/challenges/today');
      final data = (response.data as List).map((e) => UserChallenge.fromJson(e)).toList();
      return Right(data);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }
}

