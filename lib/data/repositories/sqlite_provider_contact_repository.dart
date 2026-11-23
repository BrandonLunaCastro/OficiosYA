import 'package:oficios/data/database/app_database.dart';
import 'package:oficios/data/mocks/mock_professional_profile.dart';
import 'package:oficios/data/mocks/mock_provider_contact_info.dart';
import 'package:oficios/data/repositories/provider_contact_repository.dart';
import 'package:oficios/models/provider_contact_info.dart';
import 'package:sqflite/sqflite.dart';

class SqliteProviderContactRepository implements ProviderContactRepository {
  SqliteProviderContactRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance,
      _contactInfo = mockProviderContactInfo.copyWith(
        profileId: mockProfessionalProfile.id,
      );

  final AppDatabase _database;
  ProviderContactInfo _contactInfo;

  @override
  Future<ProviderContactInfo> getContactInfo() async => _contactInfo;

  @override
  Future<ProviderContactInfo> activateProfile({
    required String profileId,
    required ProviderContactInfo fallback,
  }) async {
    final rows = await (await _database.database).query(
      'professional_contacts',
      where: 'profile_id = ?',
      whereArgs: [profileId],
      limit: 1,
    );
    if (rows.isEmpty) {
      _contactInfo = fallback.copyWith(profileId: profileId);
      await _store(_contactInfo);
    } else {
      final row = rows.single;
      _contactInfo = ProviderContactInfo(
        profileId: profileId,
        city: row['city'] as String,
        province: row['province'] as String,
        coverageZone: row['coverage_zone'] as String,
        phone: row['phone'] as String,
        email: row['email'] as String,
      );
    }
    return _contactInfo;
  }

  @override
  Future<void> updateContactInfo(ProviderContactInfo contactInfo) async {
    final values = [
      contactInfo.profileId,
      contactInfo.city,
      contactInfo.province,
      contactInfo.coverageZone,
      contactInfo.phone,
      contactInfo.email,
    ];
    if (values.any((value) => value.trim().isEmpty)) {
      throw ArgumentError('Todos los campos de contacto son obligatorios.');
    }

    _contactInfo = contactInfo.copyWith(
      profileId: contactInfo.profileId.trim(),
      city: contactInfo.city.trim(),
      province: contactInfo.province.trim(),
      coverageZone: contactInfo.coverageZone.trim(),
      phone: contactInfo.phone.trim(),
      email: contactInfo.email.trim(),
    );
    await _store(_contactInfo);
  }

  Future<void> _store(ProviderContactInfo contactInfo) async {
    await (await _database.database).insert('professional_contacts', {
      'profile_id': contactInfo.profileId,
      'city': contactInfo.city,
      'province': contactInfo.province,
      'coverage_zone': contactInfo.coverageZone,
      'phone': contactInfo.phone,
      'email': contactInfo.email,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
