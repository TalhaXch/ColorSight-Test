import 'package:flutter/material.dart';
import 'package:colorsighttest/core/theme/app_theme.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final EdgeInsets? padding;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.padding,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width,
          decoration: BoxDecoration(
            gradient:
                !widget.isOutlined && !isDisabled
                    ? LinearGradient(
                      colors:
                          widget.backgroundColor != null
                              ? [
                                widget.backgroundColor!,
                                widget.backgroundColor!,
                              ]
                              : [AppTheme.primaryColor, AppTheme.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : null,
            color:
                widget.isOutlined
                    ? Colors.transparent
                    : (isDisabled
                        ? Colors.grey.shade300
                        : widget.backgroundColor),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border:
                widget.isOutlined
                    ? Border.all(
                      color:
                          isDisabled
                              ? Colors.grey.shade300
                              : widget.backgroundColor ?? AppTheme.primaryColor,
                      width: 2,
                    )
                    : null,
            boxShadow:
                !widget.isOutlined && !isDisabled
                    ? [
                      BoxShadow(
                        color: (widget.backgroundColor ?? AppTheme.primaryColor)
                            .withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isDisabled ? null : widget.onPressed,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              child: Padding(
                padding:
                    widget.padding ??
                    const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingLarge,
                      vertical: AppTheme.spacingMedium,
                    ),
                child:
                    widget.isLoading
                        ? Center(
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                widget.isOutlined
                                    ? (widget.textColor ??
                                        AppTheme.primaryColor)
                                    : Colors.white,
                              ),
                            ),
                          ),
                        )
                        : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(
                                widget.icon,
                                size: 20,
                                color:
                                    widget.isOutlined
                                        ? (widget.textColor ??
                                            widget.backgroundColor ??
                                            AppTheme.primaryColor)
                                        : (widget.textColor ?? Colors.white),
                              ),
                              const SizedBox(width: AppTheme.spacingSmall),
                            ],
                            Text(
                              widget.text,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color:
                                    widget.isOutlined
                                        ? (widget.textColor ??
                                            widget.backgroundColor ??
                                            AppTheme.primaryColor)
                                        : (widget.textColor ?? Colors.white),
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
