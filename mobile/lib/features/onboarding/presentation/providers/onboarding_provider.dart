import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/domain/models/user.dart';
import '../../domain/onboarding_state.dart';

/// Onboarding State Provider
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});

/// Onboarding Notifier - Manages onboarding flow state
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  /// Set selected level
  void setLevel(Level level) {
    state = state.copyWith(selectedLevel: level, currentStep: 1);
  }

  /// Set persona details
  void setPersona({
    required String name,
    required String voice,
    required String personality,
  }) {
    state = state.copyWith(
      personaName: name,
      selectedVoice: voice,
      selectedPersonality: personality,
      currentStep: 2,
    );
  }

  /// Complete onboarding
  void completeOnboarding() {
    state = state.copyWith(currentStep: 3);
  }

  /// Reset onboarding state
  void reset() {
    state = const OnboardingState();
  }

  /// Check if onboarding is complete
  bool get isComplete => state.currentStep >= 3;
}

