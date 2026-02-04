import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:colorsighttest/core/theme/app_theme.dart';
import 'package:colorsighttest/ui/widgets/custom_app_bar.dart';
import 'package:colorsighttest/ui/widgets/gradient_card.dart';
import 'package:colorsighttest/ui/screens/privacy_policy_screen.dart';
import 'package:colorsighttest/ui/screens/terms_of_service_screen.dart';
import 'package:colorsighttest/core/services/preferences_service.dart';

// Settings Providers with persistence
final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  throw UnimplementedError('PreferencesService must be overridden');
});

final largeTextProvider = StateNotifierProvider<SettingNotifier, bool>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  return SettingNotifier(prefs.largeText, (value) => prefs.setLargeText(value));
});

final highContrastProvider = StateNotifierProvider<SettingNotifier, bool>((
  ref,
) {
  final prefs = ref.watch(preferencesServiceProvider);
  return SettingNotifier(
    prefs.highContrast,
    (value) => prefs.setHighContrast(value),
  );
});

final reduceAnimationsProvider = StateNotifierProvider<SettingNotifier, bool>((
  ref,
) {
  final prefs = ref.watch(preferencesServiceProvider);
  return SettingNotifier(
    prefs.reduceAnimations,
    (value) => prefs.setReduceAnimations(value),
  );
});

final darkModeProvider = StateNotifierProvider<SettingNotifier, bool>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  return SettingNotifier(prefs.darkMode, (value) => prefs.setDarkMode(value));
});

// StateNotifier for settings with persistence
class SettingNotifier extends StateNotifier<bool> {
  final Future<void> Function(bool) _onChanged;

  SettingNotifier(bool initialValue, this._onChanged) : super(initialValue);

  void toggle() {
    state = !state;
    _onChanged(state);
  }

  void setValue(bool value) {
    state = value;
    _onChanged(value);
  }
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
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
    final largeText = ref.watch(largeTextProvider);
    final highContrast = ref.watch(highContrastProvider);
    final reduceAnimations = ref.watch(reduceAnimationsProvider);
    final darkMode = ref.watch(darkModeProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings', showBackButton: false),
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ListView(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            children: [
              // Header
              GradientCard(
                gradient: AppTheme.primaryGradient,
                padding: const EdgeInsets.all(AppTheme.spacingLarge),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.settings_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Accessibility',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingXSmall),
                          Text(
                            'Customize your experience',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spacingLarge),

              // Accessibility Settings Section
              _buildSectionTitle(context, 'Accessibility Features'),
              const SizedBox(height: AppTheme.spacingSmall),

              GradientCard(
                child: Column(
                  children: [
                    _buildSettingTile(
                      context,
                      icon: Icons.text_fields_rounded,
                      title: 'Large Text',
                      subtitle: 'Increase text size throughout the app',
                      value: largeText,
                      onChanged: (value) {
                        ref.read(largeTextProvider.notifier).setValue(value);
                      },
                    ),
                    _buildDivider(context),
                    _buildSettingTile(
                      context,
                      icon: Icons.contrast_rounded,
                      title: 'High Contrast',
                      subtitle: 'Enhance visibility with stronger colors',
                      value: highContrast,
                      onChanged: (value) {
                        ref.read(highContrastProvider.notifier).setValue(value);
                      },
                    ),
                    _buildDivider(context),
                    _buildSettingTile(
                      context,
                      icon: Icons.animation_rounded,
                      title: 'Reduce Animations',
                      subtitle: 'Minimize motion for better focus',
                      value: reduceAnimations,
                      onChanged: (value) {
                        ref
                            .read(reduceAnimationsProvider.notifier)
                            .setValue(value);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spacingLarge),

              // Appearance Section
              _buildSectionTitle(context, 'Appearance'),
              const SizedBox(height: AppTheme.spacingSmall),

              GradientCard(
                child: _buildSettingTile(
                  context,
                  icon: Icons.dark_mode_rounded,
                  title: 'Dark Mode',
                  subtitle: 'Easier on the eyes in low light',
                  value: darkMode,
                  onChanged: (value) {
                    ref.read(darkModeProvider.notifier).setValue(value);
                  },
                ),
              ),

              const SizedBox(height: AppTheme.spacingLarge),

              // About Section
              _buildSectionTitle(context, 'About'),
              const SizedBox(height: AppTheme.spacingSmall),

              GradientCard(
                child: Column(
                  children: [
                    _buildInfoTile(
                      context,
                      icon: Icons.info_outline_rounded,
                      title: 'App Version',
                      subtitle: '1.0.0',
                    ),
                    _buildDivider(context),
                    _buildInfoTile(
                      context,
                      icon: Icons.privacy_tip_rounded,
                      title: 'Privacy Policy',
                      subtitle: 'How we protect your data',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(context),
                    _buildInfoTile(
                      context,
                      icon: Icons.description_rounded,
                      title: 'Terms of Service',
                      subtitle: 'User agreement and terms',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TermsOfServiceScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spacingLarge),

              // Disclaimer
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
                      size: 20,
                    ),
                    const SizedBox(width: AppTheme.spacingSmall),
                    Expanded(
                      child: Text(
                        'This app is for screening purposes only and does not replace professional medical advice. Consult an eye care specialist for diagnosis.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
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
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXSmall),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingXSmall),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.15),
                  AppTheme.primaryColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 24),
          ),
          const SizedBox(width: AppTheme.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXSmall / 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSmall),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                size: 24,
              ),
            ),
            const SizedBox(width: AppTheme.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXSmall / 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final theme = Theme.of(context);
    return Divider(
      height: 1,
      thickness: 1,
      color: theme.colorScheme.onSurface.withOpacity(0.08),
    );
  }
}
