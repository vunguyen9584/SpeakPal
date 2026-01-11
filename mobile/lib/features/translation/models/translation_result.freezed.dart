// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'translation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TranslationResult {

 String get id; String get questionId; String get userAnswer; int get totalScore; ScoreBreakdown get breakdown; String get modelAnswer; List<String> get feedback; int get xpEarned; DateTime? get createdAt;
/// Create a copy of TranslationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranslationResultCopyWith<TranslationResult> get copyWith => _$TranslationResultCopyWithImpl<TranslationResult>(this as TranslationResult, _$identity);

  /// Serializes this TranslationResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranslationResult&&(identical(other.id, id) || other.id == id)&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.userAnswer, userAnswer) || other.userAnswer == userAnswer)&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore)&&(identical(other.breakdown, breakdown) || other.breakdown == breakdown)&&(identical(other.modelAnswer, modelAnswer) || other.modelAnswer == modelAnswer)&&const DeepCollectionEquality().equals(other.feedback, feedback)&&(identical(other.xpEarned, xpEarned) || other.xpEarned == xpEarned)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,questionId,userAnswer,totalScore,breakdown,modelAnswer,const DeepCollectionEquality().hash(feedback),xpEarned,createdAt);

@override
String toString() {
  return 'TranslationResult(id: $id, questionId: $questionId, userAnswer: $userAnswer, totalScore: $totalScore, breakdown: $breakdown, modelAnswer: $modelAnswer, feedback: $feedback, xpEarned: $xpEarned, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TranslationResultCopyWith<$Res>  {
  factory $TranslationResultCopyWith(TranslationResult value, $Res Function(TranslationResult) _then) = _$TranslationResultCopyWithImpl;
@useResult
$Res call({
 String id, String questionId, String userAnswer, int totalScore, ScoreBreakdown breakdown, String modelAnswer, List<String> feedback, int xpEarned, DateTime? createdAt
});


$ScoreBreakdownCopyWith<$Res> get breakdown;

}
/// @nodoc
class _$TranslationResultCopyWithImpl<$Res>
    implements $TranslationResultCopyWith<$Res> {
  _$TranslationResultCopyWithImpl(this._self, this._then);

  final TranslationResult _self;
  final $Res Function(TranslationResult) _then;

/// Create a copy of TranslationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? questionId = null,Object? userAnswer = null,Object? totalScore = null,Object? breakdown = null,Object? modelAnswer = null,Object? feedback = null,Object? xpEarned = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,userAnswer: null == userAnswer ? _self.userAnswer : userAnswer // ignore: cast_nullable_to_non_nullable
as String,totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as int,breakdown: null == breakdown ? _self.breakdown : breakdown // ignore: cast_nullable_to_non_nullable
as ScoreBreakdown,modelAnswer: null == modelAnswer ? _self.modelAnswer : modelAnswer // ignore: cast_nullable_to_non_nullable
as String,feedback: null == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as List<String>,xpEarned: null == xpEarned ? _self.xpEarned : xpEarned // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of TranslationResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoreBreakdownCopyWith<$Res> get breakdown {
  
  return $ScoreBreakdownCopyWith<$Res>(_self.breakdown, (value) {
    return _then(_self.copyWith(breakdown: value));
  });
}
}


