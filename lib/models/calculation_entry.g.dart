// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculation_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalculationEntryAdapter extends TypeAdapter<CalculationEntry> {
  @override
  final int typeId = 0;

  @override
  CalculationEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalculationEntry(
      id: fields[0] as String?,
      expression: fields[1] as String,
      result: fields[2] as String,
      timestamp: fields[3] as DateTime,
      metadata: (fields[4] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, CalculationEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.expression)
      ..writeByte(2)
      ..write(obj.result)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculationEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
