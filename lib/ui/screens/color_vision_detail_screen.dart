import 'package:flutter/material.dart';
import 'package:colorsighttest/core/theme/app_theme.dart';
import 'package:colorsighttest/ui/widgets/custom_app_bar.dart';

class ColorVisionDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final List<String> keyPoints;

  const ColorVisionDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.keyPoints,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: title),
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
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacingMedium),
          children: [
            // Hero Icon
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    iconColor.withOpacity(0.2),
                    iconColor.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 80, color: iconColor),
            ),

            const SizedBox(height: AppTheme.spacingLarge),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: AppTheme.spacingLarge),

            // Description
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                boxShadow: AppTheme.softShadow,
              ),
              child: Text(
                description,
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
            ),

            const SizedBox(height: AppTheme.spacingLarge),

            // Key Points
            Text(
              'Key Points',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: AppTheme.spacingSmall),

            ...keyPoints.map(
              (point) => Container(
                margin: const EdgeInsets.only(bottom: AppTheme.spacingSmall),
                padding: const EdgeInsets.all(AppTheme.spacingMedium),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(
                    color: iconColor.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        color: iconColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSmall),
                    Expanded(
                      child: Text(point, style: theme.textTheme.bodyMedium),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
