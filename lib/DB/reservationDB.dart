import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:reservy/Models/reservation.dart';

class ReservationDB {
  ReservationDB(){}
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
    const boolType = 'BOOLEAN NOT NULL';
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

  Future<Reservation> create(Reservation note) async {
    final db = await instance.database;

    final id = await db.insert(tableReservation, note.toJson());
    return note.copy(id: id as String);
  }

  Future<Reservation> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableReservation,
      columns: reservationFields.values,
      where: '${reservationFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Reservation.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Reservation>> readAllReservations() async {
    final db = await instance.database;

    final orderBy = '${reservationFields.time} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableReservation ORDER BY $orderBy');

    final result = await db.query(tableReservation, orderBy: orderBy);

    return result.map((json) => Reservation.fromJson(json)).toList();
  }

  Future<int> update(Reservation note) async {
    final db = await instance.database;

    return db.update(
      tableReservation,
      note.toJson(),
      where: '${reservationFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableReservation,
      where: '${reservationFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
