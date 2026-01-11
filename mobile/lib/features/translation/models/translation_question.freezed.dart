// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'translation_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TranslationQuestion {

 String get id; String get sourceText; String get sourceLanguage; String get targetLanguage; String get topic; String get difficulty; List<String> get grammarPoints; String? get modelAnswer; Map<String, dynamic>? get metadata;
/// Create a copy of TranslationQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranslationQuestionCopyWith<TranslationQuestion> get copyWith => _$TranslationQuestionCopyWithImpl<TranslationQuestion>(this as TranslationQuestion, _$identity);

  /// Serializes this TranslationQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranslationQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceText, sourceText) || other.sourceText == sourceText)&&(identical(other.sourceLanguage, sourceLanguage) || other.sourceLanguage == sourceLanguage)&&(identical(other.targetLanguage, targetLanguage) || other.targetLanguage == targetLanguage)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other.grammarPoints, grammarPoints)&&(identical(other.modelAnswer, modelAnswer) || other.modelAnswer == modelAnswer)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceText,sourceLanguage,targetLanguage,topic,difficulty,const DeepCollectionEquality().hash(grammarPoints),modelAnswer,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'TranslationQuestion(id: $id, sourceText: $sourceText, sourceLanguage: $sourceLanguage, targetLanguage: $targetLanguage, topic: $topic, difficulty: $difficulty, grammarPoints: $grammarPoints, modelAnswer: $modelAnswer, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $TranslationQuestionCopyWith<$Res>  {
  factory $TranslationQuestionCopyWith(TranslationQuestion value, $Res Function(TranslationQuestion) _then) = _$TranslationQuestionCopyWithImpl;
