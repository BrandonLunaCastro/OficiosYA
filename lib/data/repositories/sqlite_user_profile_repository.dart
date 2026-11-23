import 'package:oficios/data/database/app_database.dart';
import 'package:oficios/data/repositories/user_profile_repository.dart';
import 'package:oficios/models/user_profile.dart';
import 'package:sqflite/sqflite.dart';

class SqliteUserProfileRepository implements UserProfileRepository {
  SqliteUserProfileRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;
  UserProfile _profile = const UserProfile();

  @override
  UserProfile getProfile() => _profile;

  @override
  Future<UserProfile> activateProfile(UserProfile fallback) async {
    final rows = await (await _database.database).query(
      'client_profiles',
      where: 'profile_id = ?',
      whereArgs: [fallback.id],
      limit: 1,
    );

    if (rows.isEmpty) {
      _profile = fallback;
    } else {
      final row = rows.single;
      _profile = fallback.copyWith(
        name: row['name'] as String,
        email: row['email'] as String,
        phone: row['phone'] as String,
        location: row['location'] as String,
      );
    }
    return _profile;
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    if (profile.id.isEmpty) {
      throw ArgumentError(
        'El perfil debe tener un identificador para guardarse.',
      );
    }

    final database = await _database.database;
    await database.insert('client_profiles', {
      'profile_id': profile.id,
      'name': profile.name,
      'email': profile.email,
      'phone': profile.phone,
      'location': profile.location,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    _profile = profile;
  }
}
