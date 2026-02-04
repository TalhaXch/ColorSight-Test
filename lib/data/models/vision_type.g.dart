// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vision_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisionTypeAdapter extends TypeAdapter<VisionType> {
  @override
  final int typeId = 0;

  @override
  VisionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VisionType.normal;
      case 1:
        return VisionType.redGreen;
      case 2:
        return VisionType.blueYellow;
      case 3:
        return VisionType.total;
      default:
        return VisionType.normal;
    }
  }

  @override
  void write(BinaryWriter writer, VisionType obj) {
    switch (obj) {
      case VisionType.normal:
        writer.writeByte(0);
        break;
      case VisionType.redGreen:
        writer.writeByte(1);
        break;
      case VisionType.blueYellow:
        writer.writeByte(2);
        break;
      case VisionType.total:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
