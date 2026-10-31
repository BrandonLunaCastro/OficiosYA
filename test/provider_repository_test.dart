import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/repositories/mock_provider_repository.dart';

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

      expect(providers, hasLength(2));
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
  });
}
