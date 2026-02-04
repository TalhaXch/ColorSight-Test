import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:colorsighttest/core/theme/app_theme.dart';
import 'package:colorsighttest/ui/widgets/primary_button.dart';
import 'package:colorsighttest/ui/widgets/gradient_card.dart';
import 'package:colorsighttest/ui/screens/main_navigation.dart';
import 'package:colorsighttest/ui/screens/settings_screen.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  late List<AnimationController> _controllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.remove_red_eye_rounded,
      iconColor: AppTheme.primaryColor,
      title: 'Welcome to ColorSightTest',
      description:
          'A quick and easy way to check your color vision using scientifically-designed color plates.',
      gradient: AppTheme.primaryGradient,
    ),
    OnboardingPage(
      icon: Icons.palette_rounded,
      iconColor: AppTheme.secondaryColor,
      title: 'How It Works',
      description:
          'You\'ll see 12 color plates. Each contains a hidden number or pattern. Simply select what you see.',
      gradient: AppTheme.secondaryGradient,
    ),
    OnboardingPage(
      icon: Icons.timer_rounded,
      iconColor: AppTheme.accentColor,
      title: 'Takes 2 Minutes',
      description:
          'The test is quick, accurate, and designed to be comfortable for your eyes. Results are instant.',
      gradient: AppTheme.accentGradient,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _controllers = List.generate(
      _pages.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _fadeAnimations =
        _controllers
            .map(
              (controller) => Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: controller, curve: Curves.easeInOut),
              ),
            )
            .toList();

    _slideAnimations =
        _controllers
            .map(
              (controller) => Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
              ),
            )
            .toList();

    _controllers[0].forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _controllers[page].forward();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _startTest();
    }
  }

  void _skipToTest() {
    _startTest();
  }

  void _startTest() async {
    // Mark onboarding as complete
    final prefsService = ref.read(preferencesServiceProvider);
    await prefsService.setOnboardingComplete(true);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => const MainNavigation(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                theme.brightness == Brightness.light
                    ? [AppTheme.lightBackground, AppTheme.lightSurface]
                    : [AppTheme.darkBackground, AppTheme.darkSurface],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMedium),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _skipToTest,
                    child: Text(
                      'Skip',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return FadeTransition(
                      opacity: _fadeAnimations[index],
                      child: SlideTransition(
                        position: _slideAnimations[index],
                        child: _buildPageContent(_pages[index]),
                      ),
                    );
                  },
                ),
              ),

              // Page Indicator
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.spacingLarge,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingXSmall,
                      ),
                      width: _currentPage == index ? 32 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        gradient:
                            _currentPage == index
                                ? AppTheme.primaryGradient
                                : null,
                        color:
                            _currentPage != index
                                ? theme.colorScheme.onSurface.withOpacity(0.2)
                                : null,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),

              // Next/Start Button
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingLarge),
                child: PrimaryButton(
                  text:
                      _currentPage == _pages.length - 1 ? 'Start Test' : 'Next',
                  onPressed: _nextPage,
                  icon:
                      _currentPage == _pages.length - 1
                          ? Icons.play_arrow_rounded
                          : Icons.arrow_forward_rounded,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(OnboardingPage page) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with gradient background
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: page.gradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: page.iconColor.withOpacity(0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(page.icon, size: 64, color: Colors.white),
          ),

          const SizedBox(height: AppTheme.spacingXLarge),

          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: AppTheme.spacingMedium),

          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final LinearGradient gradient;

  OnboardingPage({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.gradient,
  });
}
