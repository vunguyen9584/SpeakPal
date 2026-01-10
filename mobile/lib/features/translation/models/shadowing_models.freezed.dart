// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shadowing_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShadowingContent {

 String get id; String get title; String get type; String get level; int get durationSeconds; String get audioUrl; String get transcript; String? get thumbnailUrl; bool get isPremium;
/// Create a copy of ShadowingContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShadowingContentCopyWith<ShadowingContent> get copyWith => _$ShadowingContentCopyWithImpl<ShadowingContent>(this as ShadowingContent, _$identity);

  /// Serializes this ShadowingContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShadowingContent&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.level, level) || other.level == level)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.transcript, transcript) || other.transcript == transcript)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,type,level,durationSeconds,audioUrl,transcript,thumbnailUrl,isPremium);

@override
String toString() {
  return 'ShadowingContent(id: $id, title: $title, type: $type, level: $level, durationSeconds: $durationSeconds, audioUrl: $audioUrl, transcript: $transcript, thumbnailUrl: $thumbnailUrl, isPremium: $isPremium)';
}


}

/// @nodoc
abstract mixin class $ShadowingContentCopyWith<$Res>  {
  factory $ShadowingContentCopyWith(ShadowingContent value, $Res Function(ShadowingContent) _then) = _$ShadowingContentCopyWithImpl;
@useResult
$Res call({
 String id, String title, String type, String level, int durationSeconds, String audioUrl, String transcript, String? thumbnailUrl, bool isPremium
});




}
/// @nodoc
class _$ShadowingContentCopyWithImpl<$Res>
    implements $ShadowingContentCopyWith<$Res> {
  _$ShadowingContentCopyWithImpl(this._self, this._then);

  final ShadowingContent _self;
  final $Res Function(ShadowingContent) _then;

/// Create a copy of ShadowingContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? type = null,Object? level = null,Object? durationSeconds = null,Object? audioUrl = null,Object? transcript = null,Object? thumbnailUrl = freezed,Object? isPremium = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ShadowingContent].
extension ShadowingContentPatterns on ShadowingContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShadowingContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShadowingContent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShadowingContent value)  $default,){
final _that = this;
switch (_that) {
case _ShadowingContent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShadowingContent value)?  $default,){
final _that = this;
switch (_that) {
case _ShadowingContent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String type,  String level,  int durationSeconds,  String audioUrl,  String transcript,  String? thumbnailUrl,  bool isPremium)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShadowingContent() when $default != null:
return $default(_that.id,_that.title,_that.type,_that.level,_that.durationSeconds,_that.audioUrl,_that.transcript,_that.thumbnailUrl,_that.isPremium);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String type,  String level,  int durationSeconds,  String audioUrl,  String transcript,  String? thumbnailUrl,  bool isPremium)  $default,) {final _that = this;
switch (_that) {
case _ShadowingContent():
return $default(_that.id,_that.title,_that.type,_that.level,_that.durationSeconds,_that.audioUrl,_that.transcript,_that.thumbnailUrl,_that.isPremium);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String type,  String level,  int durationSeconds,  String audioUrl,  String transcript,  String? thumbnailUrl,  bool isPremium)?  $default,) {final _that = this;
switch (_that) {
case _ShadowingContent() when $default != null:
return $default(_that.id,_that.title,_that.type,_that.level,_that.durationSeconds,_that.audioUrl,_that.transcript,_that.thumbnailUrl,_that.isPremium);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShadowingContent implements ShadowingContent {
  const _ShadowingContent({required this.id, required this.title, required this.type, required this.level, required this.durationSeconds, required this.audioUrl, required this.transcript, this.thumbnailUrl, required this.isPremium});
  factory _ShadowingContent.fromJson(Map<String, dynamic> json) => _$ShadowingContentFromJson(json);

@override final  String id;
@override final  String title;
@override final  String type;
@override final  String level;
@override final  int durationSeconds;
@override final  String audioUrl;
@override final  String transcript;
@override final  String? thumbnailUrl;
@override final  bool isPremium;

/// Create a copy of ShadowingContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShadowingContentCopyWith<_ShadowingContent> get copyWith => __$ShadowingContentCopyWithImpl<_ShadowingContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShadowingContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShadowingContent&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.level, level) || other.level == level)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.transcript, transcript) || other.transcript == transcript)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,type,level,durationSeconds,audioUrl,transcript,thumbnailUrl,isPremium);

@override
String toString() {
  return 'ShadowingContent(id: $id, title: $title, type: $type, level: $level, durationSeconds: $durationSeconds, audioUrl: $audioUrl, transcript: $transcript, thumbnailUrl: $thumbnailUrl, isPremium: $isPremium)';
}


}

/// @nodoc
abstract mixin class _$ShadowingContentCopyWith<$Res> implements $ShadowingContentCopyWith<$Res> {
  factory _$ShadowingContentCopyWith(_ShadowingContent value, $Res Function(_ShadowingContent) _then) = __$ShadowingContentCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String type, String level, int durationSeconds, String audioUrl, String transcript, String? thumbnailUrl, bool isPremium
});




}
/// @nodoc
class __$ShadowingContentCopyWithImpl<$Res>
    implements _$ShadowingContentCopyWith<$Res> {
  __$ShadowingContentCopyWithImpl(this._self, this._then);

  final _ShadowingContent _self;
  final $Res Function(_ShadowingContent) _then;

/// Create a copy of ShadowingContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? type = null,Object? level = null,Object? durationSeconds = null,Object? audioUrl = null,Object? transcript = null,Object? thumbnailUrl = freezed,Object? isPremium = null,}) {
  return _then(_ShadowingContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ShadowingResult {

 String get id; int get overallScore; ShadowingScoreBreakdown get breakdown; List<WeakSegment> get weakSegments; List<String> get feedback; int get xpEarned;
/// Create a copy of ShadowingResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShadowingResultCopyWith<ShadowingResult> get copyWith => _$ShadowingResultCopyWithImpl<ShadowingResult>(this as ShadowingResult, _$identity);

  /// Serializes this ShadowingResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShadowingResult&&(identical(other.id, id) || other.id == id)&&(identical(other.overallScore, overallScore) || other.overallScore == overallScore)&&(identical(other.breakdown, breakdown) || other.breakdown == breakdown)&&const DeepCollectionEquality().equals(other.weakSegments, weakSegments)&&const DeepCollectionEquality().equals(other.feedback, feedback)&&(identical(other.xpEarned, xpEarned) || other.xpEarned == xpEarned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,overallScore,breakdown,const DeepCollectionEquality().hash(weakSegments),const DeepCollectionEquality().hash(feedback),xpEarned);

@override
String toString() {
  return 'ShadowingResult(id: $id, overallScore: $overallScore, breakdown: $breakdown, weakSegments: $weakSegments, feedback: $feedback, xpEarned: $xpEarned)';
}


}

/// @nodoc
abstract mixin class $ShadowingResultCopyWith<$Res>  {
  factory $ShadowingResultCopyWith(ShadowingResult value, $Res Function(ShadowingResult) _then) = _$ShadowingResultCopyWithImpl;
@useResult
$Res call({
 String id, int overallScore, ShadowingScoreBreakdown breakdown, List<WeakSegment> weakSegments, List<String> feedback, int xpEarned
});


$ShadowingScoreBreakdownCopyWith<$Res> get breakdown;

}
/// @nodoc
class _$ShadowingResultCopyWithImpl<$Res>
    implements $ShadowingResultCopyWith<$Res> {
  _$ShadowingResultCopyWithImpl(this._self, this._then);

  final ShadowingResult _self;
  final $Res Function(ShadowingResult) _then;

/// Create a copy of ShadowingResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? overallScore = null,Object? breakdown = null,Object? weakSegments = null,Object? feedback = null,Object? xpEarned = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,overallScore: null == overallScore ? _self.overallScore : overallScore // ignore: cast_nullable_to_non_nullable
as int,breakdown: null == breakdown ? _self.breakdown : breakdown // ignore: cast_nullable_to_non_nullable
as ShadowingScoreBreakdown,weakSegments: null == weakSegments ? _self.weakSegments : weakSegments // ignore: cast_nullable_to_non_nullable
as List<WeakSegment>,feedback: null == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as List<String>,xpEarned: null == xpEarned ? _self.xpEarned : xpEarned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ShadowingResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShadowingScoreBreakdownCopyWith<$Res> get breakdown {
  
  return $ShadowingScoreBreakdownCopyWith<$Res>(_self.breakdown, (value) {
    return _then(_self.copyWith(breakdown: value));
  });
}
}


/// Adds pattern-matching-related methods to [ShadowingResult].
extension ShadowingResultPatterns on ShadowingResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShadowingResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShadowingResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShadowingResult value)  $default,){
final _that = this;
switch (_that) {
case _ShadowingResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShadowingResult value)?  $default,){
final _that = this;
switch (_that) {
case _ShadowingResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int overallScore,  ShadowingScoreBreakdown breakdown,  List<WeakSegment> weakSegments,  List<String> feedback,  int xpEarned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShadowingResult() when $default != null:
return $default(_that.id,_that.overallScore,_that.breakdown,_that.weakSegments,_that.feedback,_that.xpEarned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int overallScore,  ShadowingScoreBreakdown breakdown,  List<WeakSegment> weakSegments,  List<String> feedback,  int xpEarned)  $default,) {final _that = this;
switch (_that) {
case _ShadowingResult():
return $default(_that.id,_that.overallScore,_that.breakdown,_that.weakSegments,_that.feedback,_that.xpEarned);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int overallScore,  ShadowingScoreBreakdown breakdown,  List<WeakSegment> weakSegments,  List<String> feedback,  int xpEarned)?  $default,) {final _that = this;
switch (_that) {
case _ShadowingResult() when $default != null:
return $default(_that.id,_that.overallScore,_that.breakdown,_that.weakSegments,_that.feedback,_that.xpEarned);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShadowingResult implements ShadowingResult {
  const _ShadowingResult({required this.id, required this.overallScore, required this.breakdown, required final  List<WeakSegment> weakSegments, required final  List<String> feedback, required this.xpEarned}): _weakSegments = weakSegments,_feedback = feedback;
  factory _ShadowingResult.fromJson(Map<String, dynamic> json) => _$ShadowingResultFromJson(json);

@override final  String id;
@override final  int overallScore;
@override final  ShadowingScoreBreakdown breakdown;
 final  List<WeakSegment> _weakSegments;
@override List<WeakSegment> get weakSegments {
  if (_weakSegments is EqualUnmodifiableListView) return _weakSegments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weakSegments);
}

 final  List<String> _feedback;
@override List<String> get feedback {
  if (_feedback is EqualUnmodifiableListView) return _feedback;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_feedback);
}

@override final  int xpEarned;

/// Create a copy of ShadowingResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShadowingResultCopyWith<_ShadowingResult> get copyWith => __$ShadowingResultCopyWithImpl<_ShadowingResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShadowingResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShadowingResult&&(identical(other.id, id) || other.id == id)&&(identical(other.overallScore, overallScore) || other.overallScore == overallScore)&&(identical(other.breakdown, breakdown) || other.breakdown == breakdown)&&const DeepCollectionEquality().equals(other._weakSegments, _weakSegments)&&const DeepCollectionEquality().equals(other._feedback, _feedback)&&(identical(other.xpEarned, xpEarned) || other.xpEarned == xpEarned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,overallScore,breakdown,const DeepCollectionEquality().hash(_weakSegments),const DeepCollectionEquality().hash(_feedback),xpEarned);

@override
String toString() {
  return 'ShadowingResult(id: $id, overallScore: $overallScore, breakdown: $breakdown, weakSegments: $weakSegments, feedback: $feedback, xpEarned: $xpEarned)';
}


}

/// @nodoc
abstract mixin class _$ShadowingResultCopyWith<$Res> implements $ShadowingResultCopyWith<$Res> {
  factory _$ShadowingResultCopyWith(_ShadowingResult value, $Res Function(_ShadowingResult) _then) = __$ShadowingResultCopyWithImpl;
@override @useResult
$Res call({
 String id, int overallScore, ShadowingScoreBreakdown breakdown, List<WeakSegment> weakSegments, List<String> feedback, int xpEarned
});


@override $ShadowingScoreBreakdownCopyWith<$Res> get breakdown;

}
/// @nodoc
class __$ShadowingResultCopyWithImpl<$Res>
    implements _$ShadowingResultCopyWith<$Res> {
  __$ShadowingResultCopyWithImpl(this._self, this._then);

  final _ShadowingResult _self;
  final $Res Function(_ShadowingResult) _then;

/// Create a copy of ShadowingResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? overallScore = null,Object? breakdown = null,Object? weakSegments = null,Object? feedback = null,Object? xpEarned = null,}) {
  return _then(_ShadowingResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,overallScore: null == overallScore ? _self.overallScore : overallScore // ignore: cast_nullable_to_non_nullable
as int,breakdown: null == breakdown ? _self.breakdown : breakdown // ignore: cast_nullable_to_non_nullable
as ShadowingScoreBreakdown,weakSegments: null == weakSegments ? _self._weakSegments : weakSegments // ignore: cast_nullable_to_non_nullable
as List<WeakSegment>,feedback: null == feedback ? _self._feedback : feedback // ignore: cast_nullable_to_non_nullable
as List<String>,xpEarned: null == xpEarned ? _self.xpEarned : xpEarned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ShadowingResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShadowingScoreBreakdownCopyWith<$Res> get breakdown {
  
  return $ShadowingScoreBreakdownCopyWith<$Res>(_self.breakdown, (value) {
    return _then(_self.copyWith(breakdown: value));
  });
}
}


/// @nodoc
mixin _$ShadowingScoreBreakdown {

 int get followingScore; int get pronunciationScore; int get rhythmScore; int get completenessScore;
/// Create a copy of ShadowingScoreBreakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShadowingScoreBreakdownCopyWith<ShadowingScoreBreakdown> get copyWith => _$ShadowingScoreBreakdownCopyWithImpl<ShadowingScoreBreakdown>(this as ShadowingScoreBreakdown, _$identity);

  /// Serializes this ShadowingScoreBreakdown to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShadowingScoreBreakdown&&(identical(other.followingScore, followingScore) || other.followingScore == followingScore)&&(identical(other.pronunciationScore, pronunciationScore) || other.pronunciationScore == pronunciationScore)&&(identical(other.rhythmScore, rhythmScore) || other.rhythmScore == rhythmScore)&&(identical(other.completenessScore, completenessScore) || other.completenessScore == completenessScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,followingScore,pronunciationScore,rhythmScore,completenessScore);

@override
String toString() {
  return 'ShadowingScoreBreakdown(followingScore: $followingScore, pronunciationScore: $pronunciationScore, rhythmScore: $rhythmScore, completenessScore: $completenessScore)';
}


}

/// @nodoc
abstract mixin class $ShadowingScoreBreakdownCopyWith<$Res>  {
  factory $ShadowingScoreBreakdownCopyWith(ShadowingScoreBreakdown value, $Res Function(ShadowingScoreBreakdown) _then) = _$ShadowingScoreBreakdownCopyWithImpl;
@useResult
$Res call({
 int followingScore, int pronunciationScore, int rhythmScore, int completenessScore
});




}
/// @nodoc
class _$ShadowingScoreBreakdownCopyWithImpl<$Res>
    implements $ShadowingScoreBreakdownCopyWith<$Res> {
  _$ShadowingScoreBreakdownCopyWithImpl(this._self, this._then);

  final ShadowingScoreBreakdown _self;
  final $Res Function(ShadowingScoreBreakdown) _then;

/// Create a copy of ShadowingScoreBreakdown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? followingScore = null,Object? pronunciationScore = null,Object? rhythmScore = null,Object? completenessScore = null,}) {
  return _then(_self.copyWith(
followingScore: null == followingScore ? _self.followingScore : followingScore // ignore: cast_nullable_to_non_nullable
as int,pronunciationScore: null == pronunciationScore ? _self.pronunciationScore : pronunciationScore // ignore: cast_nullable_to_non_nullable
as int,rhythmScore: null == rhythmScore ? _self.rhythmScore : rhythmScore // ignore: cast_nullable_to_non_nullable
as int,completenessScore: null == completenessScore ? _self.completenessScore : completenessScore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ShadowingScoreBreakdown].
extension ShadowingScoreBreakdownPatterns on ShadowingScoreBreakdown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShadowingScoreBreakdown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShadowingScoreBreakdown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShadowingScoreBreakdown value)  $default,){
final _that = this;
switch (_that) {
case _ShadowingScoreBreakdown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShadowingScoreBreakdown value)?  $default,){
final _that = this;
switch (_that) {
case _ShadowingScoreBreakdown() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int followingScore,  int pronunciationScore,  int rhythmScore,  int completenessScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShadowingScoreBreakdown() when $default != null:
return $default(_that.followingScore,_that.pronunciationScore,_that.rhythmScore,_that.completenessScore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int followingScore,  int pronunciationScore,  int rhythmScore,  int completenessScore)  $default,) {final _that = this;
switch (_that) {
case _ShadowingScoreBreakdown():
return $default(_that.followingScore,_that.pronunciationScore,_that.rhythmScore,_that.completenessScore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int followingScore,  int pronunciationScore,  int rhythmScore,  int completenessScore)?  $default,) {final _that = this;
switch (_that) {
case _ShadowingScoreBreakdown() when $default != null:
return $default(_that.followingScore,_that.pronunciationScore,_that.rhythmScore,_that.completenessScore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShadowingScoreBreakdown implements ShadowingScoreBreakdown {
  const _ShadowingScoreBreakdown({required this.followingScore, required this.pronunciationScore, required this.rhythmScore, required this.completenessScore});
  factory _ShadowingScoreBreakdown.fromJson(Map<String, dynamic> json) => _$ShadowingScoreBreakdownFromJson(json);

@override final  int followingScore;
@override final  int pronunciationScore;
@override final  int rhythmScore;
@override final  int completenessScore;

/// Create a copy of ShadowingScoreBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShadowingScoreBreakdownCopyWith<_ShadowingScoreBreakdown> get copyWith => __$ShadowingScoreBreakdownCopyWithImpl<_ShadowingScoreBreakdown>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShadowingScoreBreakdownToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShadowingScoreBreakdown&&(identical(other.followingScore, followingScore) || other.followingScore == followingScore)&&(identical(other.pronunciationScore, pronunciationScore) || other.pronunciationScore == pronunciationScore)&&(identical(other.rhythmScore, rhythmScore) || other.rhythmScore == rhythmScore)&&(identical(other.completenessScore, completenessScore) || other.completenessScore == completenessScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,followingScore,pronunciationScore,rhythmScore,completenessScore);

@override
String toString() {
  return 'ShadowingScoreBreakdown(followingScore: $followingScore, pronunciationScore: $pronunciationScore, rhythmScore: $rhythmScore, completenessScore: $completenessScore)';
}


}

/// @nodoc
abstract mixin class _$ShadowingScoreBreakdownCopyWith<$Res> implements $ShadowingScoreBreakdownCopyWith<$Res> {
  factory _$ShadowingScoreBreakdownCopyWith(_ShadowingScoreBreakdown value, $Res Function(_ShadowingScoreBreakdown) _then) = __$ShadowingScoreBreakdownCopyWithImpl;
@override @useResult
$Res call({
 int followingScore, int pronunciationScore, int rhythmScore, int completenessScore
});




}
/// @nodoc
class __$ShadowingScoreBreakdownCopyWithImpl<$Res>
    implements _$ShadowingScoreBreakdownCopyWith<$Res> {
  __$ShadowingScoreBreakdownCopyWithImpl(this._self, this._then);

  final _ShadowingScoreBreakdown _self;
  final $Res Function(_ShadowingScoreBreakdown) _then;

/// Create a copy of ShadowingScoreBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? followingScore = null,Object? pronunciationScore = null,Object? rhythmScore = null,Object? completenessScore = null,}) {
  return _then(_ShadowingScoreBreakdown(
followingScore: null == followingScore ? _self.followingScore : followingScore // ignore: cast_nullable_to_non_nullable
as int,pronunciationScore: null == pronunciationScore ? _self.pronunciationScore : pronunciationScore // ignore: cast_nullable_to_non_nullable
as int,rhythmScore: null == rhythmScore ? _self.rhythmScore : rhythmScore // ignore: cast_nullable_to_non_nullable
as int,completenessScore: null == completenessScore ? _self.completenessScore : completenessScore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WeakSegment {

 double get startTime; double get endTime; String get text; String get issueType;
/// Create a copy of WeakSegment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeakSegmentCopyWith<WeakSegment> get copyWith => _$WeakSegmentCopyWithImpl<WeakSegment>(this as WeakSegment, _$identity);

  /// Serializes this WeakSegment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeakSegment&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.text, text) || other.text == text)&&(identical(other.issueType, issueType) || other.issueType == issueType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startTime,endTime,text,issueType);

@override
String toString() {
  return 'WeakSegment(startTime: $startTime, endTime: $endTime, text: $text, issueType: $issueType)';
}


}

/// @nodoc
abstract mixin class $WeakSegmentCopyWith<$Res>  {
  factory $WeakSegmentCopyWith(WeakSegment value, $Res Function(WeakSegment) _then) = _$WeakSegmentCopyWithImpl;
@useResult
$Res call({
 double startTime, double endTime, String text, String issueType
});




}
/// @nodoc
class _$WeakSegmentCopyWithImpl<$Res>
    implements $WeakSegmentCopyWith<$Res> {
  _$WeakSegmentCopyWithImpl(this._self, this._then);

  final WeakSegment _self;
  final $Res Function(WeakSegment) _then;

/// Create a copy of WeakSegment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startTime = null,Object? endTime = null,Object? text = null,Object? issueType = null,}) {
  return _then(_self.copyWith(
startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as double,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as double,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,issueType: null == issueType ? _self.issueType : issueType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WeakSegment].
extension WeakSegmentPatterns on WeakSegment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeakSegment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeakSegment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeakSegment value)  $default,){
final _that = this;
switch (_that) {
case _WeakSegment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeakSegment value)?  $default,){
final _that = this;
switch (_that) {
case _WeakSegment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double startTime,  double endTime,  String text,  String issueType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeakSegment() when $default != null:
return $default(_that.startTime,_that.endTime,_that.text,_that.issueType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double startTime,  double endTime,  String text,  String issueType)  $default,) {final _that = this;
switch (_that) {
case _WeakSegment():
return $default(_that.startTime,_that.endTime,_that.text,_that.issueType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double startTime,  double endTime,  String text,  String issueType)?  $default,) {final _that = this;
switch (_that) {
case _WeakSegment() when $default != null:
return $default(_that.startTime,_that.endTime,_that.text,_that.issueType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeakSegment implements WeakSegment {
  const _WeakSegment({required this.startTime, required this.endTime, required this.text, required this.issueType});
  factory _WeakSegment.fromJson(Map<String, dynamic> json) => _$WeakSegmentFromJson(json);

@override final  double startTime;
@override final  double endTime;
@override final  String text;
@override final  String issueType;

/// Create a copy of WeakSegment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeakSegmentCopyWith<_WeakSegment> get copyWith => __$WeakSegmentCopyWithImpl<_WeakSegment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeakSegmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeakSegment&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.text, text) || other.text == text)&&(identical(other.issueType, issueType) || other.issueType == issueType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startTime,endTime,text,issueType);

@override
String toString() {
  return 'WeakSegment(startTime: $startTime, endTime: $endTime, text: $text, issueType: $issueType)';
}


}

/// @nodoc
abstract mixin class _$WeakSegmentCopyWith<$Res> implements $WeakSegmentCopyWith<$Res> {
  factory _$WeakSegmentCopyWith(_WeakSegment value, $Res Function(_WeakSegment) _then) = __$WeakSegmentCopyWithImpl;
@override @useResult
$Res call({
 double startTime, double endTime, String text, String issueType
});




}
/// @nodoc
class __$WeakSegmentCopyWithImpl<$Res>
    implements _$WeakSegmentCopyWith<$Res> {
  __$WeakSegmentCopyWithImpl(this._self, this._then);

  final _WeakSegment _self;
  final $Res Function(_WeakSegment) _then;

/// Create a copy of WeakSegment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startTime = null,Object? endTime = null,Object? text = null,Object? issueType = null,}) {
  return _then(_WeakSegment(
startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as double,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as double,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,issueType: null == issueType ? _self.issueType : issueType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

