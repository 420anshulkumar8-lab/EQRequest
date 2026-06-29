import 'package:hive/hive.dart';

part 'eq_record.g.dart';

@HiveType(typeId: 0)
class EqRecord extends HiveObject {
  @HiveField(0)
  late String pnr;

  @HiveField(1)
  late String trainNo;

  @HiveField(2)
  late String doj;

  @HiveField(3)
  late String fromStation;

  @HiveField(4)
  late String toStation;

  @HiveField(5)
  late String trainClass;

  @HiveField(6)
  late String name;

  @HiveField(7)
  late String mobile;

  @HiveField(8)
  late String reference;

  @HiveField(9)
  late String passengerType;

  @HiveField(10)
  late int berthCount;

  @HiveField(11)
  late String toOffice;

  @HiveField(12)
  late String createdAt;

  @HiveField(13)
  late String pdfPath;

  @HiveField(14)
  late String zone;
}
