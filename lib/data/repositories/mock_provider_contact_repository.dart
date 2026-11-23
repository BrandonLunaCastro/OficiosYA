import 'package:oficios/data/mocks/mock_provider_contact_info.dart';
import 'package:oficios/data/repositories/provider_contact_repository.dart';
import 'package:oficios/models/provider_contact_info.dart';

class MockProviderContactRepository implements ProviderContactRepository {
  MockProviderContactRepository() : _contactInfo = mockProviderContactInfo;

  ProviderContactInfo _contactInfo;

  @override
  Future<ProviderContactInfo> getContactInfo() async => _contactInfo;

  @override
  Future<ProviderContactInfo> activateProfile({
    required String profileId,
    required ProviderContactInfo fallback,
  }) async {
    _contactInfo = fallback.copyWith(profileId: profileId);
    return _contactInfo;
  }

  @override
  Future<void> updateContactInfo(ProviderContactInfo contactInfo) async {
    final values = [
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
      city: contactInfo.city.trim(),
      province: contactInfo.province.trim(),
      coverageZone: contactInfo.coverageZone.trim(),
      phone: contactInfo.phone.trim(),
      email: contactInfo.email.trim(),
    );
  }
}
