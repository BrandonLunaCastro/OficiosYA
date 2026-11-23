import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase({this.databasePath});

  AppDatabase._() : databasePath = null;

  static final instance = AppDatabase._();

  final String? databasePath;
  Future<Database>? _database;

  Future<Database> get database => _database ??= _openDatabase();

  Future<void> close() async {
    final databaseFuture = _database;
    if (databaseFuture == null) return;

    await (await databaseFuture).close();
    _database = null;
  }

  Future<Database> _openDatabase() async {
    final pathToDatabase =
        databasePath ?? path.join(await getDatabasesPath(), 'oficiosya.db');

    return openDatabase(
      pathToDatabase,
      version: 5,
      onCreate: (database, version) async {
        await _createOrdersTable(database);
        await _createAccountsTable(database);
        await _createProviderReviewsTable(database);
        await _createClientProfilesTable(database);
        await _createProfessionalProfileTables(database);
      },
      onUpgrade: (database, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createAccountsTable(database);
        }
        if (oldVersion < 3) {
          await _createProviderReviewsTable(database);
        }
        if (oldVersion < 4) {
          await _createClientProfilesTable(database);
        }
        if (oldVersion < 5) {
          await _createProfessionalProfileTables(database);
        }
      },
    );
  }

  Future<void> _createOrdersTable(Database database) async {
    await database.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        service TEXT NOT NULL,
        provider_initials TEXT NOT NULL,
        provider_name TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT NOT NULL,
        client_name TEXT NOT NULL,
        client_phone TEXT NOT NULL,
        client_email TEXT NOT NULL,
        location TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createAccountsTable(Database database) async {
    await database.execute('''
      CREATE TABLE accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL COLLATE NOCASE UNIQUE,
        phone TEXT NOT NULL,
        role TEXT NOT NULL CHECK (role IN ('client', 'professional')),
        specialty TEXT NOT NULL,
        about TEXT NOT NULL,
        password_salt BLOB NOT NULL,
        password_hash BLOB NOT NULL
      )
    ''');
  }

  Future<void> _createProviderReviewsTable(Database database) async {
    await database.execute('''
      CREATE TABLE provider_reviews (
        provider_id TEXT NOT NULL,
        review_id TEXT NOT NULL,
        reviewer_name TEXT NOT NULL,
        reviewed_at TEXT NOT NULL,
        rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
        comment TEXT NOT NULL,
        PRIMARY KEY (provider_id, review_id)
      )
    ''');
    await database.execute('''
      CREATE INDEX provider_reviews_by_provider_date
      ON provider_reviews(provider_id, reviewed_at DESC)
    ''');
  }

  Future<void> _createClientProfilesTable(Database database) async {
    await database.execute('''
      CREATE TABLE client_profiles (
        profile_id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        location TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createProfessionalProfileTables(Database database) async {
    await database.execute('''
      CREATE TABLE professional_profiles (
        profile_id TEXT PRIMARY KEY,
        initials TEXT NOT NULL,
        name TEXT NOT NULL,
        specialty TEXT NOT NULL,
        location TEXT NOT NULL,
        rating REAL NOT NULL,
        reviews INTEGER NOT NULL,
        about TEXT NOT NULL,
        published_services INTEGER NOT NULL
      )
    ''');
    await database.execute('''
      CREATE TABLE professional_contacts (
        profile_id TEXT PRIMARY KEY,
        city TEXT NOT NULL,
        province TEXT NOT NULL,
        coverage_zone TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');
  }
}
