import 'package:oficios/models/provider.dart';

abstract interface class ProviderRepository {
  Future<List<Provider>> getProviders();

  Future<List<Provider>> searchProviders({
    String query = '',
    double? ratingMin,
    double? maxDistanceKm,
  });
}
