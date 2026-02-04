import 'package:hive/hive.dart';
import 'package:colorsighttest/data/models/vision_type.dart';

part 'test_result.g.dart';

@HiveType(typeId: 1)
class TestResult extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final VisionType detectedType;

  @HiveField(2)
  final int correctAnswers;

  @HiveField(3)
  final int totalQuestions;

  @HiveField(4)
  final Map<int, String> userAnswers;

  TestResult({
    required this.date,
    required this.detectedType,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.userAnswers,
  });

  double get percentage => (correctAnswers / totalQuestions) * 100;

  String get percentageString => '${percentage.toStringAsFixed(1)}%';

  bool get isPassing => correctAnswers >= (totalQuestions * 0.7);
}
