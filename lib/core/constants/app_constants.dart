class AppConstants {
  // App Information
  static const String appName = 'ColorSightTest';
  static const String appVersion = '1.0.0';

  // Test Configuration
  static const int totalTestPlates = 12;
  static const int passingScore = 8;

  // Timing
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration plateTransitionDuration = Duration(milliseconds: 300);

  // Disclaimer Text
  static const String disclaimer =
      'This test is for informational purposes only and is not a medical diagnosis. '
      'Please consult an eye care professional for accurate color vision testing.';

  // Storage Keys
  static const String testHistoryBox = 'test_history';

  // Routes
  static const String splashRoute = '/';
  static const String instructionsRoute = '/instructions';
  static const String testRoute = '/test';
  static const String resultRoute = '/result';
  static const String historyRoute = '/history';
}
