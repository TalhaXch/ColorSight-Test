import 'package:colorsighttest/data/models/vision_type.dart';

class ColorPlate {
  final int id;
  final String imageAsset;
  final String correctAnswer;
  final List<String> options;
  final VisionType normalVisionSees;
  final VisionType? deficiencyVisionSees;
  final String description;

  const ColorPlate({
    required this.id,
    required this.imageAsset,
    required this.correctAnswer,
    required this.options,
    required this.normalVisionSees,
    this.deficiencyVisionSees,
    required this.description,
  });

  ColorPlate copyWith({
    int? id,
    String? imageAsset,
    String? correctAnswer,
    List<String>? options,
    VisionType? normalVisionSees,
    VisionType? deficiencyVisionSees,
    String? description,
  }) {
    return ColorPlate(
      id: id ?? this.id,
      imageAsset: imageAsset ?? this.imageAsset,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      options: options ?? this.options,
      normalVisionSees: normalVisionSees ?? this.normalVisionSees,
      deficiencyVisionSees: deficiencyVisionSees ?? this.deficiencyVisionSees,
      description: description ?? this.description,
    );
  }
}
