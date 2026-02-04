# ColorSightTest 👁️

A production-ready Flutter application for color vision screening using Ishihara-style color plate tests.

## 🎯 Overview

ColorSightTest is a professional visual screening app that helps users identify potential color vision deficiencies. The app presents users with a series of color plates and analyzes their responses to provide insights about their color perception abilities.

**Important:** This application is for informational and educational purposes only. It is NOT a medical diagnosis tool and should not replace professional eye care consultation.

## ✨ Features

### Core Functionality
- **Interactive Color Plate Tests**: 12 carefully designed test plates
- **Multiple Choice Answers**: Easy-to-use answer selection
- **Progress Tracking**: Visual progress indicator during tests
- **Intelligent Analysis**: Automatic detection of color vision patterns
- **Result Categorization**:
  - Normal color vision
  - Possible red-green deficiency
  - Possible blue-yellow deficiency
  - Possible total color blindness

### Additional Features
- **Test History**: Local storage of all past test results
- **Detailed Results**: Comprehensive analysis with explanations
- **Dark Mode**: Full support for light and dark themes
- **Professional UI**: Clean, medical-style interface
- **Smooth Animations**: Polished user experience
- **Haptic Feedback**: Enhanced interactivity

## 🏗️ Architecture

The app follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                   # Core functionality
│   ├── constants/         # App constants
│   ├── theme/            # Theme configuration
│   └── utils/            # Helper utilities
├── data/                  # Data layer
│   ├── models/           # Data models (VisionType, ColorPlate, TestResult)
│   ├── repositories/     # Data persistence (Hive)
│   └── plate_data.dart   # Test plate definitions
├── logic/                 # Business logic layer
│   ├── test_controller.dart  # Test flow controller (Riverpod)
│   └── test_state.dart       # Test state management
└── ui/                    # Presentation layer
    ├── screens/          # App screens
    └── widgets/          # Reusable UI components
```

## 📱 Screens

1. **Splash Screen**: Animated welcome screen
2. **Instructions Screen**: Test guidelines and tips
3. **Test Screen**: Interactive color plate test interface
4. **Result Screen**: Detailed analysis and recommendations
5. **History Screen**: Past test results with statistics

## 🛠️ Technology Stack

- **Framework**: Flutter 3.7.2+
- **State Management**: Riverpod 2.4.10
- **Local Storage**: Hive 2.2.3
- **Fonts**: Google Fonts (Inter)
- **Architecture**: Clean Architecture
- **Platform Support**: Android, iOS, Web

### Key Dependencies
```yaml
flutter_riverpod: ^2.4.10    # State management
hive: ^2.2.3                  # Local database
hive_flutter: ^1.1.0          # Hive Flutter integration
google_fonts: ^6.1.0          # Custom fonts
intl: ^0.19.0                 # Internationalization
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.7.2 or higher
- Dart SDK 3.7.2 or higher
- Android Studio / VS Code
- An emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd colorsighttest
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Add test plate images** (Important!)
   - Navigate to `assets/images/plates/`
   - Add 12 color plate images named `plate_01.png` through `plate_12.png`
   - See `assets/images/plates/README.md` for detailed instructions

4. **Run the app**
   ```bash
   flutter run
   ```

## 🖼️ Image Assets

The app requires 12 color plate images. Due to copyright restrictions, these are **not included** in the repository.

**Options:**
1. Use placeholder images for development
2. Create custom test plates
3. Purchase licensed Ishihara test plates
4. Use public domain alternatives

See `assets/images/plates/README.md` for complete details.

## 📊 Data Models

### VisionType Enum
```dart
enum VisionType {
  normal,        // Normal color vision
  redGreen,      // Red-green deficiency
  blueYellow,    // Blue-yellow deficiency
  total          // Total color blindness
}
```

### ColorPlate Model
```dart
class ColorPlate {
  final int id;
  final String imageAsset;
  final String correctAnswer;
  final List<String> options;
  final VisionType normalVisionSees;
  final VisionType? deficiencyVisionSees;
  final String description;
}
```

### TestResult Model
```dart
class TestResult {
  final DateTime date;
  final VisionType detectedType;
  final int correctAnswers;
  final int totalQuestions;
  final Map<int, String> userAnswers;
}
```

## 🎨 Theming

The app supports both light and dark themes with a professional medical aesthetic:

- **Primary Color**: Medical Green (#2E7D32)
- **Secondary Color**: Blue (#1976D2)
- **Fonts**: Inter (Google Fonts)
- **Design**: Material Design 3

## 💾 Data Persistence

- **Storage**: Hive (local NoSQL database)
- **Data**: Test results stored locally on device
- **Privacy**: No cloud storage, all data stays on device

## 🧪 Testing

Run tests with:
```bash
flutter test
```

## 🔨 Build for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 📝 Code Structure Best Practices

- ✅ Clean Architecture with clear layer separation
- ✅ Riverpod for scalable state management
- ✅ No business logic in UI widgets
- ✅ Reusable component library
- ✅ Type-safe models with Hive adapters
- ✅ Comprehensive error handling
- ✅ Responsive design
- ✅ Accessibility considerations

## ⚠️ Legal & Medical Disclaimer

**IMPORTANT NOTICE:**

1. This app is for **informational purposes only**
2. It is **NOT a medical diagnosis tool**
3. Results should **NOT** be used for medical decisions
4. Users should **consult an eye care professional** for accurate color vision testing
5. Ishihara test plates are copyrighted - ensure proper licensing for production use

## 🤝 Contributing

Contributions are welcome! Please ensure:
- Code follows the existing architecture
- All new features include documentation
- Tests are added for new functionality
- Code is formatted with `dart format`

## 📄 License

This project is created for educational and demonstration purposes. Ensure you have proper licensing for any color plate images used in production.

## 👨‍💻 Developer

Built with ❤️ using Flutter

## 📞 Support

For questions, issues, or feature requests, please open an issue in the repository.

---

**Note**: Before deploying this app to production, ensure you have:
- [ ] Licensed or created proper test plate images
- [ ] Reviewed and customized legal disclaimers
- [ ] Tested thoroughly on multiple devices
- [ ] Reviewed accessibility features
- [ ] Completed security audit
- [ ] Added proper privacy policy

## 🎓 Learning Resources

This project demonstrates:
- Clean Architecture in Flutter
- Riverpod state management patterns
- Hive local database integration
- Material Design 3 theming
- Navigation patterns
- Animation implementation
- Form handling and validation
