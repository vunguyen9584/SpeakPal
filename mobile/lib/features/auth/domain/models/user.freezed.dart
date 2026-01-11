// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

 String get id; String get email; String? get username; Level get level; int get totalXp; int get currentLevelXp; League get league; double get aiSpeed; bool get confirmationMode; bool get isVerified; DateTime? get lastLoginAt; DateTime get createdAt;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.level, level) || other.level == level)&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.currentLevelXp, currentLevelXp) || other.currentLevelXp == currentLevelXp)&&(identical(other.league, league) || other.league == league)&&(identical(other.aiSpeed, aiSpeed) || other.aiSpeed == aiSpeed)&&(identical(other.confirmationMode, confirmationMode) || other.confirmationMode == confirmationMode)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,username,level,totalXp,currentLevelXp,league,aiSpeed,confirmationMode,isVerified,lastLoginAt,createdAt);

@override
String toString() {
  return 'User(id: $id, email: $email, username: $username, level: $level, totalXp: $totalXp, currentLevelXp: $currentLevelXp, league: $league, aiSpeed: $aiSpeed, confirmationMode: $confirmationMode, isVerified: $isVerified, lastLoginAt: $lastLoginAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String id, String email, String? username, Level level, int totalXp, int currentLevelXp, League league, double aiSpeed, bool confirmationMode, bool isVerified, DateTime? lastLoginAt, DateTime createdAt
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? username = freezed,Object? level = null,Object? totalXp = null,Object? currentLevelXp = null,Object? league = null,Object? aiSpeed = null,Object? confirmationMode = null,Object? isVerified = null,Object? lastLoginAt = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as Level,totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,currentLevelXp: null == currentLevelXp ? _self.currentLevelXp : currentLevelXp // ignore: cast_nullable_to_non_nullable
as int,league: null == league ? _self.league : league // ignore: cast_nullable_to_non_nullable
as League,aiSpeed: null == aiSpeed ? _self.aiSpeed : aiSpeed // ignore: cast_nullable_to_non_nullable
as double,confirmationMode: null == confirmationMode ? _self.confirmationMode : confirmationMode // ignore: cast_nullable_to_non_nullable
as bool,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String? username,  Level level,  int totalXp,  int currentLevelXp,  League league,  double aiSpeed,  bool confirmationMode,  bool isVerified,  DateTime? lastLoginAt,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.level,_that.totalXp,_that.currentLevelXp,_that.league,_that.aiSpeed,_that.confirmationMode,_that.isVerified,_that.lastLoginAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String? username,  Level level,  int totalXp,  int currentLevelXp,  League league,  double aiSpeed,  bool confirmationMode,  bool isVerified,  DateTime? lastLoginAt,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.email,_that.username,_that.level,_that.totalXp,_that.currentLevelXp,_that.league,_that.aiSpeed,_that.confirmationMode,_that.isVerified,_that.lastLoginAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String? username,  Level level,  int totalXp,  int currentLevelXp,  League league,  double aiSpeed,  bool confirmationMode,  bool isVerified,  DateTime? lastLoginAt,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.level,_that.totalXp,_that.currentLevelXp,_that.league,_that.aiSpeed,_that.confirmationMode,_that.isVerified,_that.lastLoginAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({required this.id, required this.email, this.username, required this.level, required this.totalXp, required this.currentLevelXp, required this.league, required this.aiSpeed, required this.confirmationMode, required this.isVerified, this.lastLoginAt, required this.createdAt});
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  String id;
@override final  String email;
@override final  String? username;
@override final  Level level;
@override final  int totalXp;
@override final  int currentLevelXp;
@override final  League league;
@override final  double aiSpeed;
@override final  bool confirmationMode;
@override final  bool isVerified;
@override final  DateTime? lastLoginAt;
@override final  DateTime createdAt;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.level, level) || other.level == level)&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.currentLevelXp, currentLevelXp) || other.currentLevelXp == currentLevelXp)&&(identical(other.league, league) || other.league == league)&&(identical(other.aiSpeed, aiSpeed) || other.aiSpeed == aiSpeed)&&(identical(other.confirmationMode, confirmationMode) || other.confirmationMode == confirmationMode)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,username,level,totalXp,currentLevelXp,league,aiSpeed,confirmationMode,isVerified,lastLoginAt,createdAt);

@override
String toString() {
  return 'User(id: $id, email: $email, username: $username, level: $level, totalXp: $totalXp, currentLevelXp: $currentLevelXp, league: $league, aiSpeed: $aiSpeed, confirmationMode: $confirmationMode, isVerified: $isVerified, lastLoginAt: $lastLoginAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String? username, Level level, int totalXp, int currentLevelXp, League league, double aiSpeed, bool confirmationMode, bool isVerified, DateTime? lastLoginAt, DateTime createdAt
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? username = freezed,Object? level = null,Object? totalXp = null,Object? currentLevelXp = null,Object? league = null,Object? aiSpeed = null,Object? confirmationMode = null,Object? isVerified = null,Object? lastLoginAt = freezed,Object? createdAt = null,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as Level,totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,currentLevelXp: null == currentLevelXp ? _self.currentLevelXp : currentLevelXp // ignore: cast_nullable_to_non_nullable
as int,league: null == league ? _self.league : league // ignore: cast_nullable_to_non_nullable
as League,aiSpeed: null == aiSpeed ? _self.aiSpeed : aiSpeed // ignore: cast_nullable_to_non_nullable
as double,confirmationMode: null == confirmationMode ? _self.confirmationMode : confirmationMode // ignore: cast_nullable_to_non_nullable
as bool,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
