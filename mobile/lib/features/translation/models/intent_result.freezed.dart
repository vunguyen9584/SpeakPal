// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'intent_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IntentResult {

 String get id; String get questionId; String get userExpression; int get totalScore; IntentScoreBreakdown get breakdown; List<String> get alternativeExpressions; List<String> get feedback; int get xpEarned;
/// Create a copy of IntentResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IntentResultCopyWith<IntentResult> get copyWith => _$IntentResultCopyWithImpl<IntentResult>(this as IntentResult, _$identity);

  /// Serializes this IntentResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IntentResult&&(identical(other.id, id) || other.id == id)&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.userExpression, userExpression) || other.userExpression == userExpression)&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore)&&(identical(other.breakdown, breakdown) || other.breakdown == breakdown)&&const DeepCollectionEquality().equals(other.alternativeExpressions, alternativeExpressions)&&const DeepCollectionEquality().equals(other.feedback, feedback)&&(identical(other.xpEarned, xpEarned) || other.xpEarned == xpEarned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,questionId,userExpression,totalScore,breakdown,const DeepCollectionEquality().hash(alternativeExpressions),const DeepCollectionEquality().hash(feedback),xpEarned);

@override
String toString() {
  return 'IntentResult(id: $id, questionId: $questionId, userExpression: $userExpression, totalScore: $totalScore, breakdown: $breakdown, alternativeExpressions: $alternativeExpressions, feedback: $feedback, xpEarned: $xpEarned)';
}


}

/// @nodoc
abstract mixin class $IntentResultCopyWith<$Res>  {
  factory $IntentResultCopyWith(IntentResult value, $Res Function(IntentResult) _then) = _$IntentResultCopyWithImpl;
@useResult
$Res call({
 String id, String questionId, String userExpression, int totalScore, IntentScoreBreakdown breakdown, List<String> alternativeExpressions, List<String> feedback, int xpEarned
});


$IntentScoreBreakdownCopyWith<$Res> get breakdown;

}
/// @nodoc
class _$IntentResultCopyWithImpl<$Res>
    implements $IntentResultCopyWith<$Res> {
  _$IntentResultCopyWithImpl(this._self, this._then);

  final IntentResult _self;
  final $Res Function(IntentResult) _then;

/// Create a copy of IntentResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? questionId = null,Object? userExpression = null,Object? totalScore = null,Object? breakdown = null,Object? alternativeExpressions = null,Object? feedback = null,Object? xpEarned = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,userExpression: null == userExpression ? _self.userExpression : userExpression // ignore: cast_nullable_to_non_nullable
as String,totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as int,breakdown: null == breakdown ? _self.breakdown : breakdown // ignore: cast_nullable_to_non_nullable
as IntentScoreBreakdown,alternativeExpressions: null == alternativeExpressions ? _self.alternativeExpressions : alternativeExpressions // ignore: cast_nullable_to_non_nullable
as List<String>,feedback: null == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as List<String>,xpEarned: null == xpEarned ? _self.xpEarned : xpEarned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of IntentResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IntentScoreBreakdownCopyWith<$Res> get breakdown {
  
  return $IntentScoreBreakdownCopyWith<$Res>(_self.breakdown, (value) {
    return _then(_self.copyWith(breakdown: value));
  });
}
}


