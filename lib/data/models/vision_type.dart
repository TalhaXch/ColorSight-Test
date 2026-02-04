import 'package:hive/hive.dart';

part 'vision_type.g.dart';

@HiveType(typeId: 0)
enum VisionType {
  @HiveField(0)
  normal,

  @HiveField(1)
  redGreen,

  @HiveField(2)
  blueYellow,

  @HiveField(3)
  total;

  String get displayName {
    switch (this) {
      case VisionType.normal:
        return 'Normal Color Vision';
      case VisionType.redGreen:
        return 'Possible Red-Green Deficiency';
      case VisionType.blueYellow:
        return 'Possible Blue-Yellow Deficiency';
      case VisionType.total:
        return 'Possible Total Color Blindness';
    }
  }

  String get description {
    switch (this) {
      case VisionType.normal:
        return 'Your responses suggest normal color vision. You were able to identify most or all of the test patterns correctly.';
      case VisionType.redGreen:
        return 'Your responses suggest difficulty distinguishing between red and green colors. This is the most common form of color vision deficiency, affecting approximately 8% of males and 0.5% of females.';
      case VisionType.blueYellow:
        return 'Your responses suggest difficulty distinguishing between blue and yellow colors. This is a less common form of color vision deficiency.';
      case VisionType.total:
        return 'Your responses suggest significant difficulty with color perception. Complete color blindness is rare, affecting approximately 1 in 30,000 people.';
    }
  }

  String get recommendation {
    switch (this) {
      case VisionType.normal:
        return 'Continue with regular eye exams to maintain your visual health.';
      case VisionType.redGreen:
      case VisionType.blueYellow:
      case VisionType.total:
        return 'We recommend consulting with an eye care professional for a comprehensive color vision assessment. Remember, this app provides only a preliminary screening and is not a substitute for professional medical advice.';
    }
  }
}
