import 'package:hive_flutter/hive_flutter.dart';
import 'package:colorsighttest/data/models/test_result.dart';
import 'package:colorsighttest/data/models/vision_type.dart';
import 'package:colorsighttest/core/constants/app_constants.dart';

class TestRepository {
  Box<TestResult>? _testHistoryBox;

  /// Initialize Hive and open boxes
  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(VisionTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TestResultAdapter());
    }

    _testHistoryBox = await Hive.openBox<TestResult>(
      AppConstants.testHistoryBox,
    );
  }

  /// Save a test result
  Future<void> saveTestResult(TestResult result) async {
    await _testHistoryBox?.add(result);
  }

  /// Get all test results, sorted by date (newest first)
  List<TestResult> getAllResults() {
    if (_testHistoryBox == null) return [];

    final results = _testHistoryBox!.values.toList();
    results.sort((a, b) => b.date.compareTo(a.date));
    return results;
  }

  /// Get the most recent test result
  TestResult? getLatestResult() {
    final results = getAllResults();
    return results.isNotEmpty ? results.first : null;
  }

  /// Delete a test result
  Future<void> deleteResult(TestResult result) async {
    await result.delete();
  }

  /// Clear all test history
  Future<void> clearAllHistory() async {
    await _testHistoryBox?.clear();
  }

  /// Get total number of tests taken
  int getTotalTestCount() {
    return _testHistoryBox?.length ?? 0;
  }

  /// Close the box
  Future<void> close() async {
    await _testHistoryBox?.close();
  }
}
