import 'package:oficios/models/provider_service.dart';

abstract interface class ProviderServiceRepository {
  Future<List<ProviderService>> getServices();

  Future<ProviderService> addService({
    required String title,
    required String description,
  });

  Future<void> updateService(ProviderService service);
}
