// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  email: json['email'] as String,
  username: json['username'] as String?,
  level: $enumDecode(_$LevelEnumMap, json['level']),
  totalXp: (json['totalXp'] as num).toInt(),
  currentLevelXp: (json['currentLevelXp'] as num).toInt(),
  league: $enumDecode(_$LeagueEnumMap, json['league']),
  aiSpeed: (json['aiSpeed'] as num).toDouble(),
  confirmationMode: json['confirmationMode'] as bool,
  isVerified: json['isVerified'] as bool,
  lastLoginAt: json['lastLoginAt'] == null
      ? null
      : DateTime.parse(json['lastLoginAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'username': instance.username,
  'level': _$LevelEnumMap[instance.level]!,
  'totalXp': instance.totalXp,
  'currentLevelXp': instance.currentLevelXp,
  'league': _$LeagueEnumMap[instance.league]!,
  'aiSpeed': instance.aiSpeed,
  'confirmationMode': instance.confirmationMode,
  'isVerified': instance.isVerified,
  'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$LevelEnumMap = {
  Level.beginner: 'BEGINNER',
  Level.elementary: 'ELEMENTARY',
  Level.intermediate: 'INTERMEDIATE',
  Level.upperIntermediate: 'UPPER_INTERMEDIATE',
  Level.advanced: 'ADVANCED',
};

const _$LeagueEnumMap = {
  League.bronze: 'BRONZE',
  League.silver: 'SILVER',
  League.gold: 'GOLD',
  League.platinum: 'PLATINUM',
  League.diamond: 'DIAMOND',
};
