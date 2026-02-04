import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:colorsighttest/data/models/color_plate.dart';
import 'package:colorsighttest/data/models/test_result.dart';
import 'package:colorsighttest/data/models/vision_type.dart';
import 'package:colorsighttest/data/plate_data.dart';
import 'package:colorsighttest/data/repositories/test_repository.dart';
import 'package:colorsighttest/logic/test_state.dart';

/// Provider for the test repository
final testRepositoryProvider = Provider<TestRepository>((ref) {
  return TestRepository();
});

/// Provider for test state
final testStateProvider = StateNotifierProvider<TestController, TestState>((
  ref,
) {
  final repository = ref.watch(testRepositoryProvider);
  return TestController(repository);
});

/// Provider to trigger history refresh
final historyRefreshProvider = StateProvider<int>((ref) => 0);

/// Provider for test history
final testHistoryProvider = Provider<List<TestResult>>((ref) {
  // Watch refresh trigger to rebuild when history changes
  ref.watch(historyRefreshProvider);
  final repository = ref.watch(testRepositoryProvider);
  return repository.getAllResults();
});

class TestController extends StateNotifier<TestState> {
  final TestRepository _repository;

  TestController(this._repository) : super(const TestState());

  /// Start a new test
  void startTest() {
    state = const TestState();
  }

  /// Get the current plate
  ColorPlate? getCurrentPlate() {
    if (state.currentPlateIndex >= PlateData.totalPlates) {
      return null;
    }
    return PlateData.plates[state.currentPlateIndex];
  }

  /// Submit an answer and move to next plate
  Future<void> submitAnswer(String answer) async {
    final currentPlate = getCurrentPlate();
    if (currentPlate == null) return;

    // Store the answer
    final updatedAnswers = Map<int, String>.from(state.userAnswers);
    updatedAnswers[currentPlate.id] = answer;

    // Check if answer is correct
    int correctCount = state.correctAnswers;
    if (answer == currentPlate.correctAnswer) {
      correctCount++;
    }

    // Move to next plate or finish test
    final nextIndex = state.currentPlateIndex + 1;
    final isComplete = nextIndex >= PlateData.totalPlates;

    state = state.copyWith(
      currentPlateIndex: nextIndex,
      userAnswers: updatedAnswers,
      correctAnswers: correctCount,
      isTestComplete: isComplete,
    );

    // If test is complete, analyze results
    if (isComplete) {
      await _analyzeResults();
    }
  }

  /// Analyze test results and determine vision type
  Future<void> _analyzeResults() async {
    final visionType = _determineVisionType();

    state = state.copyWith(detectedVisionType: visionType);

    // Save the result
    final result = TestResult(
      date: DateTime.now(),
      detectedType: visionType,
      correctAnswers: state.correctAnswers,
      totalQuestions: PlateData.totalPlates,
      userAnswers: state.userAnswers,
    );

    await _repository.saveTestResult(result);
  }

  /// Determine the vision type based on answers
  VisionType _determineVisionType() {
    int redGreenErrors = 0;
    int blueYellowErrors = 0;
    int totalErrors = 0;

    for (var entry in state.userAnswers.entries) {
      final plateId = entry.key;
      final userAnswer = entry.value;
      final plate = PlateData.getPlateById(plateId);

      if (plate == null) continue;

      // Check if answer is incorrect
      if (userAnswer != plate.correctAnswer) {
        totalErrors++;

        // Categorize the error
        if (plate.deficiencyVisionSees == VisionType.redGreen) {
          redGreenErrors++;
        } else if (plate.deficiencyVisionSees == VisionType.blueYellow) {
          blueYellowErrors++;
        }
      }
    }

    // Determine vision type based on error patterns
    // More than 70% correct = normal vision
    if (state.correctAnswers >= (PlateData.totalPlates * 0.7)) {
      return VisionType.normal;
    }

    // High number of total errors might indicate total color blindness
    if (totalErrors >= (PlateData.totalPlates * 0.6)) {
      return VisionType.total;
    }

    // More red-green errors = red-green deficiency
    if (redGreenErrors > blueYellowErrors) {
      return VisionType.redGreen;
    }

    // More blue-yellow errors = blue-yellow deficiency
    if (blueYellowErrors > redGreenErrors && blueYellowErrors >= 2) {
      return VisionType.blueYellow;
    }

    // Default to red-green as it's most common
    return VisionType.redGreen;
  }

  /// Get progress percentage
  double getProgress() {
    return state.currentPlateIndex / PlateData.totalPlates;
  }

  /// Reset the test
  void resetTest() {
    state = const TestState();
  }
}
