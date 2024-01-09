import 'package:path/path.dart';
import 'package:reservy/Database/reservation_fields.dart';
import 'package:sqflite/sqflite.dart';

class ReservationDB {
  ReservationDB();
  static final ReservationDB instance = ReservationDB._init();
  final String tableReservation = 'Reservations';

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
  ${ReservationFields.id} $idType, 
  ${ReservationFields.userId} $idType,
  ${ReservationFields.username} $textType,
  ${ReservationFields.restaurant} $textType,
  ${ReservationFields.date} $textType,
  ${ReservationFields.time} $textType,
  ${ReservationFields.branch} $textType,
  ${ReservationFields.guests} $integerType,
  ${ReservationFields.rated} $textType,
  )
''');
  }
}
