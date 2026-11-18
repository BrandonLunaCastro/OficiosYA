import 'package:oficios/models/provider_contact_info.dart';

abstract interface class ProviderContactRepository {
  Future<ProviderContactInfo> getContactInfo();

  Future<void> updateContactInfo(ProviderContactInfo contactInfo);
}
