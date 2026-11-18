import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/repositories/mock_provider_service_repository.dart';
import 'package:oficios/models/provider_service.dart';

void main() {
  group('MockProviderServiceRepository', () {
    test('loads mock services without exposing a mutable list', () async {
      final repository = MockProviderServiceRepository();

      final services = await repository.getServices();

      expect(services, hasLength(3));
      expect(services.first.title, 'Reparaciones de plomería');
      expect(() => services.clear(), throwsUnsupportedError);
    });

    test('adds and updates services in the session repository', () async {
      final repository = MockProviderServiceRepository();

      final added = await repository.addService(
        title: '  Instalación de termotanques ',
        description: ' Instalación y mantenimiento. ',
      );
      await repository.updateService(
        added.copyWith(
          title: 'Termotanques',
          description: 'Instalación segura.',
        ),
      );

      final services = await repository.getServices();

      expect(services, hasLength(4));
      expect(services.last.title, 'Termotanques');
      expect(services.last.description, 'Instalación segura.');
    });

    test('rejects invalid service data and unknown service ids', () async {
      final repository = MockProviderServiceRepository();

      await expectLater(
        repository.addService(title: ' ', description: 'Descripción'),
        throwsArgumentError,
      );
      await expectLater(
        repository.updateService(
          const ProviderService(
            id: 'missing',
            title: 'Título',
            description: 'Descripción',
          ),
        ),
        throwsStateError,
      );
    });
  });
}
