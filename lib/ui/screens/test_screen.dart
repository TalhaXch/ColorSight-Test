import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:colorsighttest/core/theme/app_theme.dart';
import 'package:colorsighttest/logic/test_controller.dart';
import 'package:colorsighttest/ui/widgets/animated_progress_bar.dart';
import 'package:colorsighttest/ui/widgets/primary_button.dart';
import 'package:colorsighttest/ui/screens/result_screen.dart';
import 'package:colorsighttest/data/plate_data.dart';

class TestScreen extends ConsumerStatefulWidget {
  const TestScreen({super.key});

  @override
  ConsumerState<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends ConsumerState<TestScreen>
    with TickerProviderStateMixin {
  String? selectedAnswer;
  bool isSubmitting = false;
  late AnimationController _plateAnimationController;
  late AnimationController _buttonAnimationController;
  late Animation<double> _plateFadeAnimation;
  late Animation<double> _plateScaleAnimation;
  late Animation<double> _buttonFadeAnimation;

  @override
  void initState() {
    super.initState();

    _plateAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _plateFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _plateAnimationController, curve: Curves.easeOut),
    );

    _plateScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _plateAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _buttonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _plateAnimationController.forward();
  }

  @override
  void dispose() {
    _plateAnimationController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  void _animateTransition() async {
    await _plateAnimationController.reverse();
    _plateAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final testState = ref.watch(testStateProvider);
    final testController = ref.read(testStateProvider.notifier);
    final currentPlate = testController.getCurrentPlate();

    // Navigate to results if test is complete
    if (testState.isTestComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    ResultScreen(result: testState),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      });
    }

    if (currentPlate == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return WillPopScope(
      onWillPop: () async {
        return await _showExitDialog(context) ?? false;
      },
      child: Scaffold(
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
                // Custom Header
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () async {
                          final shouldExit = await _showExitDialog(context);
                          if (shouldExit == true && mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Color Vision Test',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(width: 48), // Balance the close button
                    ],
                  ),
                ),

                // Animated Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingLarge,
                  ),
                  child: AnimatedProgressBar(
                    current: testState.currentPlateIndex + 1,
                    total: PlateData.totalPlates,
                  ),
                ),

                const SizedBox(height: AppTheme.spacingLarge),

                // Color Plate Image with Animation
                Expanded(
                  child: FadeTransition(
                    opacity: _plateFadeAnimation,
                    child: ScaleTransition(
                      scale: _plateScaleAnimation,
                      child: Center(
                        child: _buildPlateCard(currentPlate.imageAsset),
                      ),
                    ),
                  ),
                ),

                // Question and Options
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'What number do you see?',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingMedium),

                      // Answer Options Grid
                      Wrap(
                        spacing: AppTheme.spacingSmall,
                        runSpacing: AppTheme.spacingSmall,
                        children:
                            currentPlate.options.map((option) {
                              return _buildAnswerChip(option);
                            }).toList(),
                      ),

                      const SizedBox(height: AppTheme.spacingLarge),

                      // Submit Button
                      PrimaryButton(
                        text:
                            testState.currentPlateIndex <
                                    PlateData.totalPlates - 1
                                ? 'Next'
                                : 'Finish Test',
                        icon:
                            testState.currentPlateIndex <
                                    PlateData.totalPlates - 1
                                ? Icons.arrow_forward_rounded
                                : Icons.check_circle_rounded,
                        isLoading: isSubmitting,
                        onPressed:
                            selectedAnswer == null
                                ? null
                                : () async {
                                  if (selectedAnswer == null) return;

                                  setState(() => isSubmitting = true);
                                  HapticFeedback.mediumImpact();

                                  await testController.submitAnswer(
                                    selectedAnswer!,
                                  );

                                  await Future.delayed(
                                    const Duration(milliseconds: 300),
                                  );

                                  if (mounted) {
                                    setState(() {
                                      selectedAnswer = null;
                                      isSubmitting = false;
                                    });
                                    _animateTransition();
                                  }
                                },
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlateCard(String assetPath) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(maxWidth: 360, maxHeight: 360),
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            boxShadow: AppTheme.mediumShadow,
          ),
          padding: const EdgeInsets.all(AppTheme.spacingMedium),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            child: Image.asset(
              assetPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Beautiful placeholder for missing images
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.red.shade200,
                        Colors.green.shade200,
                        Colors.blue.shade200,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.palette_rounded,
                            size: 40,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingMedium),
                        Text(
                          'Test Plate',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingXSmall),
                        Text(
                          'Placeholder Image',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerChip(String option) {
    final theme = Theme.of(context);
    final isSelected = selectedAnswer == option;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() {
              selectedAnswer = option;
            });
          },
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLarge,
              vertical: AppTheme.spacingMedium,
            ),
            decoration: BoxDecoration(
              gradient: isSelected ? AppTheme.primaryGradient : null,
              color: isSelected ? null : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(
                color:
                    isSelected
                        ? AppTheme.primaryColor
                        : theme.colorScheme.onSurface.withOpacity(0.1),
                width: isSelected ? 2 : 1,
              ),
              boxShadow:
                  isSelected
                      ? [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                      : null,
            ),
            child: Text(
              option,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showExitDialog(BuildContext context) {
    final theme = Theme.of(context);

    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: AppTheme.warningColor,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSmall),
                const Text('Exit Test?'),
              ],
            ),
            content: const Text(
              'Are you sure you want to exit? Your progress will be lost.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorColor,
                ),
                child: const Text('Exit'),
              ),
            ],
          ),
    );
  }
}
