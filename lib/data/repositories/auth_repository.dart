import 'package:oficios/models/auth_account.dart';

abstract interface class AuthRepository {
  Future<AuthAccount> signIn({required String email, required String password});
}

abstract interface class AccountRegistrationRepository {
  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required AccountRole role,
    String specialty = '',
    String about = '',
  });
}

class AccountRegistrationException implements Exception {
  const AccountRegistrationException(this.message);

  final String message;

  @override
  String toString() => message;
}

class DuplicateAccountException extends AccountRegistrationException {
  const DuplicateAccountException()
    : super('Ya existe una cuenta registrada con ese correo.');
}