/// Adds pattern-matching-related methods to [IntentResult].
extension IntentResultPatterns on IntentResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IntentResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IntentResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IntentResult value)  $default,){
final _that = this;
switch (_that) {
case _IntentResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IntentResult value)?  $default,){
final _that = this;
switch (_that) {
case _IntentResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String questionId,  String userExpression,  int totalScore,  IntentScoreBreakdown breakdown,  List<String> alternativeExpressions,  List<String> feedback,  int xpEarned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IntentResult() when $default != null:
return $default(_that.id,_that.questionId,_that.userExpression,_that.totalScore,_that.breakdown,_that.alternativeExpressions,_that.feedback,_that.xpEarned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String questionId,  String userExpression,  int totalScore,  IntentScoreBreakdown breakdown,  List<String> alternativeExpressions,  List<String> feedback,  int xpEarned)  $default,) {final _that = this;
switch (_that) {
case _IntentResult():
return $default(_that.id,_that.questionId,_that.userExpression,_that.totalScore,_that.breakdown,_that.alternativeExpressions,_that.feedback,_that.xpEarned);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String questionId,  String userExpression,  int totalScore,  IntentScoreBreakdown breakdown,  List<String> alternativeExpressions,  List<String> feedback,  int xpEarned)?  $default,) {final _that = this;
switch (_that) {
case _IntentResult() when $default != null:
return $default(_that.id,_that.questionId,_that.userExpression,_that.totalScore,_that.breakdown,_that.alternativeExpressions,_that.feedback,_that.xpEarned);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IntentResult implements IntentResult {
  const _IntentResult({required this.id, required this.questionId, required this.userExpression, required this.totalScore, required this.breakdown, required final  List<String> alternativeExpressions, required final  List<String> feedback, required this.xpEarned}): _alternativeExpressions = alternativeExpressions,_feedback = feedback;
  factory _IntentResult.fromJson(Map<String, dynamic> json) => _$IntentResultFromJson(json);

@override final  String id;
@override final  String questionId;
@override final  String userExpression;
@override final  int totalScore;
@override final  IntentScoreBreakdown breakdown;
 final  List<String> _alternativeExpressions;
@override List<String> get alternativeExpressions {
  if (_alternativeExpressions is EqualUnmodifiableListView) return _alternativeExpressions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alternativeExpressions);
}

 final  List<String> _feedback;
@override List<String> get feedback {
  if (_feedback is EqualUnmodifiableListView) return _feedback;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_feedback);
}

@override final  int xpEarned;

/// Create a copy of IntentResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IntentResultCopyWith<_IntentResult> get copyWith => __$IntentResultCopyWithImpl<_IntentResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IntentResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IntentResult&&(identical(other.id, id) || other.id == id)&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.userExpression, userExpression) || other.userExpression == userExpression)&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore)&&(identical(other.breakdown, breakdown) || other.breakdown == breakdown)&&const DeepCollectionEquality().equals(other._alternativeExpressions, _alternativeExpressions)&&const DeepCollectionEquality().equals(other._feedback, _feedback)&&(identical(other.xpEarned, xpEarned) || other.xpEarned == xpEarned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,questionId,userExpression,totalScore,breakdown,const DeepCollectionEquality().hash(_alternativeExpressions),const DeepCollectionEquality().hash(_feedback),xpEarned);

@override
String toString() {
  return 'IntentResult(id: $id, questionId: $questionId, userExpression: $userExpression, totalScore: $totalScore, breakdown: $breakdown, alternativeExpressions: $alternativeExpressions, feedback: $feedback, xpEarned: $xpEarned)';
}


}

/// @nodoc
abstract mixin class _$IntentResultCopyWith<$Res> implements $IntentResultCopyWith<$Res> {
  factory _$IntentResultCopyWith(_IntentResult value, $Res Function(_IntentResult) _then) = __$IntentResultCopyWithImpl;
@override @useResult
$Res call({
 String id, String questionId, String userExpression, int totalScore, IntentScoreBreakdown breakdown, List<String> alternativeExpressions, List<String> feedback, int xpEarned
});


@override $IntentScoreBreakdownCopyWith<$Res> get breakdown;

}
/// @nodoc
class __$IntentResultCopyWithImpl<$Res>
    implements _$IntentResultCopyWith<$Res> {
  __$IntentResultCopyWithImpl(this._self, this._then);

  final _IntentResult _self;
  final $Res Function(_IntentResult) _then;

/// Create a copy of IntentResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? questionId = null,Object? userExpression = null,Object? totalScore = null,Object? breakdown = null,Object? alternativeExpressions = null,Object? feedback = null,Object? xpEarned = null,}) {
  return _then(_IntentResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,userExpression: null == userExpression ? _self.userExpression : userExpression // ignore: cast_nullable_to_non_nullable
as String,totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as int,breakdown: null == breakdown ? _self.breakdown : breakdown // ignore: cast_nullable_to_non_nullable
as IntentScoreBreakdown,alternativeExpressions: null == alternativeExpressions ? _self._alternativeExpressions : alternativeExpressions // ignore: cast_nullable_to_non_nullable
as List<String>,feedback: null == feedback ? _self._feedback : feedback // ignore: cast_nullable_to_non_nullable
as List<String>,xpEarned: null == xpEarned ? _self.xpEarned : xpEarned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of IntentResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IntentScoreBreakdownCopyWith<$Res> get breakdown {
  
  return $IntentScoreBreakdownCopyWith<$Res>(_self.breakdown, (value) {
    return _then(_self.copyWith(breakdown: value));
  });
}
}


/// @nodoc
mixin _$IntentScoreBreakdown {

 int get intentScore; int get naturalnessScore; int get vocabularyScore;
/// Create a copy of IntentScoreBreakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IntentScoreBreakdownCopyWith<IntentScoreBreakdown> get copyWith => _$IntentScoreBreakdownCopyWithImpl<IntentScoreBreakdown>(this as IntentScoreBreakdown, _$identity);

  /// Serializes this IntentScoreBreakdown to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IntentScoreBreakdown&&(identical(other.intentScore, intentScore) || other.intentScore == intentScore)&&(identical(other.naturalnessScore, naturalnessScore) || other.naturalnessScore == naturalnessScore)&&(identical(other.vocabularyScore, vocabularyScore) || other.vocabularyScore == vocabularyScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,intentScore,naturalnessScore,vocabularyScore);

@override
String toString() {
  return 'IntentScoreBreakdown(intentScore: $intentScore, naturalnessScore: $naturalnessScore, vocabularyScore: $vocabularyScore)';
}


}

/// @nodoc
abstract mixin class $IntentScoreBreakdownCopyWith<$Res>  {
  factory $IntentScoreBreakdownCopyWith(IntentScoreBreakdown value, $Res Function(IntentScoreBreakdown) _then) = _$IntentScoreBreakdownCopyWithImpl;
@useResult
$Res call({
 int intentScore, int naturalnessScore, int vocabularyScore
});




}
/// @nodoc
class _$IntentScoreBreakdownCopyWithImpl<$Res>
    implements $IntentScoreBreakdownCopyWith<$Res> {
  _$IntentScoreBreakdownCopyWithImpl(this._self, this._then);

  final IntentScoreBreakdown _self;
  final $Res Function(IntentScoreBreakdown) _then;

/// Create a copy of IntentScoreBreakdown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? intentScore = null,Object? naturalnessScore = null,Object? vocabularyScore = null,}) {
  return _then(_self.copyWith(
intentScore: null == intentScore ? _self.intentScore : intentScore // ignore: cast_nullable_to_non_nullable
as int,naturalnessScore: null == naturalnessScore ? _self.naturalnessScore : naturalnessScore // ignore: cast_nullable_to_non_nullable
as int,vocabularyScore: null == vocabularyScore ? _self.vocabularyScore : vocabularyScore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [IntentScoreBreakdown].
extension IntentScoreBreakdownPatterns on IntentScoreBreakdown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IntentScoreBreakdown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IntentScoreBreakdown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IntentScoreBreakdown value)  $default,){
final _that = this;
switch (_that) {
case _IntentScoreBreakdown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IntentScoreBreakdown value)?  $default,){
final _that = this;
switch (_that) {
case _IntentScoreBreakdown() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int intentScore,  int naturalnessScore,  int vocabularyScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IntentScoreBreakdown() when $default != null:
return $default(_that.intentScore,_that.naturalnessScore,_that.vocabularyScore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int intentScore,  int naturalnessScore,  int vocabularyScore)  $default,) {final _that = this;
switch (_that) {
case _IntentScoreBreakdown():
return $default(_that.intentScore,_that.naturalnessScore,_that.vocabularyScore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int intentScore,  int naturalnessScore,  int vocabularyScore)?  $default,) {final _that = this;
switch (_that) {
case _IntentScoreBreakdown() when $default != null:
return $default(_that.intentScore,_that.naturalnessScore,_that.vocabularyScore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IntentScoreBreakdown implements IntentScoreBreakdown {
  const _IntentScoreBreakdown({required this.intentScore, required this.naturalnessScore, required this.vocabularyScore});
  factory _IntentScoreBreakdown.fromJson(Map<String, dynamic> json) => _$IntentScoreBreakdownFromJson(json);

@override final  int intentScore;
@override final  int naturalnessScore;
@override final  int vocabularyScore;

/// Create a copy of IntentScoreBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IntentScoreBreakdownCopyWith<_IntentScoreBreakdown> get copyWith => __$IntentScoreBreakdownCopyWithImpl<_IntentScoreBreakdown>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IntentScoreBreakdownToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IntentScoreBreakdown&&(identical(other.intentScore, intentScore) || other.intentScore == intentScore)&&(identical(other.naturalnessScore, naturalnessScore) || other.naturalnessScore == naturalnessScore)&&(identical(other.vocabularyScore, vocabularyScore) || other.vocabularyScore == vocabularyScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,intentScore,naturalnessScore,vocabularyScore);

@override
String toString() {
  return 'IntentScoreBreakdown(intentScore: $intentScore, naturalnessScore: $naturalnessScore, vocabularyScore: $vocabularyScore)';
}


}

/// @nodoc
abstract mixin class _$IntentScoreBreakdownCopyWith<$Res> implements $IntentScoreBreakdownCopyWith<$Res> {
  factory _$IntentScoreBreakdownCopyWith(_IntentScoreBreakdown value, $Res Function(_IntentScoreBreakdown) _then) = __$IntentScoreBreakdownCopyWithImpl;
@override @useResult
$Res call({
 int intentScore, int naturalnessScore, int vocabularyScore
});




}
/// @nodoc
class __$IntentScoreBreakdownCopyWithImpl<$Res>
    implements _$IntentScoreBreakdownCopyWith<$Res> {
  __$IntentScoreBreakdownCopyWithImpl(this._self, this._then);

  final _IntentScoreBreakdown _self;
  final $Res Function(_IntentScoreBreakdown) _then;

/// Create a copy of IntentScoreBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? intentScore = null,Object? naturalnessScore = null,Object? vocabularyScore = null,}) {
  return _then(_IntentScoreBreakdown(
intentScore: null == intentScore ? _self.intentScore : intentScore // ignore: cast_nullable_to_non_nullable
as int,naturalnessScore: null == naturalnessScore ? _self.naturalnessScore : naturalnessScore // ignore: cast_nullable_to_non_nullable
as int,vocabularyScore: null == vocabularyScore ? _self.vocabularyScore : vocabularyScore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
