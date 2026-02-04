import 'package:colorsighttest/data/models/vision_type.dart';

class TestState {
  final int currentPlateIndex;
  final Map<int, String> userAnswers;
  final bool isTestComplete;
  final VisionType? detectedVisionType;
  final int correctAnswers;

  const TestState({
    this.currentPlateIndex = 0,
    this.userAnswers = const {},
    this.isTestComplete = false,
    this.detectedVisionType,
    this.correctAnswers = 0,
  });

  TestState copyWith({
    int? currentPlateIndex,
    Map<int, String>? userAnswers,
    bool? isTestComplete,
    VisionType? detectedVisionType,
    int? correctAnswers,
  }) {
    return TestState(
      currentPlateIndex: currentPlateIndex ?? this.currentPlateIndex,
      userAnswers: userAnswers ?? this.userAnswers,
      isTestComplete: isTestComplete ?? this.isTestComplete,
      detectedVisionType: detectedVisionType ?? this.detectedVisionType,
      correctAnswers: correctAnswers ?? this.correctAnswers,
    );
  }

  double get progress => currentPlateIndex / 12;
}
