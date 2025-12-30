// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingState {

 Level? get selectedLevel; String? get personaName; String? get selectedVoice; String? get selectedPersonality; int get currentStep;
/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStateCopyWith<OnboardingState> get copyWith => _$OnboardingStateCopyWithImpl<OnboardingState>(this as OnboardingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingState&&const DeepCollectionEquality().equals(other.selectedLevel, selectedLevel)&&(identical(other.personaName, personaName) || other.personaName == personaName)&&(identical(other.selectedVoice, selectedVoice) || other.selectedVoice == selectedVoice)&&(identical(other.selectedPersonality, selectedPersonality) || other.selectedPersonality == selectedPersonality)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(selectedLevel),personaName,selectedVoice,selectedPersonality,currentStep);

@override
String toString() {
  return 'OnboardingState(selectedLevel: $selectedLevel, personaName: $personaName, selectedVoice: $selectedVoice, selectedPersonality: $selectedPersonality, currentStep: $currentStep)';
}


}

/// @nodoc
abstract mixin class $OnboardingStateCopyWith<$Res>  {
  factory $OnboardingStateCopyWith(OnboardingState value, $Res Function(OnboardingState) _then) = _$OnboardingStateCopyWithImpl;
@useResult
$Res call({
 Level? selectedLevel, String? personaName, String? selectedVoice, String? selectedPersonality, int currentStep
});




}
/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._self, this._then);

  final OnboardingState _self;
  final $Res Function(OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedLevel = freezed,Object? personaName = freezed,Object? selectedVoice = freezed,Object? selectedPersonality = freezed,Object? currentStep = null,}) {
  return _then(_self.copyWith(
selectedLevel: freezed == selectedLevel ? _self.selectedLevel : selectedLevel // ignore: cast_nullable_to_non_nullable
as Level?,personaName: freezed == personaName ? _self.personaName : personaName // ignore: cast_nullable_to_non_nullable
as String?,selectedVoice: freezed == selectedVoice ? _self.selectedVoice : selectedVoice // ignore: cast_nullable_to_non_nullable
as String?,selectedPersonality: freezed == selectedPersonality ? _self.selectedPersonality : selectedPersonality // ignore: cast_nullable_to_non_nullable
as String?,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingState].
extension OnboardingStatePatterns on OnboardingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingState value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingState value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Level? selectedLevel,  String? personaName,  String? selectedVoice,  String? selectedPersonality,  int currentStep)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.selectedLevel,_that.personaName,_that.selectedVoice,_that.selectedPersonality,_that.currentStep);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Level? selectedLevel,  String? personaName,  String? selectedVoice,  String? selectedPersonality,  int currentStep)  $default,) {final _that = this;
switch (_that) {
case _OnboardingState():
return $default(_that.selectedLevel,_that.personaName,_that.selectedVoice,_that.selectedPersonality,_that.currentStep);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Level? selectedLevel,  String? personaName,  String? selectedVoice,  String? selectedPersonality,  int currentStep)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.selectedLevel,_that.personaName,_that.selectedVoice,_that.selectedPersonality,_that.currentStep);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingState implements OnboardingState {
  const _OnboardingState({this.selectedLevel, this.personaName, this.selectedVoice, this.selectedPersonality, this.currentStep = 0});
  

@override final  Level? selectedLevel;
@override final  String? personaName;
@override final  String? selectedVoice;
@override final  String? selectedPersonality;
@override@JsonKey() final  int currentStep;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStateCopyWith<_OnboardingState> get copyWith => __$OnboardingStateCopyWithImpl<_OnboardingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingState&&const DeepCollectionEquality().equals(other.selectedLevel, selectedLevel)&&(identical(other.personaName, personaName) || other.personaName == personaName)&&(identical(other.selectedVoice, selectedVoice) || other.selectedVoice == selectedVoice)&&(identical(other.selectedPersonality, selectedPersonality) || other.selectedPersonality == selectedPersonality)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(selectedLevel),personaName,selectedVoice,selectedPersonality,currentStep);

@override
String toString() {
  return 'OnboardingState(selectedLevel: $selectedLevel, personaName: $personaName, selectedVoice: $selectedVoice, selectedPersonality: $selectedPersonality, currentStep: $currentStep)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStateCopyWith<$Res> implements $OnboardingStateCopyWith<$Res> {
  factory _$OnboardingStateCopyWith(_OnboardingState value, $Res Function(_OnboardingState) _then) = __$OnboardingStateCopyWithImpl;
@override @useResult
$Res call({
 Level? selectedLevel, String? personaName, String? selectedVoice, String? selectedPersonality, int currentStep
});




}
/// @nodoc
class __$OnboardingStateCopyWithImpl<$Res>
    implements _$OnboardingStateCopyWith<$Res> {
  __$OnboardingStateCopyWithImpl(this._self, this._then);

  final _OnboardingState _self;
  final $Res Function(_OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedLevel = freezed,Object? personaName = freezed,Object? selectedVoice = freezed,Object? selectedPersonality = freezed,Object? currentStep = null,}) {
  return _then(_OnboardingState(
selectedLevel: freezed == selectedLevel ? _self.selectedLevel : selectedLevel // ignore: cast_nullable_to_non_nullable
as Level?,personaName: freezed == personaName ? _self.personaName : personaName // ignore: cast_nullable_to_non_nullable
as String?,selectedVoice: freezed == selectedVoice ? _self.selectedVoice : selectedVoice // ignore: cast_nullable_to_non_nullable
as String?,selectedPersonality: freezed == selectedPersonality ? _self.selectedPersonality : selectedPersonality // ignore: cast_nullable_to_non_nullable
as String?,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
