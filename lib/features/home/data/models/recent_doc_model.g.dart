// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_doc_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentDocModelAdapter extends TypeAdapter<RecentDocModel> {
  @override
  final int typeId = 0;

  @override
  RecentDocModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentDocModel(
      name: fields[0] as String,
      path: fields[1] as String,
      uploadDate: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RecentDocModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.uploadDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentDocModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
