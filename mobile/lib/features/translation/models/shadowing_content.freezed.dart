// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shadowing_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShadowingContent {

 String get id; String get title; String get description; Difficulty get difficulty; TranslationTopic get topic; String get text; String get audioUrl; Duration get duration; bool get isPremium; List<TextSegment> get segments;
/// Create a copy of ShadowingContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShadowingContentCopyWith<ShadowingContent> get copyWith => _$ShadowingContentCopyWithImpl<ShadowingContent>(this as ShadowingContent, _$identity);

  /// Serializes this ShadowingContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShadowingContent&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.text, text) || other.text == text)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&const DeepCollectionEquality().equals(other.segments, segments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,difficulty,topic,text,audioUrl,duration,isPremium,const DeepCollectionEquality().hash(segments));

@override
String toString() {
  return 'ShadowingContent(id: $id, title: $title, description: $description, difficulty: $difficulty, topic: $topic, text: $text, audioUrl: $audioUrl, duration: $duration, isPremium: $isPremium, segments: $segments)';
}


}

/// @nodoc
abstract mixin class $ShadowingContentCopyWith<$Res>  {
  factory $ShadowingContentCopyWith(ShadowingContent value, $Res Function(ShadowingContent) _then) = _$ShadowingContentCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, Difficulty difficulty, TranslationTopic topic, String text, String audioUrl, Duration duration, bool isPremium, List<TextSegment> segments
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? difficulty = null,Object? topic = null,Object? text = null,Object? audioUrl = null,Object? duration = null,Object? isPremium = null,Object? segments = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as TranslationTopic,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,segments: null == segments ? _self.segments : segments // ignore: cast_nullable_to_non_nullable
as List<TextSegment>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  Difficulty difficulty,  TranslationTopic topic,  String text,  String audioUrl,  Duration duration,  bool isPremium,  List<TextSegment> segments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShadowingContent() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.difficulty,_that.topic,_that.text,_that.audioUrl,_that.duration,_that.isPremium,_that.segments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  Difficulty difficulty,  TranslationTopic topic,  String text,  String audioUrl,  Duration duration,  bool isPremium,  List<TextSegment> segments)  $default,) {final _that = this;
switch (_that) {
case _ShadowingContent():
return $default(_that.id,_that.title,_that.description,_that.difficulty,_that.topic,_that.text,_that.audioUrl,_that.duration,_that.isPremium,_that.segments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  Difficulty difficulty,  TranslationTopic topic,  String text,  String audioUrl,  Duration duration,  bool isPremium,  List<TextSegment> segments)?  $default,) {final _that = this;
switch (_that) {
case _ShadowingContent() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.difficulty,_that.topic,_that.text,_that.audioUrl,_that.duration,_that.isPremium,_that.segments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShadowingContent implements ShadowingContent {
  const _ShadowingContent({required this.id, required this.title, required this.description, required this.difficulty, required this.topic, required this.text, required this.audioUrl, required this.duration, required this.isPremium, required final  List<TextSegment> segments}): _segments = segments;
  factory _ShadowingContent.fromJson(Map<String, dynamic> json) => _$ShadowingContentFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  Difficulty difficulty;
@override final  TranslationTopic topic;
@override final  String text;
@override final  String audioUrl;
@override final  Duration duration;
@override final  bool isPremium;
 final  List<TextSegment> _segments;
@override List<TextSegment> get segments {
  if (_segments is EqualUnmodifiableListView) return _segments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_segments);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShadowingContent&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.text, text) || other.text == text)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&const DeepCollectionEquality().equals(other._segments, _segments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,difficulty,topic,text,audioUrl,duration,isPremium,const DeepCollectionEquality().hash(_segments));

@override
String toString() {
  return 'ShadowingContent(id: $id, title: $title, description: $description, difficulty: $difficulty, topic: $topic, text: $text, audioUrl: $audioUrl, duration: $duration, isPremium: $isPremium, segments: $segments)';
}


}

/// @nodoc
abstract mixin class _$ShadowingContentCopyWith<$Res> implements $ShadowingContentCopyWith<$Res> {
  factory _$ShadowingContentCopyWith(_ShadowingContent value, $Res Function(_ShadowingContent) _then) = __$ShadowingContentCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, Difficulty difficulty, TranslationTopic topic, String text, String audioUrl, Duration duration, bool isPremium, List<TextSegment> segments
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? difficulty = null,Object? topic = null,Object? text = null,Object? audioUrl = null,Object? duration = null,Object? isPremium = null,Object? segments = null,}) {
  return _then(_ShadowingContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as TranslationTopic,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,segments: null == segments ? _self._segments : segments // ignore: cast_nullable_to_non_nullable
as List<TextSegment>,
  ));
}


}


