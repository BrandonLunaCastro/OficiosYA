import 'package:oficios/data/mocks/mock_provider.dart';
import 'package:oficios/models/provider.dart';
import 'package:oficios/data/repositories/provider_repository.dart';

class MockProviderRepository implements ProviderRepository {
  const MockProviderRepository();

  @override
  Future<List<Provider>> getProviders() async =>
      List.unmodifiable(mockProviders);

  @override
  Future<List<Provider>> searchProviders({
    String query = '',
    double? ratingMin,
    double? maxDistanceKm,
  }) async {
    final normalizedQuery = query.trim().toLowerCase();
    return mockProviders.where((provider) {
      final matchesQuery =
          normalizedQuery.isEmpty ||
          provider.name.toLowerCase().contains(normalizedQuery) ||
          provider.specialty.toLowerCase().contains(normalizedQuery) ||
          provider.categoria.toLowerCase().contains(normalizedQuery);
      final matchesRating = ratingMin == null || provider.rating >= ratingMin;
      final matchesDistance =
          maxDistanceKm == null || provider.distanceKm <= maxDistanceKm;
      return matchesQuery && matchesRating && matchesDistance;
    }).toList();
  }
}
