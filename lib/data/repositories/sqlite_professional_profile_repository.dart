import 'package:oficios/data/database/app_database.dart';
import 'package:oficios/data/mocks/mock_professional_profile.dart';
import 'package:oficios/data/repositories/professional_profile_repository.dart';
import 'package:oficios/models/professional_profile.dart';
import 'package:sqflite/sqflite.dart';

class SqliteProfessionalProfileRepository
    implements ProfessionalProfileRepository {
  SqliteProfessionalProfileRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance,
      _profile = mockProfessionalProfile;

  final AppDatabase _database;
  ProfessionalProfile _profile;

  @override
  Future<ProfessionalProfile> getProfile() async => _profile;

  @override
  Future<ProfessionalProfile> activateProfile(
    ProfessionalProfile fallback,
  ) async {
    final rows = await (await _database.database).query(
      'professional_profiles',
      where: 'profile_id = ?',
      whereArgs: [fallback.id],
      limit: 1,
    );
    if (rows.isEmpty) {
      _profile = fallback;
      await _store(_profile);
    } else {
      final row = rows.single;
      _profile = fallback.copyWith(
        initials: row['initials'] as String,
        name: row['name'] as String,
        specialty: row['specialty'] as String,
        location: row['location'] as String,
        rating: (row['rating'] as num).toDouble(),
        reviews: row['reviews'] as int,
        about: row['about'] as String,
        publishedServices: row['published_services'] as int,
      );
    }
    return _profile;
  }

  @override
  Future<void> updateProfile(ProfessionalProfile profile) async {
    if (profile.id.isEmpty ||
        profile.name.trim().isEmpty ||
        profile.specialty.trim().isEmpty ||
        profile.about.trim().isEmpty) {
      throw ArgumentError(
        'El identificador, nombre, oficio y descripción son obligatorios.',
      );
    }

    _profile = profile.copyWith(
      initials: profile.initials.trim(),
      name: profile.name.trim(),
      specialty: profile.specialty.trim(),
      location: profile.location.trim(),
      about: profile.about.trim(),
    );
    await _store(_profile);
  }

  Future<void> _store(ProfessionalProfile profile) async {
    await (await _database.database).insert('professional_profiles', {
      'profile_id': profile.id,
      'initials': profile.initials,
      'name': profile.name,
      'specialty': profile.specialty,
      'location': profile.location,
      'rating': profile.rating,
      'reviews': profile.reviews,
      'about': profile.about,
      'published_services': profile.publishedServices,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
