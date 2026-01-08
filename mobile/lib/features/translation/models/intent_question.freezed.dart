// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'intent_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IntentQuestion {

 String get id; String get situation; String get intent; String get category; String get difficulty; String? get hint; List<String>? get expectedExpressions;
/// Create a copy of IntentQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IntentQuestionCopyWith<IntentQuestion> get copyWith => _$IntentQuestionCopyWithImpl<IntentQuestion>(this as IntentQuestion, _$identity);

  /// Serializes this IntentQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IntentQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.situation, situation) || other.situation == situation)&&(identical(other.intent, intent) || other.intent == intent)&&(identical(other.category, category) || other.category == category)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.hint, hint) || other.hint == hint)&&const DeepCollectionEquality().equals(other.expectedExpressions, expectedExpressions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,situation,intent,category,difficulty,hint,const DeepCollectionEquality().hash(expectedExpressions));

@override
String toString() {
  return 'IntentQuestion(id: $id, situation: $situation, intent: $intent, category: $category, difficulty: $difficulty, hint: $hint, expectedExpressions: $expectedExpressions)';
}


}

/// @nodoc
abstract mixin class $IntentQuestionCopyWith<$Res>  {
  factory $IntentQuestionCopyWith(IntentQuestion value, $Res Function(IntentQuestion) _then) = _$IntentQuestionCopyWithImpl;
@useResult
$Res call({
 String id, String situation, String intent, String category, String difficulty, String? hint, List<String>? expectedExpressions
});




}
/// @nodoc
class _$IntentQuestionCopyWithImpl<$Res>
    implements $IntentQuestionCopyWith<$Res> {
  _$IntentQuestionCopyWithImpl(this._self, this._then);

  final IntentQuestion _self;
  final $Res Function(IntentQuestion) _then;

/// Create a copy of IntentQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? situation = null,Object? intent = null,Object? category = null,Object? difficulty = null,Object? hint = freezed,Object? expectedExpressions = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,situation: null == situation ? _self.situation : situation // ignore: cast_nullable_to_non_nullable
as String,intent: null == intent ? _self.intent : intent // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,hint: freezed == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String?,expectedExpressions: freezed == expectedExpressions ? _self.expectedExpressions : expectedExpressions // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [IntentQuestion].
extension IntentQuestionPatterns on IntentQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IntentQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IntentQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IntentQuestion value)  $default,){
final _that = this;
switch (_that) {
case _IntentQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IntentQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _IntentQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String situation,  String intent,  String category,  String difficulty,  String? hint,  List<String>? expectedExpressions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IntentQuestion() when $default != null:
return $default(_that.id,_that.situation,_that.intent,_that.category,_that.difficulty,_that.hint,_that.expectedExpressions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String situation,  String intent,  String category,  String difficulty,  String? hint,  List<String>? expectedExpressions)  $default,) {final _that = this;
switch (_that) {
case _IntentQuestion():
return $default(_that.id,_that.situation,_that.intent,_that.category,_that.difficulty,_that.hint,_that.expectedExpressions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String situation,  String intent,  String category,  String difficulty,  String? hint,  List<String>? expectedExpressions)?  $default,) {final _that = this;
switch (_that) {
case _IntentQuestion() when $default != null:
return $default(_that.id,_that.situation,_that.intent,_that.category,_that.difficulty,_that.hint,_that.expectedExpressions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IntentQuestion implements IntentQuestion {
  const _IntentQuestion({required this.id, required this.situation, required this.intent, required this.category, required this.difficulty, this.hint, final  List<String>? expectedExpressions}): _expectedExpressions = expectedExpressions;
  factory _IntentQuestion.fromJson(Map<String, dynamic> json) => _$IntentQuestionFromJson(json);

@override final  String id;
@override final  String situation;
@override final  String intent;
@override final  String category;
@override final  String difficulty;
@override final  String? hint;
 final  List<String>? _expectedExpressions;
@override List<String>? get expectedExpressions {
  final value = _expectedExpressions;
  if (value == null) return null;
  if (_expectedExpressions is EqualUnmodifiableListView) return _expectedExpressions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of IntentQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IntentQuestionCopyWith<_IntentQuestion> get copyWith => __$IntentQuestionCopyWithImpl<_IntentQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IntentQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IntentQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.situation, situation) || other.situation == situation)&&(identical(other.intent, intent) || other.intent == intent)&&(identical(other.category, category) || other.category == category)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.hint, hint) || other.hint == hint)&&const DeepCollectionEquality().equals(other._expectedExpressions, _expectedExpressions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,situation,intent,category,difficulty,hint,const DeepCollectionEquality().hash(_expectedExpressions));

@override
String toString() {
  return 'IntentQuestion(id: $id, situation: $situation, intent: $intent, category: $category, difficulty: $difficulty, hint: $hint, expectedExpressions: $expectedExpressions)';
}


}

/// @nodoc
abstract mixin class _$IntentQuestionCopyWith<$Res> implements $IntentQuestionCopyWith<$Res> {
  factory _$IntentQuestionCopyWith(_IntentQuestion value, $Res Function(_IntentQuestion) _then) = __$IntentQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String situation, String intent, String category, String difficulty, String? hint, List<String>? expectedExpressions
});




}
/// @nodoc
class __$IntentQuestionCopyWithImpl<$Res>
    implements _$IntentQuestionCopyWith<$Res> {
  __$IntentQuestionCopyWithImpl(this._self, this._then);

  final _IntentQuestion _self;
  final $Res Function(_IntentQuestion) _then;

/// Create a copy of IntentQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? situation = null,Object? intent = null,Object? category = null,Object? difficulty = null,Object? hint = freezed,Object? expectedExpressions = freezed,}) {
  return _then(_IntentQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,situation: null == situation ? _self.situation : situation // ignore: cast_nullable_to_non_nullable
as String,intent: null == intent ? _self.intent : intent // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,hint: freezed == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String?,expectedExpressions: freezed == expectedExpressions ? _self._expectedExpressions : expectedExpressions // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
