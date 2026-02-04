import 'package:flutter/material.dart';

class AnswerOption extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSelected;

  const AnswerOption({
    super.key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).dividerColor,
                  width: 2,
                ),
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
              ),
              child:
                  isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color:
                      isSelected ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
