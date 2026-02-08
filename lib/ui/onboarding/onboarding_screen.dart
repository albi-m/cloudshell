/// Onboarding flow shown on first app launch.
///
/// A series of feature slides followed by a get-started action.
/// Sets onboarding_complete=true on completion.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/settings_provider.dart';

/// Data model for a single onboarding slide.
class _OnboardingSlide {
  const _OnboardingSlide({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
}

const _slides = [
  _OnboardingSlide(
    icon: LucideIcons.terminal,
    iconColor: AppColors.accentPrimary,
    title: 'Secure SSH Terminal',
    subtitle:
        'Connect to your servers with a fast, modern terminal. '
        'Multi-tab sessions, copy/paste, and customizable themes.',
  ),
  _OnboardingSlide(
    icon: LucideIcons.keyRound,
    iconColor: AppColors.accentPurple,
    title: 'SSH Key Management',
    subtitle:
        'Import and manage your SSH keys securely. '
        'Private keys are stored in your device keychain, never in the database.',
  ),
  _OnboardingSlide(
    icon: LucideIcons.folderOpen,
    iconColor: AppColors.accentCyan,
    title: 'SFTP File Browser',
    subtitle:
        'Browse, upload, and download files from your remote servers. '
        'Full directory navigation with transfer progress.',
  ),
  _OnboardingSlide(
    icon: LucideIcons.shieldCheck,
    iconColor: AppColors.accentGreen,
    title: 'Privacy First',
    subtitle:
        'Your data stays yours. End-to-end encryption, '
        'zero-knowledge architecture, and optional self-hosted sync.',
  ),
];

/// Onboarding screen shown on first launch.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    ref
        .read(settingsNotifierProvider.notifier)
        .set(SettingsKeys.onboardingComplete, 'true');
    context.go(RouteNames.hosts);
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _slides.length - 1;

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(
                    'Skip',
                    style: AppTypography.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),

            // Slides
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) =>
                    setState(() => _currentPage = index),
                itemBuilder: (context, index) =>
                    _SlideContent(slide: _slides[index]),
              ),
            ),

            // Page indicator + navigation
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Row(
                children: [
                  // Page dots
                  Row(
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        width: index == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == _currentPage
                              ? AppColors.accentPrimary
                              : AppColors.bgActive,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Next / Get Started button
                  ElevatedButton(
                    onPressed: _onNext,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                    ),
                    child: Text(isLastPage ? 'Get Started' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Content for a single onboarding slide.
class _SlideContent extends StatelessWidget {
  const _SlideContent({required this.slide});

  final _OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: slide.iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              slide.icon,
              size: 56,
              color: slide.iconColor,
            ),
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            slide.title,
            style: AppTypography.display,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Subtitle
          Text(
            slide.subtitle,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
