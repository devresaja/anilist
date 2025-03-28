import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabaseService {
  static final LocalDatabaseService _instance =
      LocalDatabaseService._internal();
  factory LocalDatabaseService() => _instance;

  LocalDatabaseService._internal();

  static Database? _database;
  static const String _dbName = 'anilist.db';
  static const String tableAnime = 'anime';

  Future<void> init() async {
    _database ??= await _initDB();
  }

  Future<Database> get database async {
    if (_database == null) {
      await init();
    }
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableAnime (
            mal_id INTEGER PRIMARY KEY,
            title TEXT,
            title_english TEXT,
            title_japanese TEXT,
            type TEXT,
            episodes INTEGER,
            score REAL,
            rank INTEGER,
            synopsis TEXT,
            season TEXT,
            year INTEGER,
            images TEXT,
            trailer TEXT,
            genres TEXT,
            created_at TEXT
          )
        ''');
      },
    );
  }
}
