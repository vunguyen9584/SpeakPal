// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_response_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WordAssociationSession {

 String get id; String get currentKeyword; int get score; int get chain; int get timeRemaining; String? get previousKeyword;
/// Create a copy of WordAssociationSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WordAssociationSessionCopyWith<WordAssociationSession> get copyWith => _$WordAssociationSessionCopyWithImpl<WordAssociationSession>(this as WordAssociationSession, _$identity);

  /// Serializes this WordAssociationSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WordAssociationSession&&(identical(other.id, id) || other.id == id)&&(identical(other.currentKeyword, currentKeyword) || other.currentKeyword == currentKeyword)&&(identical(other.score, score) || other.score == score)&&(identical(other.chain, chain) || other.chain == chain)&&(identical(other.timeRemaining, timeRemaining) || other.timeRemaining == timeRemaining)&&(identical(other.previousKeyword, previousKeyword) || other.previousKeyword == previousKeyword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,currentKeyword,score,chain,timeRemaining,previousKeyword);

@override
String toString() {
  return 'WordAssociationSession(id: $id, currentKeyword: $currentKeyword, score: $score, chain: $chain, timeRemaining: $timeRemaining, previousKeyword: $previousKeyword)';
}


}

/// @nodoc
abstract mixin class $WordAssociationSessionCopyWith<$Res>  {
  factory $WordAssociationSessionCopyWith(WordAssociationSession value, $Res Function(WordAssociationSession) _then) = _$WordAssociationSessionCopyWithImpl;
@useResult
$Res call({
 String id, String currentKeyword, int score, int chain, int timeRemaining, String? previousKeyword
});




}
/// @nodoc
class _$WordAssociationSessionCopyWithImpl<$Res>
    implements $WordAssociationSessionCopyWith<$Res> {
  _$WordAssociationSessionCopyWithImpl(this._self, this._then);

  final WordAssociationSession _self;
  final $Res Function(WordAssociationSession) _then;

/// Create a copy of WordAssociationSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? currentKeyword = null,Object? score = null,Object? chain = null,Object? timeRemaining = null,Object? previousKeyword = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,currentKeyword: null == currentKeyword ? _self.currentKeyword : currentKeyword // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,chain: null == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as int,timeRemaining: null == timeRemaining ? _self.timeRemaining : timeRemaining // ignore: cast_nullable_to_non_nullable
as int,previousKeyword: freezed == previousKeyword ? _self.previousKeyword : previousKeyword // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WordAssociationSession].
extension WordAssociationSessionPatterns on WordAssociationSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WordAssociationSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WordAssociationSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WordAssociationSession value)  $default,){
final _that = this;
switch (_that) {
case _WordAssociationSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WordAssociationSession value)?  $default,){
final _that = this;
switch (_that) {
case _WordAssociationSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String currentKeyword,  int score,  int chain,  int timeRemaining,  String? previousKeyword)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WordAssociationSession() when $default != null:
return $default(_that.id,_that.currentKeyword,_that.score,_that.chain,_that.timeRemaining,_that.previousKeyword);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String currentKeyword,  int score,  int chain,  int timeRemaining,  String? previousKeyword)  $default,) {final _that = this;
switch (_that) {
case _WordAssociationSession():
return $default(_that.id,_that.currentKeyword,_that.score,_that.chain,_that.timeRemaining,_that.previousKeyword);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String currentKeyword,  int score,  int chain,  int timeRemaining,  String? previousKeyword)?  $default,) {final _that = this;
switch (_that) {
case _WordAssociationSession() when $default != null:
return $default(_that.id,_that.currentKeyword,_that.score,_that.chain,_that.timeRemaining,_that.previousKeyword);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WordAssociationSession implements WordAssociationSession {
  const _WordAssociationSession({required this.id, required this.currentKeyword, required this.score, required this.chain, required this.timeRemaining, this.previousKeyword});
  factory _WordAssociationSession.fromJson(Map<String, dynamic> json) => _$WordAssociationSessionFromJson(json);

@override final  String id;
@override final  String currentKeyword;
@override final  int score;
@override final  int chain;
@override final  int timeRemaining;
@override final  String? previousKeyword;

/// Create a copy of WordAssociationSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WordAssociationSessionCopyWith<_WordAssociationSession> get copyWith => __$WordAssociationSessionCopyWithImpl<_WordAssociationSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WordAssociationSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WordAssociationSession&&(identical(other.id, id) || other.id == id)&&(identical(other.currentKeyword, currentKeyword) || other.currentKeyword == currentKeyword)&&(identical(other.score, score) || other.score == score)&&(identical(other.chain, chain) || other.chain == chain)&&(identical(other.timeRemaining, timeRemaining) || other.timeRemaining == timeRemaining)&&(identical(other.previousKeyword, previousKeyword) || other.previousKeyword == previousKeyword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,currentKeyword,score,chain,timeRemaining,previousKeyword);

@override
String toString() {
  return 'WordAssociationSession(id: $id, currentKeyword: $currentKeyword, score: $score, chain: $chain, timeRemaining: $timeRemaining, previousKeyword: $previousKeyword)';
}


}

/// @nodoc
abstract mixin class _$WordAssociationSessionCopyWith<$Res> implements $WordAssociationSessionCopyWith<$Res> {
  factory _$WordAssociationSessionCopyWith(_WordAssociationSession value, $Res Function(_WordAssociationSession) _then) = __$WordAssociationSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String currentKeyword, int score, int chain, int timeRemaining, String? previousKeyword
});




}
/// @nodoc
class __$WordAssociationSessionCopyWithImpl<$Res>
    implements _$WordAssociationSessionCopyWith<$Res> {
  __$WordAssociationSessionCopyWithImpl(this._self, this._then);

  final _WordAssociationSession _self;
  final $Res Function(_WordAssociationSession) _then;

/// Create a copy of WordAssociationSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? currentKeyword = null,Object? score = null,Object? chain = null,Object? timeRemaining = null,Object? previousKeyword = freezed,}) {
  return _then(_WordAssociationSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,currentKeyword: null == currentKeyword ? _self.currentKeyword : currentKeyword // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,chain: null == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as int,timeRemaining: null == timeRemaining ? _self.timeRemaining : timeRemaining // ignore: cast_nullable_to_non_nullable
as int,previousKeyword: freezed == previousKeyword ? _self.previousKeyword : previousKeyword // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$InstantDrillSession {

 String get id; List<DrillQuestion> get questions; int get currentQuestionIndex; int get totalScore;
/// Create a copy of InstantDrillSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstantDrillSessionCopyWith<InstantDrillSession> get copyWith => _$InstantDrillSessionCopyWithImpl<InstantDrillSession>(this as InstantDrillSession, _$identity);

  /// Serializes this InstantDrillSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstantDrillSession&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.questions, questions)&&(identical(other.currentQuestionIndex, currentQuestionIndex) || other.currentQuestionIndex == currentQuestionIndex)&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(questions),currentQuestionIndex,totalScore);

@override
String toString() {
  return 'InstantDrillSession(id: $id, questions: $questions, currentQuestionIndex: $currentQuestionIndex, totalScore: $totalScore)';
}


}

/// @nodoc
abstract mixin class $InstantDrillSessionCopyWith<$Res>  {
  factory $InstantDrillSessionCopyWith(InstantDrillSession value, $Res Function(InstantDrillSession) _then) = _$InstantDrillSessionCopyWithImpl;
@useResult
$Res call({
 String id, List<DrillQuestion> questions, int currentQuestionIndex, int totalScore
});




}
/// @nodoc
class _$InstantDrillSessionCopyWithImpl<$Res>
    implements $InstantDrillSessionCopyWith<$Res> {
  _$InstantDrillSessionCopyWithImpl(this._self, this._then);

  final InstantDrillSession _self;
  final $Res Function(InstantDrillSession) _then;

/// Create a copy of InstantDrillSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? questions = null,Object? currentQuestionIndex = null,Object? totalScore = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<DrillQuestion>,currentQuestionIndex: null == currentQuestionIndex ? _self.currentQuestionIndex : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
as int,totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [InstantDrillSession].
extension InstantDrillSessionPatterns on InstantDrillSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstantDrillSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstantDrillSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstantDrillSession value)  $default,){
final _that = this;
switch (_that) {
case _InstantDrillSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstantDrillSession value)?  $default,){
final _that = this;
switch (_that) {
case _InstantDrillSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<DrillQuestion> questions,  int currentQuestionIndex,  int totalScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstantDrillSession() when $default != null:
return $default(_that.id,_that.questions,_that.currentQuestionIndex,_that.totalScore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<DrillQuestion> questions,  int currentQuestionIndex,  int totalScore)  $default,) {final _that = this;
switch (_that) {
case _InstantDrillSession():
return $default(_that.id,_that.questions,_that.currentQuestionIndex,_that.totalScore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<DrillQuestion> questions,  int currentQuestionIndex,  int totalScore)?  $default,) {final _that = this;
switch (_that) {
case _InstantDrillSession() when $default != null:
return $default(_that.id,_that.questions,_that.currentQuestionIndex,_that.totalScore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InstantDrillSession implements InstantDrillSession {
  const _InstantDrillSession({required this.id, required final  List<DrillQuestion> questions, required this.currentQuestionIndex, required this.totalScore}): _questions = questions;
  factory _InstantDrillSession.fromJson(Map<String, dynamic> json) => _$InstantDrillSessionFromJson(json);

@override final  String id;
 final  List<DrillQuestion> _questions;
@override List<DrillQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}

@override final  int currentQuestionIndex;
@override final  int totalScore;

/// Create a copy of InstantDrillSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstantDrillSessionCopyWith<_InstantDrillSession> get copyWith => __$InstantDrillSessionCopyWithImpl<_InstantDrillSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InstantDrillSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstantDrillSession&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._questions, _questions)&&(identical(other.currentQuestionIndex, currentQuestionIndex) || other.currentQuestionIndex == currentQuestionIndex)&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_questions),currentQuestionIndex,totalScore);

@override
String toString() {
  return 'InstantDrillSession(id: $id, questions: $questions, currentQuestionIndex: $currentQuestionIndex, totalScore: $totalScore)';
}


}

/// @nodoc
abstract mixin class _$InstantDrillSessionCopyWith<$Res> implements $InstantDrillSessionCopyWith<$Res> {
  factory _$InstantDrillSessionCopyWith(_InstantDrillSession value, $Res Function(_InstantDrillSession) _then) = __$InstantDrillSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, List<DrillQuestion> questions, int currentQuestionIndex, int totalScore
});




}
/// @nodoc
class __$InstantDrillSessionCopyWithImpl<$Res>
    implements _$InstantDrillSessionCopyWith<$Res> {
  __$InstantDrillSessionCopyWithImpl(this._self, this._then);

  final _InstantDrillSession _self;
  final $Res Function(_InstantDrillSession) _then;

/// Create a copy of InstantDrillSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? questions = null,Object? currentQuestionIndex = null,Object? totalScore = null,}) {
  return _then(_InstantDrillSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<DrillQuestion>,currentQuestionIndex: null == currentQuestionIndex ? _self.currentQuestionIndex : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
as int,totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DrillQuestion {

 String get id; String get questionText; String get audioUrl;
/// Create a copy of DrillQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrillQuestionCopyWith<DrillQuestion> get copyWith => _$DrillQuestionCopyWithImpl<DrillQuestion>(this as DrillQuestion, _$identity);

  /// Serializes this DrillQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrillQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,questionText,audioUrl);

@override
String toString() {
  return 'DrillQuestion(id: $id, questionText: $questionText, audioUrl: $audioUrl)';
}


}

/// @nodoc
abstract mixin class $DrillQuestionCopyWith<$Res>  {
  factory $DrillQuestionCopyWith(DrillQuestion value, $Res Function(DrillQuestion) _then) = _$DrillQuestionCopyWithImpl;
@useResult
$Res call({
 String id, String questionText, String audioUrl
});




}
/// @nodoc
class _$DrillQuestionCopyWithImpl<$Res>
    implements $DrillQuestionCopyWith<$Res> {
  _$DrillQuestionCopyWithImpl(this._self, this._then);

  final DrillQuestion _self;
  final $Res Function(DrillQuestion) _then;

/// Create a copy of DrillQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? questionText = null,Object? audioUrl = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,questionText: null == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DrillQuestion].
extension DrillQuestionPatterns on DrillQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrillQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrillQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrillQuestion value)  $default,){
final _that = this;
switch (_that) {
case _DrillQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrillQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _DrillQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String questionText,  String audioUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrillQuestion() when $default != null:
return $default(_that.id,_that.questionText,_that.audioUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String questionText,  String audioUrl)  $default,) {final _that = this;
switch (_that) {
case _DrillQuestion():
return $default(_that.id,_that.questionText,_that.audioUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String questionText,  String audioUrl)?  $default,) {final _that = this;
switch (_that) {
case _DrillQuestion() when $default != null:
return $default(_that.id,_that.questionText,_that.audioUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DrillQuestion implements DrillQuestion {
  const _DrillQuestion({required this.id, required this.questionText, required this.audioUrl});
  factory _DrillQuestion.fromJson(Map<String, dynamic> json) => _$DrillQuestionFromJson(json);

@override final  String id;
@override final  String questionText;
@override final  String audioUrl;

/// Create a copy of DrillQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrillQuestionCopyWith<_DrillQuestion> get copyWith => __$DrillQuestionCopyWithImpl<_DrillQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrillQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrillQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,questionText,audioUrl);

@override
String toString() {
  return 'DrillQuestion(id: $id, questionText: $questionText, audioUrl: $audioUrl)';
}


}

/// @nodoc
abstract mixin class _$DrillQuestionCopyWith<$Res> implements $DrillQuestionCopyWith<$Res> {
  factory _$DrillQuestionCopyWith(_DrillQuestion value, $Res Function(_DrillQuestion) _then) = __$DrillQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String questionText, String audioUrl
});




}
/// @nodoc
class __$DrillQuestionCopyWithImpl<$Res>
    implements _$DrillQuestionCopyWith<$Res> {
  __$DrillQuestionCopyWithImpl(this._self, this._then);

  final _DrillQuestion _self;
  final $Res Function(_DrillQuestion) _then;

/// Create a copy of DrillQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? questionText = null,Object? audioUrl = null,}) {
  return _then(_DrillQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,questionText: null == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$QuickResponseResult {

 int get finalScore; int get correctCount; int get maxChain; int get xpEarned; bool? get isNewRecord;
/// Create a copy of QuickResponseResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickResponseResultCopyWith<QuickResponseResult> get copyWith => _$QuickResponseResultCopyWithImpl<QuickResponseResult>(this as QuickResponseResult, _$identity);

  /// Serializes this QuickResponseResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickResponseResult&&(identical(other.finalScore, finalScore) || other.finalScore == finalScore)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.maxChain, maxChain) || other.maxChain == maxChain)&&(identical(other.xpEarned, xpEarned) || other.xpEarned == xpEarned)&&(identical(other.isNewRecord, isNewRecord) || other.isNewRecord == isNewRecord));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,finalScore,correctCount,maxChain,xpEarned,isNewRecord);

@override
String toString() {
  return 'QuickResponseResult(finalScore: $finalScore, correctCount: $correctCount, maxChain: $maxChain, xpEarned: $xpEarned, isNewRecord: $isNewRecord)';
}


}

/// @nodoc
abstract mixin class $QuickResponseResultCopyWith<$Res>  {
  factory $QuickResponseResultCopyWith(QuickResponseResult value, $Res Function(QuickResponseResult) _then) = _$QuickResponseResultCopyWithImpl;
@useResult
$Res call({
 int finalScore, int correctCount, int maxChain, int xpEarned, bool? isNewRecord
});




}
/// @nodoc
class _$QuickResponseResultCopyWithImpl<$Res>
    implements $QuickResponseResultCopyWith<$Res> {
  _$QuickResponseResultCopyWithImpl(this._self, this._then);

  final QuickResponseResult _self;
  final $Res Function(QuickResponseResult) _then;

/// Create a copy of QuickResponseResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? finalScore = null,Object? correctCount = null,Object? maxChain = null,Object? xpEarned = null,Object? isNewRecord = freezed,}) {
  return _then(_self.copyWith(
finalScore: null == finalScore ? _self.finalScore : finalScore // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,maxChain: null == maxChain ? _self.maxChain : maxChain // ignore: cast_nullable_to_non_nullable
as int,xpEarned: null == xpEarned ? _self.xpEarned : xpEarned // ignore: cast_nullable_to_non_nullable
as int,isNewRecord: freezed == isNewRecord ? _self.isNewRecord : isNewRecord // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuickResponseResult].
extension QuickResponseResultPatterns on QuickResponseResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickResponseResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickResponseResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickResponseResult value)  $default,){
final _that = this;
switch (_that) {
case _QuickResponseResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickResponseResult value)?  $default,){
final _that = this;
switch (_that) {
case _QuickResponseResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int finalScore,  int correctCount,  int maxChain,  int xpEarned,  bool? isNewRecord)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickResponseResult() when $default != null:
return $default(_that.finalScore,_that.correctCount,_that.maxChain,_that.xpEarned,_that.isNewRecord);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int finalScore,  int correctCount,  int maxChain,  int xpEarned,  bool? isNewRecord)  $default,) {final _that = this;
switch (_that) {
case _QuickResponseResult():
return $default(_that.finalScore,_that.correctCount,_that.maxChain,_that.xpEarned,_that.isNewRecord);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int finalScore,  int correctCount,  int maxChain,  int xpEarned,  bool? isNewRecord)?  $default,) {final _that = this;
switch (_that) {
case _QuickResponseResult() when $default != null:
return $default(_that.finalScore,_that.correctCount,_that.maxChain,_that.xpEarned,_that.isNewRecord);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuickResponseResult implements QuickResponseResult {
  const _QuickResponseResult({required this.finalScore, required this.correctCount, required this.maxChain, required this.xpEarned, this.isNewRecord});
  factory _QuickResponseResult.fromJson(Map<String, dynamic> json) => _$QuickResponseResultFromJson(json);

@override final  int finalScore;
@override final  int correctCount;
@override final  int maxChain;
@override final  int xpEarned;
@override final  bool? isNewRecord;

/// Create a copy of QuickResponseResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickResponseResultCopyWith<_QuickResponseResult> get copyWith => __$QuickResponseResultCopyWithImpl<_QuickResponseResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuickResponseResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickResponseResult&&(identical(other.finalScore, finalScore) || other.finalScore == finalScore)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.maxChain, maxChain) || other.maxChain == maxChain)&&(identical(other.xpEarned, xpEarned) || other.xpEarned == xpEarned)&&(identical(other.isNewRecord, isNewRecord) || other.isNewRecord == isNewRecord));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,finalScore,correctCount,maxChain,xpEarned,isNewRecord);

@override
String toString() {
  return 'QuickResponseResult(finalScore: $finalScore, correctCount: $correctCount, maxChain: $maxChain, xpEarned: $xpEarned, isNewRecord: $isNewRecord)';
}


}

/// @nodoc
abstract mixin class _$QuickResponseResultCopyWith<$Res> implements $QuickResponseResultCopyWith<$Res> {
  factory _$QuickResponseResultCopyWith(_QuickResponseResult value, $Res Function(_QuickResponseResult) _then) = __$QuickResponseResultCopyWithImpl;
@override @useResult
$Res call({
 int finalScore, int correctCount, int maxChain, int xpEarned, bool? isNewRecord
});




}
/// @nodoc
class __$QuickResponseResultCopyWithImpl<$Res>
    implements _$QuickResponseResultCopyWith<$Res> {
  __$QuickResponseResultCopyWithImpl(this._self, this._then);

  final _QuickResponseResult _self;
  final $Res Function(_QuickResponseResult) _then;

/// Create a copy of QuickResponseResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? finalScore = null,Object? correctCount = null,Object? maxChain = null,Object? xpEarned = null,Object? isNewRecord = freezed,}) {
  return _then(_QuickResponseResult(
finalScore: null == finalScore ? _self.finalScore : finalScore // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,maxChain: null == maxChain ? _self.maxChain : maxChain // ignore: cast_nullable_to_non_nullable
as int,xpEarned: null == xpEarned ? _self.xpEarned : xpEarned // ignore: cast_nullable_to_non_nullable
as int,isNewRecord: freezed == isNewRecord ? _self.isNewRecord : isNewRecord // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on

