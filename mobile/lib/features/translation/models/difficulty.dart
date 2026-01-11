import 'package:freezed_annotation/freezed_annotation.dart';

/// Difficulty levels for learning content
enum Difficulty {
  @JsonValue('beginner')
  beginner,
  @JsonValue('intermediate')
  intermediate,
  @JsonValue('advanced')
  advanced;

  String get displayName {
    switch (this) {
      case Difficulty.beginner:
        return 'Beginner';
      case Difficulty.intermediate:
        return 'Intermediate';
      case Difficulty.advanced:
        return 'Advanced';
    }
  }

  String get value => name;
}
