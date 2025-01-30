import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/wifi_data.dart';

class DBHelper {
  static Future<Database> getDatabase() async {
    final path = join(await getDatabasesPath(), 'wifi_signals.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE wifi_signals (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ssid TEXT,
            dbm INTEGER,
            location TEXT,
            latitude REAL, 
            longitude REAL,
            timestamp TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute("ALTER TABLE wifi_signals ADD COLUMN latitude REAL");
          db.execute("ALTER TABLE wifi_signals ADD COLUMN longitude REAL");
        }
      },
    );
  }

  static Future<void> insertData(WifiData data) async {
    final db = await getDatabase();
    await db.insert(
      "wifi_signals",
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<WifiData>> fetchData() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query("wifi_signals");
    return maps.map((data) => WifiData.fromMap(data)).toList();
  }
}
