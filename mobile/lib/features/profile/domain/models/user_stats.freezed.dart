// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserStats {

 int get totalConversations; int get totalVocabulary; int get currentStreak; int get longestStreak; int get totalBadges; int get totalXp; double get averageAccuracy; int get totalMinutes;
/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserStatsCopyWith<UserStats> get copyWith => _$UserStatsCopyWithImpl<UserStats>(this as UserStats, _$identity);

  /// Serializes this UserStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserStats&&(identical(other.totalConversations, totalConversations) || other.totalConversations == totalConversations)&&(identical(other.totalVocabulary, totalVocabulary) || other.totalVocabulary == totalVocabulary)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.totalBadges, totalBadges) || other.totalBadges == totalBadges)&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.averageAccuracy, averageAccuracy) || other.averageAccuracy == averageAccuracy)&&(identical(other.totalMinutes, totalMinutes) || other.totalMinutes == totalMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalConversations,totalVocabulary,currentStreak,longestStreak,totalBadges,totalXp,averageAccuracy,totalMinutes);

@override
String toString() {
  return 'UserStats(totalConversations: $totalConversations, totalVocabulary: $totalVocabulary, currentStreak: $currentStreak, longestStreak: $longestStreak, totalBadges: $totalBadges, totalXp: $totalXp, averageAccuracy: $averageAccuracy, totalMinutes: $totalMinutes)';
}


}

