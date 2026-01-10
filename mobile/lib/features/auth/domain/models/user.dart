import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum Level {
  @JsonValue('BEGINNER')
  beginner,
  @JsonValue('ELEMENTARY')
  elementary,
  @JsonValue('INTERMEDIATE')
  intermediate,
  @JsonValue('UPPER_INTERMEDIATE')
  upperIntermediate,
  @JsonValue('ADVANCED')
  advanced,
}

enum League {
  @JsonValue('BRONZE')
  bronze,
  @JsonValue('SILVER')
  silver,
  @JsonValue('GOLD')
  gold,
  @JsonValue('PLATINUM')
  platinum,
  @JsonValue('DIAMOND')
  diamond,
}

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? username,
    required Level level,
    required int totalXp,
    required int currentLevelXp,
    required League league,
    required double aiSpeed,
    required bool confirmationMode,
    required bool isVerified,
    DateTime? lastLoginAt,
    required DateTime createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
