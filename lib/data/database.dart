import 'dart:async';

import 'package:floor/floor.dart';
import 'package:qrcode_app/data/qrcode_dao.dart';
import 'package:qrcode_app/entity/qrcode.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

// To run the generator use "flutter packages pub run build_runner build"
part 'database.g.dart';

@Database(version: 1, entities: [Qrcode])
abstract class AppDatabase extends FloorDatabase {
  QrcodeDao get qrcodeDao;
}
