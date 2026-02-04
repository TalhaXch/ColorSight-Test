# ColorSightTest - Development Guide

## Quick Start Commands

### Initial Setup
```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Run with specific device
flutter run -d chrome
flutter run -d emulator-5554
```

### Development Commands
```bash
# Format code
dart format lib/

# Analyze code
flutter analyze

# Run tests
flutter test

# Clean build
flutter clean
flutter pub get
```

## Project Structure Explained

### `/lib/core/`
Contains app-wide utilities, constants, and theme configuration.

- `constants/app_constants.dart` - All app constants in one place
- `theme/app_theme.dart` - Light and dark theme definitions
- `utils/helpers.dart` - Helper functions for formatting, calculations, etc.

### `/lib/data/`
Data layer - models, repositories, and static data.

- `models/` - Data models with Hive adapters for persistence
- `repositories/` - Data access layer (Hive operations)
- `plate_data.dart` - Test plate definitions

### `/lib/logic/`
Business logic layer - controllers and state management.

- `test_controller.dart` - Riverpod state notifier for test flow
- `test_state.dart` - Immutable state class for test data

### `/lib/ui/`
Presentation layer - screens and widgets.

- `screens/` - Full-screen pages
- `widgets/` - Reusable UI components

## State Management Pattern

This app uses **Riverpod** for state management:

```dart
// 1. Define a provider
final testStateProvider = StateNotifierProvider<TestController, TestState>((ref) {
  final repository = ref.watch(testRepositoryProvider);
  return TestController(repository);
});

// 2. Watch in widgets
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(testStateProvider);
    // Use state...
  }
}

// 3. Update state
ref.read(testStateProvider.notifier).submitAnswer(answer);
```

## Adding New Test Plates

1. Add image to `assets/images/plates/`
2. Update `lib/data/plate_data.dart`:

```dart
const ColorPlate(
  id: 13,
  imageAsset: 'assets/images/plates/plate_13.png',
  correctAnswer: '42',
  options: ['42', '24', '44', "I can't see anything"],
  normalVisionSees: VisionType.normal,
  deficiencyVisionSees: VisionType.redGreen,
  description: 'Test plate description',
),
```

3. Update `AppConstants.totalTestPlates` if needed

## Customizing Themes

Edit `lib/core/theme/app_theme.dart`:

```dart
// Change primary color
static const Color primaryColor = Color(0xFF2E7D32);

// Modify text theme
textTheme: GoogleFonts.robotoTextTheme(),

// Update button styles
elevatedButtonTheme: ElevatedButtonThemeData(...)
```

## Working with Hive Database

### View stored data:
```dart
// In main.dart or any widget
final box = Hive.box<TestResult>('test_history');
print(box.values.toList());
```

### Clear database (for testing):
```dart
await Hive.box('test_history').clear();
```

### Regenerate adapters (if you modify models):
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Common Tasks

### Change App Name
1. Edit `lib/core/constants/app_constants.dart`
2. Update `android/app/src/main/AndroidManifest.xml`
3. Update `ios/Runner/Info.plist`

### Modify Test Logic
Edit `lib/logic/test_controller.dart`:
- `_determineVisionType()` - Algorithm for result analysis
- `submitAnswer()` - Answer processing logic

### Add New Screen
1. Create file in `lib/ui/screens/`
2. Add route in `lib/core/constants/app_constants.dart`
3. Navigate: `Navigator.push(context, MaterialPageRoute(...))`

### Add New Widget
1. Create file in `lib/ui/widgets/`
2. Make it a `StatelessWidget` or `ConsumerWidget`
3. Import and use in screens

## Debugging Tips

### Enable Debug Mode
```dart
// In main.dart
debugPrint('Current state: $state');
```

### Check Riverpod State
```dart
// Add logging in controller
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  super.debugFillProperties(properties);
  properties.add(DiagnosticsProperty('state', state));
}
```

### View Hive Database Location
```dart
print(Hive.box('test_history').path);
```

## Performance Optimization

### Image Loading
- Use `CachedNetworkImage` for remote images
- Compress images to 800x800 max
- Use PNG format with optimization

### State Management
- Use `select` to watch specific properties
- Avoid rebuilding entire widget trees
- Use `const` constructors where possible

### Build Optimization
```bash
# Analyze bundle size
flutter build apk --analyze-size

# Enable obfuscation
flutter build apk --obfuscate --split-debug-info=build/app/outputs/symbols
```

## Testing Strategy

### Unit Tests
Test business logic in isolation:
```dart
// test/logic/test_controller_test.dart
test('should calculate correct vision type', () {
  // Test logic
});
```

### Widget Tests
Test UI components:
```dart
// test/ui/widgets/answer_option_test.dart
testWidgets('shows selected state', (tester) async {
  // Test widget
});
```

### Integration Tests
Test full user flows:
```bash
flutter drive --target=test_driver/app.dart
```

## Deployment Checklist

- [ ] Update version in `pubspec.yaml`
- [ ] Test on multiple devices (Android & iOS)
- [ ] Verify all images load correctly
- [ ] Check accessibility features
- [ ] Review legal disclaimers
- [ ] Test offline functionality
- [ ] Verify data persistence
- [ ] Check dark mode appearance
- [ ] Test different screen sizes
- [ ] Run `flutter analyze` (no errors)
- [ ] Run `flutter test` (all pass)
- [ ] Update README with latest features
- [ ] Create release notes

## Troubleshooting

### "Hive box not open" Error
```dart
// Ensure Hive is initialized before use
await Hive.initFlutter();
await Hive.openBox<TestResult>('test_history');
```

### Provider Not Found Error
```dart
// Wrap app with ProviderScope
runApp(ProviderScope(child: MyApp()));
```

### Image Not Found
1. Check file path in `pubspec.yaml`
2. Run `flutter pub get`
3. Restart app
4. Check file exists in `assets/images/plates/`

### Build Errors
```bash
flutter clean
flutter pub get
flutter run
```

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Hive Documentation](https://docs.hivedb.dev/)
- [Material Design 3](https://m3.material.io/)

## Support

For issues and questions:
1. Check this guide
2. Search existing issues
3. Create new issue with details
4. Include error messages and screenshots
