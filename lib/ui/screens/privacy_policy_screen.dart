import 'package:flutter/material.dart';
import 'package:colorsighttest/core/theme/app_theme.dart';
import 'package:colorsighttest/ui/widgets/custom_app_bar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Privacy Policy'),
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
            _buildSection(
              context,
              'Information Collection',
              'ColorSightTest is designed with your privacy in mind. All test results are stored locally on your device. We do not collect, transmit, or store any personal information on external servers.',
            ),
            _buildSection(
              context,
              'Data Storage',
              'Test results, including your answers and vision analysis, are saved locally using Hive database. This data never leaves your device and can be deleted at any time from the History screen.',
            ),
            _buildSection(
              context,
              'No Account Required',
              'You do not need to create an account or provide any personal information to use ColorSightTest. The app functions completely offline.',
            ),
            _buildSection(
              context,
              'Medical Disclaimer',
              'ColorSightTest is a screening tool and not a medical diagnostic device. Results should not be used for medical diagnosis. Always consult a qualified eye care professional for accurate assessment.',
            ),
            _buildSection(
              context,
              'Third-Party Services',
              'This app does not integrate with any third-party analytics, advertising, or tracking services. Your data remains private and secure on your device.',
            ),
            _buildSection(
              context,
              'Children\'s Privacy',
              'We do not knowingly collect information from children under 13. The app can be used by anyone but does not require or collect personal information.',
            ),
            _buildSection(
              context,
              'Changes to Policy',
              'We may update this privacy policy from time to time. Any changes will be reflected in app updates with version notes.',
            ),
            _buildSection(
              context,
              'Contact',
              'If you have questions about this privacy policy or the app, please contact us through the app store review page.',
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Text(
              'Last Updated: February 2026',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSmall),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}
