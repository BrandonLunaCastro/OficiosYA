import 'package:oficios/data/mocks/mock_provider_contact_info.dart';
import 'package:oficios/data/mocks/mock_professional_profile.dart';
import 'package:oficios/models/professional_profile.dart';
import 'package:oficios/models/provider_contact_info.dart';
import 'package:oficios/models/user_profile.dart';

enum MockAccountRole { client, professional }

class MockAccount {
  const MockAccount({
    required this.email,
    required this.role,
    this.clientProfile,
    this.professionalProfile,
    this.providerContactInfo,
  });

  final String email;
  final MockAccountRole role;
  final UserProfile? clientProfile;
  final ProfessionalProfile? professionalProfile;
  final ProviderContactInfo? providerContactInfo;
}

class MockAuthException implements Exception {
  const MockAuthException();

  @override
  String toString() => 'El correo o la contraseña no son correctos.';
}

class MockAuthRepository {
  const MockAuthRepository();

  static const _accounts = [
    _MockCredential(
      email: 'cliente@oficiosya.com',
      password: 'Cliente123',
      account: MockAccount(
        email: 'cliente@oficiosya.com',
        role: MockAccountRole.client,
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
      account: MockAccount(
        email: 'prestador@oficiosya.com',
        role: MockAccountRole.professional,
        professionalProfile: mockProfessionalProfile,
        providerContactInfo: mockProviderContactInfo,
      ),
    ),
  ];

  Future<MockAccount> signIn({
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
  final MockAccount account;
}
