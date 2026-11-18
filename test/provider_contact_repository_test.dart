import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/repositories/mock_provider_contact_repository.dart';

void main() {
  test('loads and updates mock provider contact information', () async {
    final repository = MockProviderContactRepository();

    final original = await repository.getContactInfo();
    expect(original.city, 'Mendoza Capital');
    expect(original.coverageZone, 'Capital y alrededores');

    await repository.updateContactInfo(
      original.copyWith(city: 'Godoy Cruz', email: ' prestador@correo.com '),
    );
    final updated = await repository.getContactInfo();

    expect(updated.city, 'Godoy Cruz');
    expect(updated.email, 'prestador@correo.com');
    expect(updated.phone, original.phone);
  });

  test('rejects empty contact information', () async {
    final repository = MockProviderContactRepository();
    final contactInfo = await repository.getContactInfo();

    await expectLater(
      repository.updateContactInfo(contactInfo.copyWith(email: ' ')),
      throwsArgumentError,
    );
  });
}
