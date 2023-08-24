// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../hashtag.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HashTagAdapter extends TypeAdapter<HashTag> {
  @override
  final int typeId = 2;

  @override
  HashTag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HashTag(
      id: fields[0] as String,
      label: fields[1] as String,
      color: fields[2] as String,
      creationDate: fields[3] as DateTime,
      userId: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HashTag obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.creationDate)
      ..writeByte(4)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HashTagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
