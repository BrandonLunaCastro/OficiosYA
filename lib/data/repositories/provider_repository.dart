import 'package:oficios/models/provider.dart';

abstract interface class ProviderRepository {
  Future<List<Provider>> getProviders({String? location});

  Future<List<Provider>> searchProviders({
    String query = '',
    String? category,
    double? ratingMin,
    double? maxDistanceKm,
    String? location,
  });
}
