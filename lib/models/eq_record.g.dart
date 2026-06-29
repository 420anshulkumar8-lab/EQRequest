// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eq_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EqRecordAdapter extends TypeAdapter<EqRecord> {
  @override
  final int typeId = 0;

  @override
  EqRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EqRecord()
      ..pnr = fields[0] as String
      ..trainNo = fields[1] as String
      ..doj = fields[2] as String
      ..fromStation = fields[3] as String
      ..toStation = fields[4] as String
      ..trainClass = fields[5] as String
      ..name = fields[6] as String
      ..mobile = fields[7] as String
      ..reference = fields[8] as String
      ..passengerType = fields[9] as String
      ..berthCount = fields[10] as int
      ..toOffice = fields[11] as String
      ..createdAt = fields[12] as String
      ..pdfPath = fields[13] as String
      ..zone = fields[14] as String;
  }

  @override
  void write(BinaryWriter writer, EqRecord obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.pnr)
      ..writeByte(1)
      ..write(obj.trainNo)
      ..writeByte(2)
      ..write(obj.doj)
      ..writeByte(3)
      ..write(obj.fromStation)
      ..writeByte(4)
      ..write(obj.toStation)
      ..writeByte(5)
      ..write(obj.trainClass)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.mobile)
      ..writeByte(8)
      ..write(obj.reference)
      ..writeByte(9)
      ..write(obj.passengerType)
      ..writeByte(10)
      ..write(obj.berthCount)
      ..writeByte(11)
      ..write(obj.toOffice)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.pdfPath)
      ..writeByte(14)
      ..write(obj.zone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EqRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