/// @nodoc
mixin _$TextSegment {

 String get id; String get text; Duration get startTime; Duration get endTime;
/// Create a copy of TextSegment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextSegmentCopyWith<TextSegment> get copyWith => _$TextSegmentCopyWithImpl<TextSegment>(this as TextSegment, _$identity);

  /// Serializes this TextSegment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextSegment&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,startTime,endTime);

@override
String toString() {
  return 'TextSegment(id: $id, text: $text, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class $TextSegmentCopyWith<$Res>  {
  factory $TextSegmentCopyWith(TextSegment value, $Res Function(TextSegment) _then) = _$TextSegmentCopyWithImpl;
@useResult
$Res call({
 String id, String text, Duration startTime, Duration endTime
});




}
/// @nodoc
class _$TextSegmentCopyWithImpl<$Res>
    implements $TextSegmentCopyWith<$Res> {
  _$TextSegmentCopyWithImpl(this._self, this._then);

  final TextSegment _self;
  final $Res Function(TextSegment) _then;

/// Create a copy of TextSegment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as Duration,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}

}


/// Adds pattern-matching-related methods to [TextSegment].
extension TextSegmentPatterns on TextSegment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TextSegment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TextSegment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TextSegment value)  $default,){
final _that = this;
switch (_that) {
case _TextSegment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TextSegment value)?  $default,){
final _that = this;
switch (_that) {
case _TextSegment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text,  Duration startTime,  Duration endTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TextSegment() when $default != null:
return $default(_that.id,_that.text,_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text,  Duration startTime,  Duration endTime)  $default,) {final _that = this;
switch (_that) {
case _TextSegment():
return $default(_that.id,_that.text,_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text,  Duration startTime,  Duration endTime)?  $default,) {final _that = this;
switch (_that) {
case _TextSegment() when $default != null:
return $default(_that.id,_that.text,_that.startTime,_that.endTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TextSegment implements TextSegment {
  const _TextSegment({required this.id, required this.text, required this.startTime, required this.endTime});
  factory _TextSegment.fromJson(Map<String, dynamic> json) => _$TextSegmentFromJson(json);

@override final  String id;
@override final  String text;
@override final  Duration startTime;
@override final  Duration endTime;

/// Create a copy of TextSegment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TextSegmentCopyWith<_TextSegment> get copyWith => __$TextSegmentCopyWithImpl<_TextSegment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextSegmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TextSegment&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,startTime,endTime);

@override
String toString() {
  return 'TextSegment(id: $id, text: $text, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class _$TextSegmentCopyWith<$Res> implements $TextSegmentCopyWith<$Res> {
  factory _$TextSegmentCopyWith(_TextSegment value, $Res Function(_TextSegment) _then) = __$TextSegmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String text, Duration startTime, Duration endTime
});




}
/// @nodoc
class __$TextSegmentCopyWithImpl<$Res>
    implements _$TextSegmentCopyWith<$Res> {
  __$TextSegmentCopyWithImpl(this._self, this._then);

  final _TextSegment _self;
  final $Res Function(_TextSegment) _then;

/// Create a copy of TextSegment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_TextSegment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as Duration,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

// dart format on
