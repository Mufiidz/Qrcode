import 'package:floor/floor.dart';

@Entity(tableName: 'qrcode')
class Qrcode {

  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String code;
  final String? from;

  Qrcode({this.id, required this.code, this.from});
  
}