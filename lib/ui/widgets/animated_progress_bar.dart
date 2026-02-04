import 'package:flutter/material.dart';
import 'package:colorsighttest/core/theme/app_theme.dart';

class AnimatedProgressBar extends StatefulWidget {
  final int current;
  final int total;
  final double height;
  final Color? backgroundColor;
  final LinearGradient? gradient;

  const AnimatedProgressBar({
    super.key,
    required this.current,
    required this.total,
    this.height = 8.0,
    this.backgroundColor,
    this.gradient,
  });

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.current / widget.total,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.current != widget.current ||
        oldWidget.total != widget.total) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.current / widget.total,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${widget.current} of ${widget.total}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${((widget.current / widget.total) * 100).toInt()}%',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSmall),
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            color:
                widget.backgroundColor ??
                (isDark
                    ? AppTheme.darkSurface
                    : AppTheme.primaryColor.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _animation.value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: widget.gradient ?? AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(widget.height / 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