@useResult
$Res call({
 String id, String sourceText, String sourceLanguage, String targetLanguage, String topic, String difficulty, List<String> grammarPoints, String? modelAnswer, Map<String, dynamic>? metadata
});




}
/// @nodoc
class _$TranslationQuestionCopyWithImpl<$Res>
    implements $TranslationQuestionCopyWith<$Res> {
  _$TranslationQuestionCopyWithImpl(this._self, this._then);

  final TranslationQuestion _self;
  final $Res Function(TranslationQuestion) _then;

/// Create a copy of TranslationQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceText = null,Object? sourceLanguage = null,Object? targetLanguage = null,Object? topic = null,Object? difficulty = null,Object? grammarPoints = null,Object? modelAnswer = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceText: null == sourceText ? _self.sourceText : sourceText // ignore: cast_nullable_to_non_nullable
as String,sourceLanguage: null == sourceLanguage ? _self.sourceLanguage : sourceLanguage // ignore: cast_nullable_to_non_nullable
as String,targetLanguage: null == targetLanguage ? _self.targetLanguage : targetLanguage // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,grammarPoints: null == grammarPoints ? _self.grammarPoints : grammarPoints // ignore: cast_nullable_to_non_nullable
as List<String>,modelAnswer: freezed == modelAnswer ? _self.modelAnswer : modelAnswer // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [TranslationQuestion].
extension TranslationQuestionPatterns on TranslationQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranslationQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranslationQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranslationQuestion value)  $default,){
final _that = this;
switch (_that) {
case _TranslationQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranslationQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _TranslationQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sourceText,  String sourceLanguage,  String targetLanguage,  String topic,  String difficulty,  List<String> grammarPoints,  String? modelAnswer,  Map<String, dynamic>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranslationQuestion() when $default != null:
return $default(_that.id,_that.sourceText,_that.sourceLanguage,_that.targetLanguage,_that.topic,_that.difficulty,_that.grammarPoints,_that.modelAnswer,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sourceText,  String sourceLanguage,  String targetLanguage,  String topic,  String difficulty,  List<String> grammarPoints,  String? modelAnswer,  Map<String, dynamic>? metadata)  $default,) {final _that = this;
switch (_that) {
case _TranslationQuestion():
return $default(_that.id,_that.sourceText,_that.sourceLanguage,_that.targetLanguage,_that.topic,_that.difficulty,_that.grammarPoints,_that.modelAnswer,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sourceText,  String sourceLanguage,  String targetLanguage,  String topic,  String difficulty,  List<String> grammarPoints,  String? modelAnswer,  Map<String, dynamic>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _TranslationQuestion() when $default != null:
return $default(_that.id,_that.sourceText,_that.sourceLanguage,_that.targetLanguage,_that.topic,_that.difficulty,_that.grammarPoints,_that.modelAnswer,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TranslationQuestion implements TranslationQuestion {
  const _TranslationQuestion({required this.id, required this.sourceText, required this.sourceLanguage, required this.targetLanguage, required this.topic, required this.difficulty, required final  List<String> grammarPoints, this.modelAnswer, final  Map<String, dynamic>? metadata}): _grammarPoints = grammarPoints,_metadata = metadata;
  factory _TranslationQuestion.fromJson(Map<String, dynamic> json) => _$TranslationQuestionFromJson(json);

@override final  String id;
@override final  String sourceText;
@override final  String sourceLanguage;
@override final  String targetLanguage;
@override final  String topic;
@override final  String difficulty;
 final  List<String> _grammarPoints;
@override List<String> get grammarPoints {
  if (_grammarPoints is EqualUnmodifiableListView) return _grammarPoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_grammarPoints);
}

@override final  String? modelAnswer;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of TranslationQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranslationQuestionCopyWith<_TranslationQuestion> get copyWith => __$TranslationQuestionCopyWithImpl<_TranslationQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TranslationQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranslationQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceText, sourceText) || other.sourceText == sourceText)&&(identical(other.sourceLanguage, sourceLanguage) || other.sourceLanguage == sourceLanguage)&&(identical(other.targetLanguage, targetLanguage) || other.targetLanguage == targetLanguage)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other._grammarPoints, _grammarPoints)&&(identical(other.modelAnswer, modelAnswer) || other.modelAnswer == modelAnswer)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceText,sourceLanguage,targetLanguage,topic,difficulty,const DeepCollectionEquality().hash(_grammarPoints),modelAnswer,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'TranslationQuestion(id: $id, sourceText: $sourceText, sourceLanguage: $sourceLanguage, targetLanguage: $targetLanguage, topic: $topic, difficulty: $difficulty, grammarPoints: $grammarPoints, modelAnswer: $modelAnswer, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$TranslationQuestionCopyWith<$Res> implements $TranslationQuestionCopyWith<$Res> {
  factory _$TranslationQuestionCopyWith(_TranslationQuestion value, $Res Function(_TranslationQuestion) _then) = __$TranslationQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String sourceText, String sourceLanguage, String targetLanguage, String topic, String difficulty, List<String> grammarPoints, String? modelAnswer, Map<String, dynamic>? metadata
});




}
/// @nodoc
class __$TranslationQuestionCopyWithImpl<$Res>
    implements _$TranslationQuestionCopyWith<$Res> {
  __$TranslationQuestionCopyWithImpl(this._self, this._then);

  final _TranslationQuestion _self;
  final $Res Function(_TranslationQuestion) _then;

/// Create a copy of TranslationQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceText = null,Object? sourceLanguage = null,Object? targetLanguage = null,Object? topic = null,Object? difficulty = null,Object? grammarPoints = null,Object? modelAnswer = freezed,Object? metadata = freezed,}) {
  return _then(_TranslationQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceText: null == sourceText ? _self.sourceText : sourceText // ignore: cast_nullable_to_non_nullable
as String,sourceLanguage: null == sourceLanguage ? _self.sourceLanguage : sourceLanguage // ignore: cast_nullable_to_non_nullable
as String,targetLanguage: null == targetLanguage ? _self.targetLanguage : targetLanguage // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,grammarPoints: null == grammarPoints ? _self._grammarPoints : grammarPoints // ignore: cast_nullable_to_non_nullable
as List<String>,modelAnswer: freezed == modelAnswer ? _self.modelAnswer : modelAnswer // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
