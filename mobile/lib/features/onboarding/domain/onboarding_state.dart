import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../auth/domain/models/user.dart';

part 'onboarding_state.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    Level? selectedLevel,
    String? personaName,
    String? selectedVoice,
    String? selectedPersonality,
    @Default(0) int currentStep,
  }) = _OnboardingState;
}
