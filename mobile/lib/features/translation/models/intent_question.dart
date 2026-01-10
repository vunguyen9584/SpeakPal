import 'package:freezed_annotation/freezed_annotation.dart';

part 'intent_question.freezed.dart';
part 'intent_question.g.dart';

@freezed
abstract class IntentQuestion with _$IntentQuestion {
  const factory IntentQuestion({
    required String id,
    required String situation,
    required String intent,
    required String category,
    required String difficulty,
    String? hint,
    List<String>? expectedExpressions,
  }) = _IntentQuestion;

  factory IntentQuestion.fromJson(Map<String, dynamic> json) =>
      _$IntentQuestionFromJson(json);
}

