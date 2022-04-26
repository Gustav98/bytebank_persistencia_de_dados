import 'package:bytebank_flutter2/database/dao/contact_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'bytebank01.db');
  print(path);
  return openDatabase(
    path,
    onCreate: (db, version) async {
      await db.execute(ContactDao.tableSql);
    },
    version: 1,
  );
}
