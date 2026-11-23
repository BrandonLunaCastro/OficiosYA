import 'package:oficios/models/provider_contact_info.dart';

abstract interface class ProviderContactRepository {
  Future<ProviderContactInfo> getContactInfo();

  Future<ProviderContactInfo> activateProfile({
    required String profileId,
    required ProviderContactInfo fallback,
  });

  Future<void> updateContactInfo(ProviderContactInfo contactInfo);
}
