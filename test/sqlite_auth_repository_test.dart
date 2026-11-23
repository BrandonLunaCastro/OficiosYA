import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/database/app_database.dart';
import 'package:oficios/data/repositories/auth_repository.dart';
import 'package:oficios/data/repositories/sqlite_auth_repository.dart';
import 'package:oficios/data/repositories/mock_provider_repository.dart';
import 'package:oficios/data/repositories/sqlite_professional_profile_repository.dart';
import 'package:oficios/data/repositories/sqlite_provider_contact_repository.dart';
import 'package:oficios/data/repositories/sqlite_user_profile_repository.dart';
import 'package:oficios/models/auth_account.dart';
import 'package:oficios/models/user_profile.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test(
    'registers accounts and authenticates them after reopening SQLite',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'oficios_accounts_',
      );
      addTearDown(() async {
        if (await directory.exists()) {
          await directory.delete(recursive: true);
        }
      });
      final databasePath = path.join(directory.path, 'accounts.db');
      final firstDatabase = AppDatabase(databasePath: databasePath);
      addTearDown(firstDatabase.close);
      final firstRepository = SqliteAuthRepository(database: firstDatabase);

      final demoAccount = await firstRepository.signIn(
        email: 'cliente@oficiosya.com',
        password: 'Cliente123',
      );
      expect(demoAccount.role, AccountRole.client);
      await expectLater(
        firstRepository.register(
          name: 'Cuenta duplicada',
          email: 'CLIENTE@oficiosya.com',
          phone: '2615550000',
          password: 'ClientPass123',
          role: AccountRole.client,
        ),
        throwsA(isA<DuplicateAccountException>()),
      );

      await firstRepository.register(
        name: 'Ana Gómez',
        email: 'ANA@example.com',
        phone: '2615550001',
        password: 'ClientPass123',
        role: AccountRole.client,
      );
      await firstRepository.register(
        name: 'Juan Pérez',
        email: 'juan@example.com',
        phone: '2615550002',
        password: 'ProviderPass123',
        role: AccountRole.professional,
        specialty: 'Electricidad',
        about: 'Instalaciones y reparaciones domiciliarias.',
      );

      await expectLater(
        firstRepository.register(
          name: 'Otra Ana',
          email: 'ana@EXAMPLE.com',
          phone: '2615550003',
          password: 'AnotherPass123',
          role: AccountRole.client,
        ),
        throwsA(isA<DuplicateAccountException>()),
      );
      await firstDatabase.close();

      final reopenedDatabase = AppDatabase(databasePath: databasePath);
      addTearDown(reopenedDatabase.close);
      final reopenedRepository = SqliteAuthRepository(
        database: reopenedDatabase,
      );
      final client = await reopenedRepository.signIn(
        email: 'ana@example.com',
        password: 'ClientPass123',
      );
      final professional = await reopenedRepository.signIn(
        email: 'JUAN@example.com',
        password: 'ProviderPass123',
      );

      expect(client.role, AccountRole.client);
      expect(client.clientProfile?.name, 'Ana Gómez');
      expect(client.clientProfile?.email, 'ana@example.com');
      expect(professional.role, AccountRole.professional);
      expect(professional.professionalProfile?.specialty, 'Electricidad');
      expect(professional.providerContactInfo?.phone, '2615550002');
      await expectLater(
        reopenedRepository.signIn(
          email: 'ana@example.com',
          password: 'WrongPass123',
        ),
        throwsA(isA<AuthException>()),
      );
    },
  );

  test(
    'database upgrade adds accounts and reviews without dropping orders',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'oficios_migration_',
      );
      addTearDown(() async {
        if (await directory.exists()) {
          await directory.delete(recursive: true);
        }
      });
      final databasePath = path.join(directory.path, 'oficiosya.db');
      final versionOneDatabase = await databaseFactory.openDatabase(
        databasePath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (database, version) async {
            await database.execute('''
            CREATE TABLE orders (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              service TEXT NOT NULL
            )
          ''');
          },
        ),
      );
      await versionOneDatabase.insert('orders', {'service': 'Plomería'});
      await versionOneDatabase.close();

      final upgradedDatabase = AppDatabase(databasePath: databasePath);
      addTearDown(upgradedDatabase.close);
      final database = await upgradedDatabase.database;
      final orders = await database.query('orders', columns: ['service']);
      final accountsTable = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'accounts'",
      );
      final reviewsTable = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'provider_reviews'",
      );

      expect(orders.single['service'], 'Plomería');
      expect(accountsTable, hasLength(1));
      expect(reviewsTable, hasLength(1));
    },
  );

  test('persists client locations separately for each account', () async {
    final directory = await Directory.systemTemp.createTemp(
      'oficios_client_profiles_',
    );
    addTearDown(() async {
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    });
    final database = AppDatabase(
      databasePath: path.join(directory.path, 'profiles.db'),
    );
    addTearDown(database.close);
    final repository = SqliteUserProfileRepository(database: database);
    const maipuClient = UserProfile(
      id: 'client-1',
      name: 'Cliente Maipú',
      email: 'maipu@example.com',
      phone: '2615550001',
      location: 'Maipú, Mendoza',
    );
    const capitalClient = UserProfile(
      id: 'client-2',
      name: 'Cliente Capital',
      email: 'capital@example.com',
      phone: '2615550002',
      location: 'Mendoza Capital, Mendoza',
    );

    await repository.activateProfile(maipuClient);
    await repository.saveProfile(maipuClient);
    await repository.activateProfile(capitalClient);
    await repository.saveProfile(capitalClient);

    final maipuReopenedRepository = SqliteUserProfileRepository(
      database: database,
    );
    final restoredMaipu = await maipuReopenedRepository.activateProfile(
      maipuClient.copyWith(location: 'Mendoza Capital, Mendoza'),
    );

    expect(restoredMaipu.location, 'Maipú, Mendoza');
    await repository.activateProfile(capitalClient);
    expect(repository.getProfile().location, 'Mendoza Capital, Mendoza');
  });

  test(
    'finds a professional by city even when coverage zone differs',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'oficios_professional_search_',
      );
      addTearDown(() async {
        if (await directory.exists()) {
          await directory.delete(recursive: true);
        }
      });
      final database = AppDatabase(
        databasePath: path.join(directory.path, 'professionals.db'),
      );
      addTearDown(database.close);
      final authRepository = SqliteAuthRepository(database: database);
      await authRepository.register(
        name: 'Carla Prestadora',
        email: 'carla@example.com',
        phone: '2615550003',
        password: 'CarlaPass123',
        role: AccountRole.professional,
        specialty: 'Plomería',
        about: 'Reparaciones e instalaciones.',
      );
      final account = await authRepository.signIn(
        email: 'carla@example.com',
        password: 'CarlaPass123',
      );
      final profileRepository = SqliteProfessionalProfileRepository(
        database: database,
      );
      final contactRepository = SqliteProviderContactRepository(
        database: database,
      );
      final profile = await profileRepository.activateProfile(
        account.professionalProfile!,
      );
      final contact = await contactRepository.activateProfile(
        profileId: profile.id,
        fallback: account.providerContactInfo!,
      );
      await profileRepository.updateProfile(
        profile.copyWith(location: 'Luján', name: 'Carla Prestadora'),
      );
      await contactRepository.updateContactInfo(
        contact.copyWith(
          city: 'Luján',
          province: 'Mendoza',
          coverageZone: 'Gran Mendoza',
        ),
      );

      final reloadedProfiles = SqliteProfessionalProfileRepository(
        database: database,
      );
      final reloadedProfile = await reloadedProfiles.activateProfile(
        account.professionalProfile!,
      );
      final reloadedContacts = SqliteProviderContactRepository(
        database: database,
      );
      final reloadedContact = await reloadedContacts.activateProfile(
        profileId: reloadedProfile.id,
        fallback: account.providerContactInfo!,
      );
      final providerRepository = MockProviderRepository(database: database);
      final lujanProviders = await providerRepository.getProviders(
        location: 'Luján, Mendoza',
      );
      final capitalProviders = await providerRepository.getProviders(
        location: 'Mendoza Capital, Mendoza',
      );

      expect(reloadedContact.city, 'Luján');
      expect(reloadedContact.coverageZone, 'Gran Mendoza');
      expect(
        lujanProviders.any((provider) => provider.id == reloadedProfile.id),
        isTrue,
      );
      expect(
        capitalProviders.any((provider) => provider.id == reloadedProfile.id),
        isFalse,
      );
    },
  );
}
