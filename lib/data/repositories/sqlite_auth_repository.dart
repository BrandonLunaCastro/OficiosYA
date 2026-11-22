import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:oficios/data/database/app_database.dart';
import 'package:oficios/data/repositories/auth_repository.dart';
import 'package:oficios/data/repositories/mock_auth_repository.dart';
import 'package:oficios/models/auth_account.dart';
import 'package:oficios/models/professional_profile.dart';
import 'package:oficios/models/provider_contact_info.dart';
import 'package:oficios/models/user_profile.dart';
import 'package:sqflite/sqflite.dart';

class SqliteAuthRepository
    implements AuthRepository, AccountRegistrationRepository {
  SqliteAuthRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  static final instance = SqliteAuthRepository();

  static final _passwordHasher = Pbkdf2.hmacSha256(
    iterations: 120000,
    bits: 256,
  );
  static final _secureRandom = Random.secure();

  final AppDatabase _database;
  final MockAuthRepository _mockAuthRepository = const MockAuthRepository();

  @override
  Future<AuthAccount> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _mockAuthRepository.signIn(email: email, password: password);
    } on MockAuthException {
      final normalizedEmail = email.trim().toLowerCase();
      final database = await _database.database;
      final rows = await database.query(
        'accounts',
        where: 'email = ?',
        whereArgs: [normalizedEmail],
        limit: 1,
      );
      if (rows.isEmpty) {
        throw const AuthException(
          'El correo o la contraseña no son correctos.',
        );
      }

      final row = rows.single;
      final salt = row['password_salt'] as Uint8List;
      final storedHash = row['password_hash'] as Uint8List;
      final passwordHash = await _hashPassword(password, salt);
      if (!_matchesHash(passwordHash, storedHash)) {
        throw const AuthException(
          'El correo o la contraseña no son correctos.',
        );
      }

      return _accountFromRow(row);
    }
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required AccountRole role,
    String specialty = '',
    String about = '',
  }) async {
    final normalizedName = name.trim();
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPhone = phone.trim();
    final normalizedSpecialty = specialty.trim();
    final normalizedAbout = about.trim();

    if (normalizedName.isEmpty || normalizedPhone.isEmpty) {
      throw const AccountRegistrationException(
        'Ingresá tu nombre y número de teléfono.',
      );
    }
    if (!_isValidEmail(normalizedEmail)) {
      throw const AccountRegistrationException(
        'Ingresá un correo electrónico válido.',
      );
    }
    if (password.length < 8) {
      throw const AccountRegistrationException(
        'La contraseña debe tener al menos 8 caracteres.',
      );
    }
    if (role == AccountRole.professional &&
        (normalizedSpecialty.isEmpty || normalizedAbout.isEmpty)) {
      throw const AccountRegistrationException(
        'Completá tu oficio y una breve descripción.',
      );
    }
    if (_mockAuthRepository.isReservedEmail(normalizedEmail)) {
      throw const DuplicateAccountException();
    }

    final database = await _database.database;
    final existingAccounts = await database.query(
      'accounts',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [normalizedEmail],
      limit: 1,
    );
    if (existingAccounts.isNotEmpty) {
      throw const DuplicateAccountException();
    }

    final salt = Uint8List.fromList(
      List.generate(16, (_) => _secureRandom.nextInt(256)),
    );
    final passwordHash = await _hashPassword(password, salt);

    await database.insert('accounts', {
      'name': normalizedName,
      'email': normalizedEmail,
      'phone': normalizedPhone,
      'role': role.name,
      'specialty': normalizedSpecialty,
      'about': normalizedAbout,
      'password_salt': salt,
      'password_hash': passwordHash,
    }, conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<Uint8List> _hashPassword(String password, Uint8List salt) async {
    final key = await _passwordHasher.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );
    return Uint8List.fromList(await key.extractBytes());
  }

  bool _matchesHash(List<int> candidate, List<int> stored) {
    if (candidate.length != stored.length) return false;
    var difference = 0;
    for (var index = 0; index < candidate.length; index++) {
      difference |= candidate[index] ^ stored[index];
    }
    return difference == 0;
  }

  AuthAccount _accountFromRow(Map<String, Object?> row) {
    final id = row['id'] as int;
    final name = row['name'] as String;
    final email = row['email'] as String;
    final phone = row['phone'] as String;
    final role = AccountRole.values.firstWhere(
      (value) => value.name == row['role'],
      orElse: () => throw StateError('Rol de cuenta inválido en SQLite.'),
    );

    if (role == AccountRole.client) {
      return AuthAccount(
        email: email,
        role: role,
        clientProfile: UserProfile(
          id: 'local-$id',
          name: name,
          email: email,
          phone: phone,
          location: 'Mendoza Capital, Mendoza',
        ),
      );
    }

    return AuthAccount(
      email: email,
      role: role,
      professionalProfile: ProfessionalProfile(
        id: 'local-$id',
        initials: _initials(name),
        name: name,
        specialty: row['specialty'] as String,
        location: 'Mendoza Capital',
        rating: 0,
        reviews: 0,
        about: row['about'] as String,
        publishedServices: 0,
      ),
      providerContactInfo: ProviderContactInfo(
        city: 'Mendoza Capital',
        province: 'Mendoza',
        coverageZone: 'Mendoza y alrededores',
        phone: phone,
        email: email,
      ),
    );
  }

  String _initials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.length == 1) return words.first[0].toUpperCase();
    return '${words.first[0]}${words[1][0]}'.toUpperCase();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }
}
