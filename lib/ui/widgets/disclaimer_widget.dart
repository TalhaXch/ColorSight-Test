import 'package:flutter/material.dart';
import 'package:colorsighttest/core/constants/app_constants.dart';

class DisclaimerWidget extends StatelessWidget {
  const DisclaimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.amber.shade700, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important Notice',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.amber.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppConstants.disclaimer,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.amber.shade900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
