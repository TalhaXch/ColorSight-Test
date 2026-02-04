import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:colorsighttest/logic/test_controller.dart';
import 'package:colorsighttest/ui/widgets/test_history_card.dart';
import 'package:colorsighttest/ui/widgets/custom_buttons.dart';
import 'package:colorsighttest/ui/screens/instructions_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(testHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test History'),
        actions: [
          if (results.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _showClearHistoryDialog(context, ref),
            ),
        ],
      ),
      body: SafeArea(
        child:
            results.isEmpty
                ? _buildEmptyState(context, ref)
                : Column(
                  children: [
                    // Summary Card
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            context,
                            'Tests Taken',
                            results.length.toString(),
                            Icons.assignment,
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          _buildStatItem(
                            context,
                            'Last Test',
                            _getLastTestType(results),
                            Icons.visibility,
                          ),
                        ],
                      ),
                    ),

                    // History List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final result = results[index];
                          return TestHistoryCard(
                            result: result,
                            onTap: () => _showResultDetails(context, result),
                          );
                        },
                      ),
                    ),

                    // Take New Test Button
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: PrimaryButton(
                        text: 'Take New Test',
                        icon: Icons.add,
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const InstructionsScreen(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.visibility_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No Tests Yet',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Start your first color vision test',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Start Test',
              icon: Icons.play_arrow,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const InstructionsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  String _getLastTestType(List results) {
    if (results.isEmpty) return 'N/A';
    final lastResult = results.first;
    final type = lastResult.detectedType.displayName;
    // Return first word or abbreviated version
    if (type.contains('Normal')) return 'Normal';
    if (type.contains('Red-Green')) return 'R-G';
    if (type.contains('Blue-Yellow')) return 'B-Y';
    return 'Total';
  }

  void _showResultDetails(BuildContext context, result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            expand: false,
            builder:
                (context, scrollController) => SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Text(
                        'Test Details',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 24),
                      _buildDetailRow(
                        context,
                        'Result',
                        result.detectedType.displayName,
                      ),
                      _buildDetailRow(
                        context,
                        'Score',
                        '${result.correctAnswers} / ${result.totalQuestions}',
                      ),
                      _buildDetailRow(
                        context,
                        'Percentage',
                        result.percentageString,
                      ),
                      _buildDetailRow(
                        context,
                        'Date',
                        result.date.toString().split('.')[0],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        result.detectedType.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Clear All Tests?'),
            content: const Text(
              'This will permanently delete all your test history.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final repository = ref.read(testRepositoryProvider);
                  await repository.clearAllHistory();
                  // Trigger history refresh
                  ref.read(historyRefreshProvider.notifier).state++;
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
    );
  }
}
