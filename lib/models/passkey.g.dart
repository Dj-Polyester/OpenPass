// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passkey.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PassKeyItemAdapter extends TypeAdapter<PassKeyItem> {
  @override
  final int typeId = 1;

  @override
  PassKeyItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PassKeyItem(
      name: fields[0] as String,
      value: fields[1] as String,
      isSecret: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PassKeyItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.isSecret);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PassKeyItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      username: fields[1] as String?,
      email: fields[2] as String?,
      password: fields[3] as String,
      other: (fields[4] as Map).cast<String, PassKeyItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, PassKey obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.desc)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.other);
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
