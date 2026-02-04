import 'package:flutter/material.dart';
import 'package:colorsighttest/core/theme/app_theme.dart';

class GradientCard extends StatelessWidget {
  final Widget child;
  final LinearGradient? gradient;
  final Color? color;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;

  const GradientCard({
    super.key,
    required this.child,
    this.gradient,
    this.color,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.borderRadius = AppTheme.radiusMedium,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient,
        color: color ?? (isDark ? AppTheme.darkCardColor : Colors.white),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow ?? AppTheme.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppTheme.spacingMedium),
            child: child,
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.iconColor = AppTheme.primaryColor,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GradientCard(
      onTap: onTap,
      color: backgroundColor,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  iconColor.withOpacity(0.2),
                  iconColor.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: AppTheme.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleLarge),
                const SizedBox(height: AppTheme.spacingXSmall),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
    );
  }
}