/// @nodoc
abstract mixin class $UserStatsCopyWith<$Res>  {
  factory $UserStatsCopyWith(UserStats value, $Res Function(UserStats) _then) = _$UserStatsCopyWithImpl;
@useResult
$Res call({
 int totalConversations, int totalVocabulary, int currentStreak, int longestStreak, int totalBadges, int totalXp, double averageAccuracy, int totalMinutes
});




}
/// @nodoc
class _$UserStatsCopyWithImpl<$Res>
    implements $UserStatsCopyWith<$Res> {
  _$UserStatsCopyWithImpl(this._self, this._then);

  final UserStats _self;
  final $Res Function(UserStats) _then;

/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalConversations = null,Object? totalVocabulary = null,Object? currentStreak = null,Object? longestStreak = null,Object? totalBadges = null,Object? totalXp = null,Object? averageAccuracy = null,Object? totalMinutes = null,}) {
  return _then(_self.copyWith(
totalConversations: null == totalConversations ? _self.totalConversations : totalConversations // ignore: cast_nullable_to_non_nullable
as int,totalVocabulary: null == totalVocabulary ? _self.totalVocabulary : totalVocabulary // ignore: cast_nullable_to_non_nullable
as int,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,totalBadges: null == totalBadges ? _self.totalBadges : totalBadges // ignore: cast_nullable_to_non_nullable
as int,totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,averageAccuracy: null == averageAccuracy ? _self.averageAccuracy : averageAccuracy // ignore: cast_nullable_to_non_nullable
as double,totalMinutes: null == totalMinutes ? _self.totalMinutes : totalMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserStats].
extension UserStatsPatterns on UserStats {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserStats() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserStats value)  $default,){
final _that = this;
switch (_that) {
case _UserStats():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserStats value)?  $default,){
final _that = this;
switch (_that) {
case _UserStats() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalConversations,  int totalVocabulary,  int currentStreak,  int longestStreak,  int totalBadges,  int totalXp,  double averageAccuracy,  int totalMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserStats() when $default != null:
return $default(_that.totalConversations,_that.totalVocabulary,_that.currentStreak,_that.longestStreak,_that.totalBadges,_that.totalXp,_that.averageAccuracy,_that.totalMinutes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalConversations,  int totalVocabulary,  int currentStreak,  int longestStreak,  int totalBadges,  int totalXp,  double averageAccuracy,  int totalMinutes)  $default,) {final _that = this;
switch (_that) {
case _UserStats():
return $default(_that.totalConversations,_that.totalVocabulary,_that.currentStreak,_that.longestStreak,_that.totalBadges,_that.totalXp,_that.averageAccuracy,_that.totalMinutes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalConversations,  int totalVocabulary,  int currentStreak,  int longestStreak,  int totalBadges,  int totalXp,  double averageAccuracy,  int totalMinutes)?  $default,) {final _that = this;
switch (_that) {
case _UserStats() when $default != null:
return $default(_that.totalConversations,_that.totalVocabulary,_that.currentStreak,_that.longestStreak,_that.totalBadges,_that.totalXp,_that.averageAccuracy,_that.totalMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserStats implements UserStats {
  const _UserStats({required this.totalConversations, required this.totalVocabulary, required this.currentStreak, required this.longestStreak, required this.totalBadges, required this.totalXp, required this.averageAccuracy, required this.totalMinutes});
  factory _UserStats.fromJson(Map<String, dynamic> json) => _$UserStatsFromJson(json);

@override final  int totalConversations;
@override final  int totalVocabulary;
@override final  int currentStreak;
@override final  int longestStreak;
@override final  int totalBadges;
@override final  int totalXp;
@override final  double averageAccuracy;
@override final  int totalMinutes;

/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserStatsCopyWith<_UserStats> get copyWith => __$UserStatsCopyWithImpl<_UserStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserStats&&(identical(other.totalConversations, totalConversations) || other.totalConversations == totalConversations)&&(identical(other.totalVocabulary, totalVocabulary) || other.totalVocabulary == totalVocabulary)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.totalBadges, totalBadges) || other.totalBadges == totalBadges)&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.averageAccuracy, averageAccuracy) || other.averageAccuracy == averageAccuracy)&&(identical(other.totalMinutes, totalMinutes) || other.totalMinutes == totalMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalConversations,totalVocabulary,currentStreak,longestStreak,totalBadges,totalXp,averageAccuracy,totalMinutes);

@override
String toString() {
  return 'UserStats(totalConversations: $totalConversations, totalVocabulary: $totalVocabulary, currentStreak: $currentStreak, longestStreak: $longestStreak, totalBadges: $totalBadges, totalXp: $totalXp, averageAccuracy: $averageAccuracy, totalMinutes: $totalMinutes)';
}


}

/// @nodoc
abstract mixin class _$UserStatsCopyWith<$Res> implements $UserStatsCopyWith<$Res> {
  factory _$UserStatsCopyWith(_UserStats value, $Res Function(_UserStats) _then) = __$UserStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalConversations, int totalVocabulary, int currentStreak, int longestStreak, int totalBadges, int totalXp, double averageAccuracy, int totalMinutes
});




}
/// @nodoc
class __$UserStatsCopyWithImpl<$Res>
    implements _$UserStatsCopyWith<$Res> {
  __$UserStatsCopyWithImpl(this._self, this._then);

  final _UserStats _self;
  final $Res Function(_UserStats) _then;

/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalConversations = null,Object? totalVocabulary = null,Object? currentStreak = null,Object? longestStreak = null,Object? totalBadges = null,Object? totalXp = null,Object? averageAccuracy = null,Object? totalMinutes = null,}) {
  return _then(_UserStats(
totalConversations: null == totalConversations ? _self.totalConversations : totalConversations // ignore: cast_nullable_to_non_nullable
as int,totalVocabulary: null == totalVocabulary ? _self.totalVocabulary : totalVocabulary // ignore: cast_nullable_to_non_nullable
as int,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,totalBadges: null == totalBadges ? _self.totalBadges : totalBadges // ignore: cast_nullable_to_non_nullable
as int,totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,averageAccuracy: null == averageAccuracy ? _self.averageAccuracy : averageAccuracy // ignore: cast_nullable_to_non_nullable
as double,totalMinutes: null == totalMinutes ? _self.totalMinutes : totalMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
