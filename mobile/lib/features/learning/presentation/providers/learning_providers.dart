import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/vocabulary.dart';
import '../../domain/models/scenario.dart';
import '../../domain/models/challenge.dart';
import '../../domain/repositories/learning_repository.dart';
import '../../data/repositories/learning_repository_impl.dart';
import '../../../../core/providers/providers.dart';

// Repository provider
final learningRepositoryProvider = Provider<LearningRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return LearningRepositoryImpl(apiClient);
});

// Vocabulary List Provider with filters
final vocabularyListProvider = FutureProvider.family<List<Vocabulary>, VocabularyFilters>(
  (ref, filters) async {
    final repository = ref.watch(learningRepositoryProvider);
    return repository.getVocabularies(
      page: filters.page,
      limit: filters.limit,
      srsLevel: filters.srsLevel,
      search: filters.search,
    );
  },
);

// Due Vocabulary Provider
final dueVocabularyProvider = FutureProvider<List<Vocabulary>>((ref) async {
  final repository = ref.watch(learningRepositoryProvider);
  return repository.getDueVocabularies();
});

// Vocabulary Detail Provider
final vocabularyDetailProvider = FutureProvider.family<Vocabulary, String>(
  (ref, vocabularyId) async {
    final repository = ref.watch(learningRepositoryProvider);
    // TODO: Implement getVocabularyById in repository
    final vocabularies = await repository.getVocabularies(page: 1, limit: 100);
    return vocabularies.firstWhere((v) => v.id == vocabularyId);
  },
);

// Scenario List Provider with filters
final scenarioListProvider = FutureProvider.family<List<Scenario>, ScenarioFilters>(
  (ref, filters) async {
    final repository = ref.watch(learningRepositoryProvider);
    return repository.getScenarios(
      category: filters.category,
      difficulty: filters.difficulty,
    );
  },
);

// Scenario Detail Provider
final scenarioDetailProvider = FutureProvider.family<Scenario, String>(
  (ref, scenarioId) async {
    final repository = ref.watch(learningRepositoryProvider);
    return repository.getScenarioDetail(scenarioId);
  },
);

// Today's Challenges Provider
final todayChallengesProvider = FutureProvider<List<UserChallenge>>((ref) async {
  final repository = ref.watch(learningRepositoryProvider);
  return repository.getTodayChallenges();
});

// Review submission handler
final reviewVocabularyProvider = Provider((ref) {
  return (String vocabularyId, bool correct) async {
    final repository = ref.read(learningRepositoryProvider);
    await repository.recordReview(vocabularyId, correct);

    // Invalidate providers to refresh data
    ref.invalidate(vocabularyListProvider);
    ref.invalidate(dueVocabularyProvider);
    ref.invalidate(vocabularyDetailProvider(vocabularyId));
  };
});

// Add vocabulary handler
final addVocabularyProvider = Provider((ref) {
  return (String word, String meaning, String pronunciation, String? exampleSentence) async {
    final repository = ref.read(learningRepositoryProvider);
    await repository.addVocabulary(
      word: word,
      meaning: meaning,
      pronunciation: pronunciation,
      exampleSentence: exampleSentence,
    );

    // Invalidate to refresh list
    ref.invalidate(vocabularyListProvider);
  };
});

// Delete vocabulary handler
final deleteVocabularyProvider = Provider((ref) {
  return (String vocabularyId) async {
    final repository = ref.read(learningRepositoryProvider);
    // TODO: Implement deleteVocabulary in repository

    // Invalidate to refresh list
    ref.invalidate(vocabularyListProvider);
  };
});

// Filter classes
class VocabularyFilters {
  final int page;
  final int limit;
  final String? srsLevel;
  final String? search;

  const VocabularyFilters({
    this.page = 1,
    this.limit = 20,
    this.srsLevel,
    this.search,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VocabularyFilters &&
          page == other.page &&
          limit == other.limit &&
          srsLevel == other.srsLevel &&
          search == other.search;

  @override
  int get hashCode =>
      page.hashCode ^ limit.hashCode ^ srsLevel.hashCode ^ search.hashCode;
}

class ScenarioFilters {
  final String? category;
  final String? difficulty;

  const ScenarioFilters({
    this.category,
    this.difficulty,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScenarioFilters &&
          category == other.category &&
          difficulty == other.difficulty;

  @override
  int get hashCode => category.hashCode ^ difficulty.hashCode;
}
