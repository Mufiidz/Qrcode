import 'package:floor/floor.dart';
import 'package:qrcode_app/entity/qrcode.dart';

@dao
abstract class QrcodeDao {

  @Query('SELECT * FROM qrcode')
  Future<List<Qrcode>> getAllQrcode();

  @insert
  Future<void> insertQrcode(Qrcode qrcode);

  @Query('DELETE FROM qrcode WHERE id = :id')
  Future<void> deleteQrcodeById(int id);
}