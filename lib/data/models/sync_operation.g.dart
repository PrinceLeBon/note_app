// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_operation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SyncOperationAdapter extends TypeAdapter<SyncOperation> {
  @override
  final int typeId = 4;

  @override
  SyncOperation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncOperation(
      id: fields[0] as String,
      type: fields[1] as String,
      collection: fields[2] as String,
      data: (fields[3] as Map).cast<String, dynamic>(),
      timestamp: fields[4] as DateTime,
      synced: fields[5] as bool,
      documentId: fields[6] as String?,
      retryCount: fields[7] as int,
      failed: fields[8] as bool,
      error: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SyncOperation obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.collection)
      ..writeByte(3)
      ..write(obj.data)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.synced)
      ..writeByte(6)
      ..write(obj.documentId)
      ..writeByte(7)
      ..write(obj.retryCount)
      ..writeByte(8)
      ..write(obj.failed)
      ..writeByte(9)
      ..write(obj.error);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncOperationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
