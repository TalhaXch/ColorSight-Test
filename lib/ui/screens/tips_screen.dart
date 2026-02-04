import 'package:flutter/material.dart';
import 'package:colorsighttest/core/theme/app_theme.dart';
import 'package:colorsighttest/data/models/vision_type.dart';
import 'package:colorsighttest/ui/widgets/custom_app_bar.dart';
import 'package:colorsighttest/ui/widgets/gradient_card.dart';

class TipsScreen extends StatefulWidget {
  final VisionType visionType;

  const TipsScreen({super.key, required this.visionType});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<TipItem> _getTipsForVisionType() {
    final List<TipItem> generalTips = [
      TipItem(
        icon: Icons.medical_services_rounded,
        iconColor: AppTheme.primaryColor,
        title: 'Consult an Eye Care Professional',
        description:
            'See an optometrist or ophthalmologist for a comprehensive eye exam to confirm results and discuss your specific needs.',
      ),
      TipItem(
        icon: Icons.phone_iphone_rounded,
        iconColor: AppTheme.infoColor,
        title: 'Use Accessibility Features',
        description:
            'Enable color filters, high contrast mode, and other accessibility features on your devices to improve visibility.',
      ),
      TipItem(
        icon: Icons.group_rounded,
        iconColor: AppTheme.secondaryColor,
        title: 'Inform Others',
        description:
            'Let teachers, employers, and family know about your color vision so they can accommodate your needs when necessary.',
      ),
    ];

    if (widget.visionType == VisionType.normal) {
      return [
        TipItem(
          icon: Icons.check_circle_rounded,
          iconColor: AppTheme.successColor,
          title: 'Your Color Vision is Normal',
          description:
              'Great news! Your test results suggest normal color vision. Continue regular eye checkups to maintain eye health.',
        ),
        TipItem(
          icon: Icons.visibility_rounded,
          iconColor: AppTheme.primaryColor,
          title: 'Protect Your Eyes',
          description:
              'Wear UV-protective sunglasses, take breaks from screens, and maintain a healthy diet rich in vitamins A, C, and E.',
        ),
        TipItem(
          icon: Icons.calendar_today_rounded,
          iconColor: AppTheme.infoColor,
          title: 'Regular Checkups',
          description:
              'Have your eyes examined by a professional at least once every two years, or more often if recommended.',
        ),
      ];
    }

    final specificTips = <TipItem>[
      TipItem(
        icon: Icons.palette_rounded,
        iconColor: AppTheme.warningColor,
        title: 'Color Labeling',
        description:
            'Label colored items (like clothes or cables) or organize them by texture or pattern to make identification easier.',
      ),
      TipItem(
        icon: Icons.remove_red_eye_rounded,
        iconColor: AppTheme.accentColor,
        title: 'Assistive Technology',
        description:
            'Use color identification apps that can name colors through your phone\'s camera, making daily tasks easier.',
      ),
    ];

    if (widget.visionType == VisionType.redGreen ||
        widget.visionType == VisionType.blueYellow) {
      specificTips.add(
        TipItem(
          icon: Icons.emoji_objects_rounded,
          iconColor: AppTheme.primaryLight,
          title: 'Adaptive Strategies',
          description:
              'Learn to identify objects by brightness, position, or context rather than relying solely on color.',
        ),
      );
    }

    return [...generalTips, ...specificTips];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tips = _getTipsForVisionType();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Tips & Recommendations'),
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
          child: SlideTransition(
            position: _slideAnimation,
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              children: [
                // Header Card
                GradientCard(
                  gradient: _getGradientForVisionType(),
                  padding: const EdgeInsets.all(AppTheme.spacingLarge),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.tips_and_updates_rounded,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingMedium),
                      Text(
                        'Personalized Tips',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingSmall),
                      Text(
                        'Based on ${widget.visionType.displayName}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppTheme.spacingLarge),

                // Tips List
                ...tips.map((tip) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppTheme.spacingMedium,
                    ),
                    child: InfoCard(
                      icon: tip.icon,
                      title: tip.title,
                      description: tip.description,
                      iconColor: tip.iconColor,
                    ),
                  );
                }),

                const SizedBox(height: AppTheme.spacingMedium),

                // Action Buttons
                GradientCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Take Action',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingSmall),
                      Text(
                        'Here are some immediate steps you can take:',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppTheme.spacingMedium),
                      _buildActionItem(
                        context,
                        Icons.local_hospital_rounded,
                        'Find an Eye Doctor',
                        'Locate specialists near you',
                      ),
                      const SizedBox(height: AppTheme.spacingSmall),
                      _buildActionItem(
                        context,
                        Icons.settings_rounded,
                        'Accessibility Settings',
                        'Configure device settings',
                      ),
                      const SizedBox(height: AppTheme.spacingSmall),
                      _buildActionItem(
                        context,
                        Icons.share_rounded,
                        'Share Results',
                        'Send to your doctor or family',
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

  Widget _buildActionItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingSmall),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: AppTheme.spacingSmall),
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
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  LinearGradient _getGradientForVisionType() {
    switch (widget.visionType) {
      case VisionType.normal:
        return AppTheme.secondaryGradient;
      case VisionType.redGreen:
        return const LinearGradient(
          colors: [Color(0xFFEF5350), Color(0xFFE57373)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case VisionType.blueYellow:
        return const LinearGradient(
          colors: [Color(0xFF42A5F5), Color(0xFF64B5F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case VisionType.total:
        return const LinearGradient(
          colors: [Color(0xFF78909C), Color(0xFF90A4AE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
}

class TipItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  TipItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });
}
