import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/repositories/mock_provider_repository.dart';
import 'package:oficios/data/repositories/mock_professional_profile_repository.dart';
import 'package:oficios/data/repositories/mock_provider_contact_repository.dart';
import 'package:oficios/models/provider_contact_info.dart';

void main() {
  group('MockProviderRepository', () {
    test('loads mock providers asynchronously', () async {
      const repository = MockProviderRepository();

      final providers = await repository.getProviders();

      expect(providers, isNotEmpty);
      expect(providers.first.name, 'Carlos Rodríguez');
    });

    test('searches providers by query, rating, and distance', () async {
      const repository = MockProviderRepository();

      final providers = await repository.searchProviders(
        query: 'Carlos',
        ratingMin: 4.5,
        maxDistanceKm: 5,
      );

      expect(providers, hasLength(1));
      expect(providers.single.name, 'Carlos Rodríguez');
    });

    test('filters providers by selected category', () async {
      const repository = MockProviderRepository();

      final providers = await repository.searchProviders(
        category: 'Electricidad',
      );

      expect(providers, hasLength(5));
      expect(
        providers.every(
          (provider) =>
              provider.categoria == 'electricidad' ||
              provider.specialty.toLowerCase().contains('electricista'),
        ),
        isTrue,
      );
    });

    test('does not expose a mutable provider list', () async {
      const repository = MockProviderRepository();
      final providers = await repository.getProviders();

      expect(() => providers.clear(), throwsUnsupportedError);
    });

    test('filters providers by the client locality', () async {
      const repository = MockProviderRepository();

      final maipuProviders = await repository.searchProviders(
        location: 'Maipú',
      );
      final capitalProviders = await repository.searchProviders(
        location: 'Mendoza Capital',
      );

      expect(
        maipuProviders.every(
          (provider) =>
              provider.coverageZone.toLowerCase().contains('maip') ||
              provider.coverageZone.toLowerCase().contains('mendoza'),
        ),
        isTrue,
      );
      expect(
        maipuProviders.any((provider) => provider.coverageZone == 'Maipú'),
        isTrue,
      );
      expect(
        capitalProviders.every(
          (provider) =>
              provider.coverageZone.toLowerCase().contains('capital') ||
              provider.coverageZone.toLowerCase().contains('mendoza'),
        ),
        isTrue,
      );
    });

    test(
      'shows at least three examples after changing client locality',
      () async {
        const repository = MockProviderRepository();
        const zones = {
          'Maipú': 'Maipú, Mendoza',
          'Mendoza Capital': 'Mendoza Capital, Mendoza',
          'Godoy Cruz': 'Godoy Cruz, Mendoza',
          'Las Heras': 'Las Heras, Mendoza',
          'Luján de Cuyo': 'Luján de Cuyo, Mendoza',
          'San Martín': 'San Martín, Mendoza',
        };

        for (final entry in zones.entries) {
          final providers = await repository.getProviders(
            location: entry.value,
          );

          expect(
            providers.length,
            greaterThanOrEqualTo(3),
            reason: 'La zona ${entry.key} debe tener al menos tres ejemplos.',
          );
          expect(
            providers.every(
              (provider) =>
                  provider.coverageZone.toLowerCase().contains(
                    entry.key.toLowerCase().split(' ').first,
                  ) ||
                  (entry.key == 'Mendoza Capital' &&
                      provider.coverageZone.toLowerCase().contains('capital')),
            ),
            isTrue,
            reason: 'No deben mezclarse prestadores de otras zonas.',
          );
        }
      },
    );

    test(
      'includes a professional service created by the active profile',
      () async {
        final profileRepository = MockProfessionalProfileRepository();
        final contactRepository = MockProviderContactRepository();
        await profileRepository.updateProfile(
          (await profileRepository.getProfile()).copyWith(
            id: 'prestador-maipu',
            name: 'Ana Maipú',
            location: 'Maipú',
          ),
        );
        await contactRepository.updateContactInfo(
          const ProviderContactInfo(
            city: 'Maipú',
            province: 'Mendoza',
            coverageZone: 'Maipú',
            phone: '2615550001',
            email: 'ana@oficios.com',
          ),
        );
        final repository = MockProviderRepository(
          professionalProfileRepository: profileRepository,
          providerContactRepository: contactRepository,
        );

        final maipuProviders = await repository.searchProviders(
          location: 'Maipú',
        );
        final capitalProviders = await repository.searchProviders(
          location: 'Mendoza Capital',
        );

        expect(
          maipuProviders.any((provider) => provider.name == 'Ana Maipú'),
          isTrue,
        );
        expect(
          capitalProviders.any((provider) => provider.name == 'Ana Maipú'),
          isFalse,
        );
      },
    );
  });
}
