import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AttendanceEntry {
  final int? id;
  final DateTime timestamp;
  final bool checkedIn;

  AttendanceEntry({this.id, required this.timestamp, required this.checkedIn});

  Map<String, Object?> toMap() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'checked_in': checkedIn ? 1 : 0,
      };

  static AttendanceEntry fromMap(Map<String, Object?> m) => AttendanceEntry(
        id: m['id'] as int?,
        timestamp: DateTime.parse(m['timestamp'] as String),
        checkedIn: (m['checked_in'] as int) == 1,
      );
}

class DB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final path = await getDatabasesPath();
    _db = await openDatabase(join(path, 'attendance.db'), version: 1,
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE attendance(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          timestamp TEXT NOT NULL,
          checked_in INTEGER NOT NULL
        )
      ''');
    });
    return _db!;
  }

  static Future<int> insertEntry(AttendanceEntry e) async {
    final db = await database;
    return db.insert('attendance', e.toMap());
  }

  static Future<List<AttendanceEntry>> allEntries() async {
    final db = await database;
    final rows = await db.query('attendance', orderBy: 'timestamp DESC');
    return rows.map((r) => AttendanceEntry.fromMap(r)).toList();
  }

  static Future<void> clear() async {
    final db = await database;
    await db.delete('attendance');
  }
}
