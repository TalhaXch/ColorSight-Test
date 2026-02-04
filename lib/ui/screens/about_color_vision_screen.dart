import 'package:flutter/material.dart';
import 'package:colorsighttest/core/theme/app_theme.dart';
import 'package:colorsighttest/ui/widgets/custom_app_bar.dart';
import 'package:colorsighttest/ui/screens/color_vision_detail_screen.dart';

class AboutColorVisionScreen extends StatefulWidget {
  const AboutColorVisionScreen({super.key});

  @override
  State<AboutColorVisionScreen> createState() => _AboutColorVisionScreenState();
}

class _AboutColorVisionScreenState extends State<AboutColorVisionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _fadeAnimations;

  final List<ColorVisionTile> _tiles = [
    ColorVisionTile(
      icon: Icons.palette_rounded,
      iconColor: AppTheme.primaryColor,
      title: 'What is Color Blindness?',
      subtitle: 'Learn about color vision deficiency',
      description:
          'Color blindness (or color vision deficiency) is a condition where you can\'t see colors in the usual way. It\'s usually inherited and affects approximately 1 in 12 men and 1 in 200 women worldwide.',
      keyPoints: [
        'Affects 8% of men and 0.5% of women worldwide',
        'Usually inherited through genetics',
        'Caused by abnormal photoreceptor cells in the eye',
        'Not actually "blindness" - most can see colors, just differently',
        'Cannot be cured but people adapt well',
      ],
    ),
    ColorVisionTile(
      icon: Icons.remove_red_eye_rounded,
      iconColor: AppTheme.errorColor,
      title: 'Red-Green Color Blindness',
      subtitle: 'Most common type',
      description:
          'The most common type of color blindness. People with this condition have difficulty distinguishing between red and green colors. This includes Protanopia (no red cones) and Deuteranopia (no green cones).',
      keyPoints: [
        'Affects about 6% of males',
        'Red appears darker or brownish',
        'Green may look beige or gray',
        'Difficulty with traffic lights',
        'Two types: Protanopia and Deuteranopia',
      ],
    ),
    ColorVisionTile(
      icon: Icons.visibility_rounded,
      iconColor: AppTheme.infoColor,
      title: 'Blue-Yellow Color Blindness',
      subtitle: 'Less common type',
      description:
          'Less common than red-green. People with Tritanopia have difficulty distinguishing between blue and yellow, and sometimes red and pink.',
      keyPoints: [
        'Affects less than 1% of people',
        'Equally common in men and women',
        'Blue looks greenish',
        'Yellow may appear pink or gray',
        'Also called Tritanopia',
      ],
    ),
    ColorVisionTile(
      icon: Icons.blur_on_rounded,
      iconColor: AppTheme.lightTextSecondary,
      title: 'Total Color Blindness',
      subtitle: 'Very rare condition',
      description:
          'Very rare. People with Achromatopsia see only shades of gray. This is usually accompanied by other vision problems like light sensitivity.',
      keyPoints: [
        'Extremely rare - affects 1 in 30,000',
        'See only in shades of gray',
        'Often includes light sensitivity',
        'May have reduced visual acuity',
        'Also called Achromatopsia',
      ],
    ),
    ColorVisionTile(
      icon: Icons.science_rounded,
      iconColor: AppTheme.secondaryColor,
      title: 'How Color Vision Works',
      subtitle: 'Understanding the science',
      description:
          'Your eyes have special cells called cones that detect color. There are three types of cones: red-sensitive, green-sensitive, and blue-sensitive. They work together to create the full spectrum of colors you see.',
      keyPoints: [
        'Three types of cone cells in the retina',
        'Each type sensitive to different wavelengths',
        'Brain combines signals to perceive color',
        'Color blindness: one or more cone types malfunction',
        'Cone cells concentrated in the fovea (center of vision)',
      ],
    ),
    ColorVisionTile(
      icon: Icons.health_and_safety_rounded,
      iconColor: AppTheme.warningColor,
      title: 'Living with Color Blindness',
      subtitle: 'Adaptation and tools',
      description:
          'While there\'s no cure for most types of color blindness, people adapt remarkably well. Modern technology offers various tools and aids to help navigate a colorful world more easily.',
      keyPoints: [
        'Special glasses can enhance color discrimination',
        'Smartphone apps can identify colors',
        'Labeling and organizing by pattern',
        'Digital displays with accessibility modes',
        'Most people adapt without major issues',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimations = List.generate(
      _tiles.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            (index * 0.1).clamp(0.0, 1.0),
            ((index * 0.1) + 0.4).clamp(0.0, 1.0),
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToDetail(ColorVisionTile tile) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => ColorVisionDetailScreen(
              title: tile.title,
              description: tile.description,
              icon: tile.icon,
              iconColor: tile.iconColor,
              keyPoints: tile.keyPoints,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        title: 'Learn About Color Vision',
        showBackButton: false,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppTheme.spacingSmall,
          mainAxisSpacing: AppTheme.spacingSmall,
          childAspectRatio: 0.85,
        ),
        itemCount: _tiles.length,
        itemBuilder: (context, index) {
          final tile = _tiles[index];
          return FadeTransition(
            opacity: _fadeAnimations[index],
            child: _buildTile(tile),
          );
        },
      ),
    );
  }

  Widget _buildTile(ColorVisionTile tile) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = theme.colorScheme.surface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigateToDetail(tile),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cardColor,
                tile.iconColor.withOpacity(isDark ? 0.15 : 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: tile.iconColor.withOpacity(isDark ? 0.3 : 0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingSmall),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingSmall),
                  decoration: BoxDecoration(
                    color: tile.iconColor.withOpacity(isDark ? 0.2 : 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(tile.icon, size: 40, color: tile.iconColor),
                ),
                const SizedBox(height: AppTheme.spacingSmall),
                Text(
                  tile.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppTheme.spacingXSmall),
                Text(
                  tile.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppTheme.spacingXSmall),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                  color: tile.iconColor.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ColorVisionTile {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String description;
  final List<String> keyPoints;

  ColorVisionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.keyPoints,
  });
}
