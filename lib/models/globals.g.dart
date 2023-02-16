// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'globals.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersistentGlobalsModelAdapter
    extends TypeAdapter<PersistentGlobalsModel> {
  @override
  final int typeId = 2;

  @override
  PersistentGlobalsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersistentGlobalsModel()
      .._saved = fields[0] as bool
      .._requirePasswd = fields[1] as bool
      .._themeData = fields[2] as String
      .._darkThemeData = fields[3] as String
      ..firstTime = fields[4] as bool;
  }

  @override
  void write(BinaryWriter writer, PersistentGlobalsModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj._saved)
      ..writeByte(1)
      ..write(obj._requirePasswd)
      ..writeByte(2)
      ..write(obj._themeData)
      ..writeByte(3)
      ..write(obj._darkThemeData)
      ..writeByte(4)
      ..write(obj.firstTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersistentGlobalsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
