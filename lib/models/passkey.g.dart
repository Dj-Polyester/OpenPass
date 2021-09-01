// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passkey.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PassKeyAdapter extends TypeAdapter<PassKey> {
  @override
  final int typeId = 0;

  @override
  PassKey read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PassKey(
      desc: fields[0] as String,
      value: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PassKey obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.desc)
      ..writeByte(1)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PassKeyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
