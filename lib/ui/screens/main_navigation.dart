import 'package:flutter/material.dart';
import 'package:colorsighttest/core/theme/app_theme.dart';
import 'package:colorsighttest/ui/screens/instructions_screen.dart';
import 'package:colorsighttest/ui/screens/history_screen.dart';
import 'package:colorsighttest/ui/screens/about_color_vision_screen.dart';
import 'package:colorsighttest/ui/screens/settings_screen.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with TickerProviderStateMixin {
  late int _currentIndex;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<NavigationItem> _items = [
    NavigationItem(
      icon: Icons.remove_red_eye_rounded,
      label: 'Test',
      screen: const InstructionsScreen(),
    ),
    NavigationItem(
      icon: Icons.history_rounded,
      label: 'History',
      screen: const HistoryScreen(),
    ),
    NavigationItem(
      icon: Icons.school_rounded,
      label: 'Learn',
      screen: const AboutColorVisionScreen(),
    ),
    NavigationItem(
      icon: Icons.settings_rounded,
      label: 'Settings',
      screen: const SettingsScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      _animationController.reset();
      setState(() {
        _currentIndex = index;
      });
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _items[_currentIndex].screen,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppTheme.radiusLarge),
            topRight: Radius.circular(AppTheme.radiusLarge),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            selectedItemColor:
                theme.brightness == Brightness.light
                    ? AppTheme.primaryColor
                    : AppTheme.primaryLight,
            unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.4),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            type: BottomNavigationBarType.fixed,
            items:
                _items.map((item) {
                  final isSelected = _items.indexOf(item) == _currentIndex;
                  return BottomNavigationBarItem(
                    icon: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient:
                            isSelected
                                ? LinearGradient(
                                  colors: [
                                    (theme.brightness == Brightness.light
                                            ? AppTheme.primaryColor
                                            : AppTheme.primaryLight)
                                        .withOpacity(0.15),
                                    (theme.brightness == Brightness.light
                                            ? AppTheme.primaryColor
                                            : AppTheme.primaryLight)
                                        .withOpacity(0.05),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                                : null,
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusSmall,
                        ),
                      ),
                      child: Icon(item.icon, size: 24),
                    ),
                    label: item.label,
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final Widget screen;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.screen,
  });
}
