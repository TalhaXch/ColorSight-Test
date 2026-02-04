import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:colorsighttest/core/theme/app_theme.dart';
import 'package:colorsighttest/ui/widgets/custom_app_bar.dart';
import 'package:colorsighttest/ui/widgets/primary_button.dart';
import 'package:colorsighttest/ui/widgets/gradient_card.dart';
import 'package:colorsighttest/ui/screens/test_screen.dart';
import 'package:colorsighttest/logic/test_controller.dart';

class InstructionsScreen extends ConsumerStatefulWidget {
  const InstructionsScreen({super.key});

  @override
  ConsumerState<InstructionsScreen> createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends ConsumerState<InstructionsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Start New Test',
        showBackButton: false,
      ),
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(AppTheme.spacingMedium),
                    children: [
                      // Hero Card
                      GradientCard(
                        gradient: AppTheme.primaryGradient,
                        padding: const EdgeInsets.all(AppTheme.spacingLarge),
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.remove_red_eye_rounded,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingMedium),
                            Text(
                              'Ready to Test?',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingSmall),
                            Text(
                              'Takes about 2 minutes',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacingLarge),

                      // Instructions
                      _buildStepCard(
                        context,
                        Icons.visibility_rounded,
                        AppTheme.primaryColor,
                        'View Color Plates',
                        'Look at 12 colorful test patterns',
                      ),
                      const SizedBox(height: AppTheme.spacingSmall),
                      _buildStepCard(
                        context,
                        Icons.touch_app_rounded,
                        AppTheme.secondaryColor,
                        'Select What You See',
                        'Choose the number or pattern you identify',
                      ),
                      const SizedBox(height: AppTheme.spacingSmall),
                      _buildStepCard(
                        context,
                        Icons.analytics_rounded,
                        AppTheme.accentColor,
                        'Get Instant Results',
                        'Receive your color vision analysis',
                      ),

                      const SizedBox(height: AppTheme.spacingLarge),

                      // Important Notes
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingMedium),
                        decoration: BoxDecoration(
                          color: AppTheme.infoColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusMedium,
                          ),
                          border: Border.all(
                            color: AppTheme.infoColor.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.tips_and_updates_rounded,
                                  color: AppTheme.infoColor,
                                  size: 20,
                                ),
                                const SizedBox(width: AppTheme.spacingSmall),
                                Text(
                                  'For Best Results',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: AppTheme.infoColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppTheme.spacingSmall),
                            _buildTip(
                              context,
                              'Take the test in good lighting',
                            ),
                            _buildTip(
                              context,
                              'Hold device at comfortable distance',
                            ),
                            _buildTip(
                              context,
                              'Answer honestly - no right or wrong',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacingMedium),

                      // Disclaimer
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingMedium),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusMedium,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.onSurface.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.6,
                              ),
                              size: 20,
                            ),
                            const SizedBox(width: AppTheme.spacingSmall),
                            Expanded(
                              child: Text(
                                'This is a screening tool, not a medical diagnosis. Consult an eye care professional for accurate assessment.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Start Button
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  child: PrimaryButton(
                    text: 'Start Test',
                    icon: Icons.play_arrow_rounded,
                    onPressed: () {
                      ref.read(testStateProvider.notifier).resetTest();
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const TestScreen(),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;
                            var tween = Tween(
                              begin: begin,
                              end: end,
                            ).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 400),
                        ),
                      );
                    },
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard(
    BuildContext context,
    IconData icon,
    Color iconColor,
    String title,
    String description,
  ) {
    final theme = Theme.of(context);

    return GradientCard(
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  iconColor.withOpacity(0.2),
                  iconColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: AppTheme.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXSmall / 2),
                Text(description, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(BuildContext context, String text) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingXSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: AppTheme.infoColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppTheme.spacingSmall),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
