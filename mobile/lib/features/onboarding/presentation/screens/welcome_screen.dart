import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/dimensions.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../domain/onboarding_page_data.dart';
import '../widgets/onboarding_page.dart';
import '../widgets/page_indicator.dart';

/// Welcome Screen with Onboarding Carousel
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < OnboardingPageData.pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _getStarted();
    }
  }

  void _skip() {
    _pageController.animateToPage(
      OnboardingPageData.pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _getStarted() {
    // Navigate to level selection
    context.go('/onboarding/level-selection');
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == OnboardingPageData.pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            if (!isLastPage)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMd),
                  child: TextButton(
                    onPressed: _skip,
                    child: const Text('Skip'),
                  ),
                ),
              ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: OnboardingPageData.pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    pageData: OnboardingPageData.pages[index],
                  );
                },
              ),
            ),

            // Page Indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: PageIndicator(
                currentPage: _currentPage,
                pageCount: OnboardingPageData.pages.length,
              ),
            ),

            // Next/Get Started Button
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingLg),
              child: AppButton(
                text: isLastPage ? 'Get Started' : 'Next',
                onPressed: _nextPage,
                isFullWidth: true,
                size: ButtonSize.large,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

