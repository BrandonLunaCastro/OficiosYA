import 'package:oficios/data/mocks/mock_provider_contact_info.dart';
import 'package:oficios/data/mocks/mock_professional_profile.dart';
import 'package:oficios/data/repositories/auth_repository.dart';
import 'package:oficios/models/auth_account.dart';
import 'package:oficios/models/user_profile.dart';

class MockAuthException extends AuthException {
  const MockAuthException()
    : super('El correo o la contraseña no son correctos.');

  @override
  String toString() => message;
}

class MockAuthRepository implements AuthRepository {
  const MockAuthRepository();

  static final _accounts = [
    _MockCredential(
      email: 'cliente@oficiosya.com',
      password: 'Cliente123',
      account: AuthAccount(
        email: 'cliente@oficiosya.com',
        role: AccountRole.client,
        clientProfile: UserProfile(
          id: 'demo-client',
          name: 'Lucas Gómez',
          email: 'lucas.gomez@gmail.com',
          phone: '+54 9 261 555-1234',
          location: 'Mendoza Capital, Mendoza',
        ),
      ),
    ),
    _MockCredential(
      email: 'prestador@oficiosya.com',
      password: 'Prestador123',
      account: AuthAccount(
        email: 'prestador@oficiosya.com',
        role: AccountRole.professional,
        professionalProfile: mockProfessionalProfile,
        providerContactInfo: mockProviderContactInfo,
      ),
    ),
  ];

  bool isReservedEmail(String email) {
    final normalizedEmail = email.trim().toLowerCase();
    return _accounts.any((credential) => credential.email == normalizedEmail);
  }

  @override
  Future<AuthAccount> signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    for (final credential in _accounts) {
      if (credential.email == normalizedEmail &&
          credential.password == password) {
        return credential.account;
      }
    }
    throw const MockAuthException();
  }
}

class _MockCredential {
  const _MockCredential({
    required this.email,
    required this.password,
    required this.account,
  });

  final String email;
  final String password;
  final AuthAccount account;
}
