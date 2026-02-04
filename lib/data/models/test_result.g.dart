// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TestResultAdapter extends TypeAdapter<TestResult> {
  @override
  final int typeId = 1;

  @override
  TestResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TestResult(
      date: fields[0] as DateTime,
      detectedType: fields[1] as VisionType,
      correctAnswers: fields[2] as int,
      totalQuestions: fields[3] as int,
      userAnswers: (fields[4] as Map).cast<int, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, TestResult obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.detectedType)
      ..writeByte(2)
      ..write(obj.correctAnswers)
      ..writeByte(3)
      ..write(obj.totalQuestions)
      ..writeByte(4)
      ..write(obj.userAnswers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
