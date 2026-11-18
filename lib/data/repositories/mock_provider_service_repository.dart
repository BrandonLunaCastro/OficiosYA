import 'package:oficios/data/mocks/mock_provider_services.dart';
import 'package:oficios/data/repositories/provider_service_repository.dart';
import 'package:oficios/models/provider_service.dart';

class MockProviderServiceRepository implements ProviderServiceRepository {
  MockProviderServiceRepository() : _services = List.of(mockProviderServices);

  final List<ProviderService> _services;
  int _nextId = mockProviderServices.length + 1;

  @override
  Future<List<ProviderService>> getServices() async =>
      List.unmodifiable(_services);

  @override
  Future<ProviderService> addService({
    required String title,
    required String description,
  }) async {
    final normalizedTitle = title.trim();
    final normalizedDescription = description.trim();
    if (normalizedTitle.isEmpty || normalizedDescription.isEmpty) {
      throw ArgumentError('El título y la descripción son obligatorios.');
    }

    final service = ProviderService(
      id: 'servicio-mock-${_nextId++}',
      title: normalizedTitle,
      description: normalizedDescription,
    );
    _services.add(service);
    return service;
  }

  @override
  Future<void> updateService(ProviderService service) async {
    final index = _services.indexWhere((item) => item.id == service.id);
    if (index == -1) {
      throw StateError('No se encontró el servicio ${service.id}.');
    }
    if (service.title.trim().isEmpty || service.description.trim().isEmpty) {
      throw ArgumentError('El título y la descripción son obligatorios.');
    }

    _services[index] = service.copyWith(
      title: service.title.trim(),
      description: service.description.trim(),
    );
  }
}
