import 'package:flutter/material.dart';
import 'package:colorsighttest/core/theme/app_theme.dart';
import 'package:colorsighttest/ui/widgets/custom_app_bar.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Terms of Service'),
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
              'Acceptance of Terms',
              'By downloading, installing, or using ColorSightTest, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the app.',
            ),
            _buildSection(
              context,
              'Use License',
              'ColorSightTest grants you a personal, non-commercial, non-transferable license to use the app for color vision screening purposes. You may not modify, distribute, or reverse engineer the app.',
            ),
            _buildSection(
              context,
              'Medical Disclaimer',
              'IMPORTANT: ColorSightTest is a screening tool only and NOT a medical device. It does not diagnose medical conditions. Results are for informational purposes only. Always consult a qualified eye care professional (optometrist or ophthalmologist) for proper diagnosis and treatment.',
            ),
            _buildSection(
              context,
              'Accuracy and Limitations',
              'While we strive for accuracy, ColorSightTest results may be affected by screen calibration, lighting conditions, and device settings. The app is not a substitute for professional medical testing with calibrated equipment.',
            ),
            _buildSection(
              context,
              'No Warranty',
              'The app is provided "as is" without warranties of any kind, either express or implied. We do not warrant that the app will be error-free, uninterrupted, or suitable for your specific needs.',
            ),
            _buildSection(
              context,
              'Limitation of Liability',
              'ColorSightTest and its developers shall not be liable for any damages arising from use or inability to use the app. This includes, but is not limited to, damages for medical misdiagnosis or delayed treatment.',
            ),
            _buildSection(
              context,
              'User Responsibilities',
              'You are responsible for:\n• Using the app in good lighting conditions\n• Seeking professional medical advice for diagnosis\n• Understanding the app\'s limitations\n• Not relying solely on app results for medical decisions',
            ),
            _buildSection(
              context,
              'Age Restrictions',
              'This app is intended for users of all ages but requires understanding of basic instructions. Parental guidance is recommended for children.',
            ),
            _buildSection(
              context,
              'Modifications to Service',
              'We reserve the right to modify, suspend, or discontinue the app at any time without notice. We may also update these terms periodically.',
            ),
            _buildSection(
              context,
              'Governing Law',
              'These terms shall be governed by and construed in accordance with applicable laws. Any disputes shall be resolved in appropriate courts.',
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              decoration: BoxDecoration(
                color: AppTheme.warningColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: AppTheme.warningColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppTheme.warningColor,
                    size: 24,
                  ),
                  const SizedBox(width: AppTheme.spacingSmall),
                  Expanded(
                    child: Text(
                      'By using ColorSightTest, you acknowledge that you have read, understood, and agree to these Terms of Service.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
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
