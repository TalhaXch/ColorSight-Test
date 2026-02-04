import 'package:colorsighttest/data/models/color_plate.dart';
import 'package:colorsighttest/data/models/vision_type.dart';

/// Test plate data representing Ishihara-style color vision tests
///
/// Note: This uses placeholder image paths. In production, you would need to:
/// 1. Create or license actual Ishihara test plate images
/// 2. Place them in assets/images/plates/
/// 3. Update the imageAsset paths accordingly
///
/// For testing purposes, you can use solid color placeholders or generate
/// simple dot patterns programmatically.

class PlateData {
  static final List<ColorPlate> plates = [
    // Plate 1 - Control plate (everyone should see this)
    const ColorPlate(
      id: 1,
      imageAsset: 'assets/images/plates/1.png',
      correctAnswer: '12',
      options: ['12', '13', '15', "I can't see anything"],
      normalVisionSees: VisionType.normal,
      deficiencyVisionSees: null,
      description:
          'This is a control plate that both normal and color deficient individuals should be able to see.',
    ),

    // Plate 2 - Red-Green test
    const ColorPlate(
      id: 2,
      imageAsset: 'assets/images/plates/2.png',
      correctAnswer: '8',
      options: ['3', '8', '5', "I can't see anything"],
      normalVisionSees: VisionType.normal,
      deficiencyVisionSees: VisionType.redGreen,
      description:
          'Normal vision sees 8. Those with red-green deficiency may see 3 or nothing.',
    ),

    // Plate 3 - Red-Green test
    const ColorPlate(
      id: 3,
      imageAsset: 'assets/images/plates/3.png',
      correctAnswer: '6',
      options: ['6', '5', '9', "I can't see anything"],
      normalVisionSees: VisionType.normal,
      deficiencyVisionSees: VisionType.redGreen,
      description:
          'Normal vision sees 6. Red-green deficient individuals may see 5 or have difficulty.',
    ),

    // Plate 4 - Red-Green test
    const ColorPlate(
      id: 4,
      imageAsset: 'assets/images/plates/4.png',
      correctAnswer: '29',
      options: ['29', '70', '20', "I can't see anything"],
      normalVisionSees: VisionType.normal,
      deficiencyVisionSees: VisionType.redGreen,
      description: 'Normal vision sees 29. Red-green deficient may see 70.',
    ),

    // Plate 5 - Red-Green test
    const ColorPlate(
      id: 5,
      imageAsset: 'assets/images/plates/5.png',
      correctAnswer: '57',
      options: ['57', '35', '75', "I can't see anything"],
      normalVisionSees: VisionType.normal,
      deficiencyVisionSees: VisionType.redGreen,
      description:
          'Normal vision sees 57. Red-green deficient individuals may see 35 or nothing.',
    ),

    // Plate 6 - Red-Green test
    const ColorPlate(
      id: 6,
      imageAsset: 'assets/images/plates/6.png',
      correctAnswer: '5',
      options: ['5', '2', '3', "I can't see anything"],
      normalVisionSees: VisionType.normal,
      deficiencyVisionSees: VisionType.redGreen,
      description: 'Normal vision sees 5. Red-green deficient may see 2.',
    ),

    // Plate 7 - Red-Green test
    const ColorPlate(
      id: 7,
      imageAsset: 'assets/images/plates/7.png',
      correctAnswer: '3',
      options: ['3', '5', '8', "I can't see anything"],
      normalVisionSees: VisionType.normal,
      deficiencyVisionSees: VisionType.redGreen,
      description:
          'Normal vision sees 3. Red-green deficient individuals may see 5.',
    ),

    // Plate 8 - Red-Green test
    const ColorPlate(
      id: 8,
      imageAsset: 'assets/images/plates/8.png',
      correctAnswer: '15',
      options: ['15', '17', '13', "I can't see anything"],
      normalVisionSees: VisionType.normal,
      deficiencyVisionSees: VisionType.redGreen,
      description: 'Normal vision sees 15. Red-green deficient may see 17.',
    ),

    // Plate 9 - Red-Green test
    const ColorPlate(
      id: 9,
      imageAsset: 'assets/images/plates/9.png',
      correctAnswer: '74',
      options: ['74', '21', '71', "I can't see anything"],
      normalVisionSees: VisionType.normal,
      deficiencyVisionSees: VisionType.redGreen,
      description: 'Normal vision sees 74. Red-green deficient may see 21.',
    ),

    // Plate 10 - Blue-Yellow test
    const ColorPlate(
      id: 10,
      imageAsset: 'assets/images/plates/10.png',
      correctAnswer: '2',
      options: ['2', '5', '7', "I can't see anything"],
      normalVisionSees: VisionType.normal,
      deficiencyVisionSees: VisionType.blueYellow,
      description: 'This plate tests blue-yellow color vision.',
    ),

    // Plate 11 - Blue-Yellow test
    const ColorPlate(
      id: 11,
      imageAsset: 'assets/images/plates/11.png',
      correctAnswer: '45',
      options: ['45', '48', '43', "I can't see anything"],
      normalVisionSees: VisionType.normal,
      deficiencyVisionSees: VisionType.blueYellow,
      description: 'This plate tests blue-yellow color vision.',
    ),

    // Plate 12 - Total color blindness test
    const ColorPlate(
      id: 12,
      imageAsset: 'assets/images/plates/12.png',
      correctAnswer: '73',
      options: ['73', '78', '23', "I can't see anything"],
      normalVisionSees: VisionType.normal,
      deficiencyVisionSees: VisionType.total,
      description:
          'This plate is visible to those with normal color vision and most types of color deficiency.',
    ),
  ];

  /// Get a plate by ID
  static ColorPlate? getPlateById(int id) {
    try {
      return plates.firstWhere((plate) => plate.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get total number of plates
  static int get totalPlates => plates.length;
}
