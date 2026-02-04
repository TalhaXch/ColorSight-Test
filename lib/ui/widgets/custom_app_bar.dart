import 'package:flutter/material.dart';
import 'package:colorsighttest/core/theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(title),
      centerTitle: true,
      leading:
          leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded),
                onPressed: onBackPressed ?? () => Navigator.pop(context),
              )
              : null),
      actions: actions,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                theme.brightness == Brightness.light
                    ? [
                      AppTheme.lightBackground,
                      AppTheme.lightBackground.withOpacity(0.8),
                    ]
                    : [
                      AppTheme.darkBackground,
                      AppTheme.darkBackground.withOpacity(0.8),
                    ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
