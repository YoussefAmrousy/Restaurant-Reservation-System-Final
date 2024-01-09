import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:reservy/Models/reservation.dart';

class ReservationDB {
  ReservationDB();
  static final ReservationDB instance = ReservationDB._init();

  static Database? _database;

  ReservationDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('reservation.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableReservation ( 
  ${reservationFields.id} $idType, 
  ${reservationFields.userId} $idType,
  ${reservationFields.username} $textType,
  ${reservationFields.restaurant} $textType,
  ${reservationFields.date} $textType,
  ${reservationFields.time} $textType,
  ${reservationFields.branch} $textType,
  ${reservationFields.guests} $integerType,
  ${reservationFields.rated} $textType,
  )
''');
  }
}
