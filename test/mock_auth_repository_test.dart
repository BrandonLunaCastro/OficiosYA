import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/repositories/mock_auth_repository.dart';

void main() {
  const repository = MockAuthRepository();

  test('authenticates the demo client account', () async {
    final account = await repository.signIn(
      email: ' CLIENTE@OFICIOSYA.COM ',
      password: 'Cliente123',
    );

    expect(account.role, MockAccountRole.client);
    expect(account.clientProfile?.name, 'Lucas Gómez');
    expect(account.clientProfile?.phone, '+54 9 261 555-1234');
  });

  test('authenticates the demo professional account', () async {
    final account = await repository.signIn(
      email: 'prestador@oficiosya.com',
      password: 'Prestador123',
    );

    expect(account.role, MockAccountRole.professional);
    expect(account.professionalProfile?.name, 'Carlos Rodriguez');
    expect(account.providerContactInfo?.email, 'carlos.rod@outlook.com');
  });

  test('rejects invalid credentials', () async {
    await expectLater(
      repository.signIn(
        email: 'prestador@oficiosya.com',
        password: 'incorrecta',
      ),
      throwsA(isA<MockAuthException>()),
    );
  });
}
