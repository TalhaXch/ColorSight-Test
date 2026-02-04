import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyOnboardingComplete = 'onboarding_complete';
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyHighContrast = 'high_contrast';
  static const String _keyLargeText = 'large_text';
  static const String _keyReduceAnimations = 'reduce_animations';

  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  static Future<PreferencesService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  // Onboarding
  bool get hasCompletedOnboarding =>
      _prefs.getBool(_keyOnboardingComplete) ?? false;

  Future<void> setOnboardingComplete(bool value) async {
    await _prefs.setBool(_keyOnboardingComplete, value);
  }

  // Dark Mode
  bool get darkMode => _prefs.getBool(_keyDarkMode) ?? false;

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(_keyDarkMode, value);
  }

  // High Contrast
  bool get highContrast => _prefs.getBool(_keyHighContrast) ?? false;

  Future<void> setHighContrast(bool value) async {
    await _prefs.setBool(_keyHighContrast, value);
  }

  // Large Text
  bool get largeText => _prefs.getBool(_keyLargeText) ?? false;

  Future<void> setLargeText(bool value) async {
    await _prefs.setBool(_keyLargeText, value);
  }

  // Reduce Animations
  bool get reduceAnimations => _prefs.getBool(_keyReduceAnimations) ?? false;

  Future<void> setReduceAnimations(bool value) async {
    await _prefs.setBool(_keyReduceAnimations, value);
  }
}
