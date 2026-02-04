import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:colorsighttest/logic/test_state.dart';
import 'package:colorsighttest/logic/test_controller.dart';
import 'package:colorsighttest/ui/widgets/custom_buttons.dart';
import 'package:colorsighttest/ui/screens/instructions_screen.dart';
import 'package:colorsighttest/ui/screens/history_screen.dart';
import 'package:colorsighttest/data/plate_data.dart';

class ResultScreen extends ConsumerWidget {
  final TestState result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visionType = result.detectedVisionType;

    if (visionType == null) {
      return const Scaffold(
        body: Center(child: Text('Error: No results available')),
      );
    }

    // Trigger history refresh
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyRefreshProvider.notifier).state++;
    });

    final isPassing = result.correctAnswers >= (PlateData.totalPlates * 0.7);
    final percentage =
        ((result.correctAnswers / PlateData.totalPlates) * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Results'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'View History',
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Result Icon with Animation
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      (isPassing ? Colors.green : Colors.orange).withOpacity(
                        0.2,
                      ),
                      (isPassing ? Colors.green : Colors.orange).withOpacity(
                        0.05,
                      ),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPassing ? Icons.check_circle_outline : Icons.info_outline,
                  size: 80,
                  color: isPassing ? Colors.green : Colors.orange,
                ),
              ),
              const SizedBox(height: 32),

              // Score Display
              Text(
                '$percentage%',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 56,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${result.correctAnswers} out of ${PlateData.totalPlates} correct',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 40),

              // Result Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.visibility, color: Colors.white, size: 32),
                    const SizedBox(height: 16),
                    Text(
                      visionType.displayName,
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getShortDescription(visionType),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Recommendation Card
              if (!isPassing)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.medical_services_outlined, color: Colors.blue),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Consult an eye care professional for accurate diagnosis',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // Disclaimer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.amber.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'For screening only. Not a medical diagnosis.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.amber.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Action Buttons
              PrimaryButton(
                text: 'Take Another Test',
                icon: Icons.refresh,
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const InstructionsScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: 'View History',
                icon: Icons.history,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getShortDescription(visionType) {
    switch (visionType.toString()) {
      case 'VisionType.normal':
        return 'Your color perception appears normal';
      case 'VisionType.redGreen':
        return 'Difficulty with red-green colors detected';
      case 'VisionType.blueYellow':
        return 'Difficulty with blue-yellow colors detected';
      default:
        return 'Significant color perception difficulty detected';
    }
  }
}
