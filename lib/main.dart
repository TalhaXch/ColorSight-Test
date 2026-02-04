import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:colorsighttest/core/theme/app_theme.dart';
import 'package:colorsighttest/data/repositories/test_repository.dart';
import 'package:colorsighttest/ui/screens/splash_screen.dart';
import 'package:colorsighttest/ui/screens/settings_screen.dart';
import 'package:colorsighttest/core/services/preferences_service.dart';
import 'package:colorsighttest/logic/test_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize test repository (Hive)
  final testRepository = TestRepository();
  await testRepository.init();

  // Initialize preferences service
  final preferencesService = await PreferencesService.init();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ProviderScope(
      overrides: [
        preferencesServiceProvider.overrideWithValue(preferencesService),
        testRepositoryProvider.overrideWithValue(testRepository),
      ],
      child: const ColorSightTestApp(),
    ),
  );
}

class ColorSightTestApp extends ConsumerWidget {
  const ColorSightTestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);
    final largeText = ref.watch(largeTextProvider);
    final highContrast = ref.watch(highContrastProvider);

    return MaterialApp(
      title: 'ColorSightTest',
      debugShowCheckedModeBanner: false,
      theme:
          highContrast ? AppTheme.highContrastLightTheme : AppTheme.lightTheme,
      darkTheme:
          highContrast ? AppTheme.highContrastDarkTheme : AppTheme.darkTheme,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
      builder: (context, child) {
        // Apply text scaling for large text setting
        if (largeText) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.3)),
            child: child!,
          );
        }
        return child!;
      },
    );
  }
}