/// Adds pattern-matching-related methods to [TranslationResult].
extension TranslationResultPatterns on TranslationResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranslationResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranslationResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranslationResult value)  $default,){
final _that = this;
switch (_that) {
case _TranslationResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranslationResult value)?  $default,){
final _that = this;
switch (_that) {
case _TranslationResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String questionId,  String userAnswer,  int totalScore,  ScoreBreakdown breakdown,  String modelAnswer,  List<String> feedback,  int xpEarned,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranslationResult() when $default != null:
return $default(_that.id,_that.questionId,_that.userAnswer,_that.totalScore,_that.breakdown,_that.modelAnswer,_that.feedback,_that.xpEarned,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String questionId,  String userAnswer,  int totalScore,  ScoreBreakdown breakdown,  String modelAnswer,  List<String> feedback,  int xpEarned,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _TranslationResult():
return $default(_that.id,_that.questionId,_that.userAnswer,_that.totalScore,_that.breakdown,_that.modelAnswer,_that.feedback,_that.xpEarned,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String questionId,  String userAnswer,  int totalScore,  ScoreBreakdown breakdown,  String modelAnswer,  List<String> feedback,  int xpEarned,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TranslationResult() when $default != null:
return $default(_that.id,_that.questionId,_that.userAnswer,_that.totalScore,_that.breakdown,_that.modelAnswer,_that.feedback,_that.xpEarned,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TranslationResult implements TranslationResult {
  const _TranslationResult({required this.id, required this.questionId, required this.userAnswer, required this.totalScore, required this.breakdown, required this.modelAnswer, required final  List<String> feedback, required this.xpEarned, this.createdAt}): _feedback = feedback;
  factory _TranslationResult.fromJson(Map<String, dynamic> json) => _$TranslationResultFromJson(json);

@override final  String id;
@override final  String questionId;
@override final  String userAnswer;
@override final  int totalScore;
@override final  ScoreBreakdown breakdown;
@override final  String modelAnswer;
 final  List<String> _feedback;
@override List<String> get feedback {
  if (_feedback is EqualUnmodifiableListView) return _feedback;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_feedback);
}

@override final  int xpEarned;
@override final  DateTime? createdAt;

/// Create a copy of TranslationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranslationResultCopyWith<_TranslationResult> get copyWith => __$TranslationResultCopyWithImpl<_TranslationResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TranslationResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranslationResult&&(identical(other.id, id) || other.id == id)&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.userAnswer, userAnswer) || other.userAnswer == userAnswer)&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore)&&(identical(other.breakdown, breakdown) || other.breakdown == breakdown)&&(identical(other.modelAnswer, modelAnswer) || other.modelAnswer == modelAnswer)&&const DeepCollectionEquality().equals(other._feedback, _feedback)&&(identical(other.xpEarned, xpEarned) || other.xpEarned == xpEarned)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,questionId,userAnswer,totalScore,breakdown,modelAnswer,const DeepCollectionEquality().hash(_feedback),xpEarned,createdAt);

@override
String toString() {
  return 'TranslationResult(id: $id, questionId: $questionId, userAnswer: $userAnswer, totalScore: $totalScore, breakdown: $breakdown, modelAnswer: $modelAnswer, feedback: $feedback, xpEarned: $xpEarned, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TranslationResultCopyWith<$Res> implements $TranslationResultCopyWith<$Res> {
  factory _$TranslationResultCopyWith(_TranslationResult value, $Res Function(_TranslationResult) _then) = __$TranslationResultCopyWithImpl;
@override @useResult
$Res call({
 String id, String questionId, String userAnswer, int totalScore, ScoreBreakdown breakdown, String modelAnswer, List<String> feedback, int xpEarned, DateTime? createdAt
});


@override $ScoreBreakdownCopyWith<$Res> get breakdown;

}
/// @nodoc
class __$TranslationResultCopyWithImpl<$Res>
    implements _$TranslationResultCopyWith<$Res> {
  __$TranslationResultCopyWithImpl(this._self, this._then);

  final _TranslationResult _self;
  final $Res Function(_TranslationResult) _then;

/// Create a copy of TranslationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? questionId = null,Object? userAnswer = null,Object? totalScore = null,Object? breakdown = null,Object? modelAnswer = null,Object? feedback = null,Object? xpEarned = null,Object? createdAt = freezed,}) {
  return _then(_TranslationResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,userAnswer: null == userAnswer ? _self.userAnswer : userAnswer // ignore: cast_nullable_to_non_nullable
as String,totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as int,breakdown: null == breakdown ? _self.breakdown : breakdown // ignore: cast_nullable_to_non_nullable
as ScoreBreakdown,modelAnswer: null == modelAnswer ? _self.modelAnswer : modelAnswer // ignore: cast_nullable_to_non_nullable
as String,feedback: null == feedback ? _self._feedback : feedback // ignore: cast_nullable_to_non_nullable
as List<String>,xpEarned: null == xpEarned ? _self.xpEarned : xpEarned // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of TranslationResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoreBreakdownCopyWith<$Res> get breakdown {
  
  return $ScoreBreakdownCopyWith<$Res>(_self.breakdown, (value) {
    return _then(_self.copyWith(breakdown: value));
  });
}
}


/// @nodoc
mixin _$ScoreBreakdown {

 int get grammarScore; int get vocabularyScore; int get speedScore;
/// Create a copy of ScoreBreakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScoreBreakdownCopyWith<ScoreBreakdown> get copyWith => _$ScoreBreakdownCopyWithImpl<ScoreBreakdown>(this as ScoreBreakdown, _$identity);

  /// Serializes this ScoreBreakdown to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScoreBreakdown&&(identical(other.grammarScore, grammarScore) || other.grammarScore == grammarScore)&&(identical(other.vocabularyScore, vocabularyScore) || other.vocabularyScore == vocabularyScore)&&(identical(other.speedScore, speedScore) || other.speedScore == speedScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,grammarScore,vocabularyScore,speedScore);

@override
String toString() {
  return 'ScoreBreakdown(grammarScore: $grammarScore, vocabularyScore: $vocabularyScore, speedScore: $speedScore)';
}


}

/// @nodoc
abstract mixin class $ScoreBreakdownCopyWith<$Res>  {
  factory $ScoreBreakdownCopyWith(ScoreBreakdown value, $Res Function(ScoreBreakdown) _then) = _$ScoreBreakdownCopyWithImpl;
@useResult
$Res call({
 int grammarScore, int vocabularyScore, int speedScore
});




}
/// @nodoc
class _$ScoreBreakdownCopyWithImpl<$Res>
    implements $ScoreBreakdownCopyWith<$Res> {
  _$ScoreBreakdownCopyWithImpl(this._self, this._then);

  final ScoreBreakdown _self;
  final $Res Function(ScoreBreakdown) _then;

/// Create a copy of ScoreBreakdown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? grammarScore = null,Object? vocabularyScore = null,Object? speedScore = null,}) {
  return _then(_self.copyWith(
grammarScore: null == grammarScore ? _self.grammarScore : grammarScore // ignore: cast_nullable_to_non_nullable
as int,vocabularyScore: null == vocabularyScore ? _self.vocabularyScore : vocabularyScore // ignore: cast_nullable_to_non_nullable
as int,speedScore: null == speedScore ? _self.speedScore : speedScore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ScoreBreakdown].
extension ScoreBreakdownPatterns on ScoreBreakdown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScoreBreakdown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScoreBreakdown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScoreBreakdown value)  $default,){
final _that = this;
switch (_that) {
case _ScoreBreakdown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScoreBreakdown value)?  $default,){
final _that = this;
switch (_that) {
case _ScoreBreakdown() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int grammarScore,  int vocabularyScore,  int speedScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScoreBreakdown() when $default != null:
return $default(_that.grammarScore,_that.vocabularyScore,_that.speedScore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int grammarScore,  int vocabularyScore,  int speedScore)  $default,) {final _that = this;
switch (_that) {
case _ScoreBreakdown():
return $default(_that.grammarScore,_that.vocabularyScore,_that.speedScore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int grammarScore,  int vocabularyScore,  int speedScore)?  $default,) {final _that = this;
switch (_that) {
case _ScoreBreakdown() when $default != null:
return $default(_that.grammarScore,_that.vocabularyScore,_that.speedScore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScoreBreakdown implements ScoreBreakdown {
  const _ScoreBreakdown({required this.grammarScore, required this.vocabularyScore, required this.speedScore});
  factory _ScoreBreakdown.fromJson(Map<String, dynamic> json) => _$ScoreBreakdownFromJson(json);

@override final  int grammarScore;
@override final  int vocabularyScore;
@override final  int speedScore;

/// Create a copy of ScoreBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScoreBreakdownCopyWith<_ScoreBreakdown> get copyWith => __$ScoreBreakdownCopyWithImpl<_ScoreBreakdown>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScoreBreakdownToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScoreBreakdown&&(identical(other.grammarScore, grammarScore) || other.grammarScore == grammarScore)&&(identical(other.vocabularyScore, vocabularyScore) || other.vocabularyScore == vocabularyScore)&&(identical(other.speedScore, speedScore) || other.speedScore == speedScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,grammarScore,vocabularyScore,speedScore);

@override
String toString() {
  return 'ScoreBreakdown(grammarScore: $grammarScore, vocabularyScore: $vocabularyScore, speedScore: $speedScore)';
}


}

/// @nodoc
abstract mixin class _$ScoreBreakdownCopyWith<$Res> implements $ScoreBreakdownCopyWith<$Res> {
  factory _$ScoreBreakdownCopyWith(_ScoreBreakdown value, $Res Function(_ScoreBreakdown) _then) = __$ScoreBreakdownCopyWithImpl;
@override @useResult
$Res call({
 int grammarScore, int vocabularyScore, int speedScore
});




}
/// @nodoc
class __$ScoreBreakdownCopyWithImpl<$Res>
    implements _$ScoreBreakdownCopyWith<$Res> {
  __$ScoreBreakdownCopyWithImpl(this._self, this._then);

  final _ScoreBreakdown _self;
  final $Res Function(_ScoreBreakdown) _then;

/// Create a copy of ScoreBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? grammarScore = null,Object? vocabularyScore = null,Object? speedScore = null,}) {
  return _then(_ScoreBreakdown(
grammarScore: null == grammarScore ? _self.grammarScore : grammarScore // ignore: cast_nullable_to_non_nullable
as int,vocabularyScore: null == vocabularyScore ? _self.vocabularyScore : vocabularyScore // ignore: cast_nullable_to_non_nullable
as int,speedScore: null == speedScore ? _self.speedScore : speedScore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
