import 'package:oficios/models/order_request.dart';
import 'package:oficios/models/provider.dart';
import 'package:oficios/repositories/mock_service_repository.dart';

class OficiosRepository {
  OficiosRepository._();

  static final OficiosRepository instance = OficiosRepository._();

  List<Provider> obtenerPrestadores() => List.unmodifiable(mockProviders);

  List<OrderRequest> obtenerSolicitudes() => List.unmodifiable(mockOrders);

  Provider? buscarPrestadorPorId(String id) {
    for (final prestador in mockProviders) {
      if (prestador.id == id) {
        return prestador;
      }
    }
    return null;
  }

  List<Provider> filtrarPorCategoria(String categoria) {
    final filtro = categoria.trim().toLowerCase();
    if (filtro.isEmpty) {
      return obtenerPrestadores();
    }

    return obtenerPrestadores().where((prestador) {
      final categoriaPrestador = prestador.categoria.toLowerCase();
      final specialty = prestador.specialty.toLowerCase();
      return categoriaPrestador.contains(filtro) ||
          specialty.contains(filtro);
    }).toList();
  }

  List<Provider> filtrarPorZona(String zona) {
    final filtro = zona.trim().toLowerCase();
    if (filtro.isEmpty) {
      return obtenerPrestadores();
    }

    return obtenerPrestadores().where((prestador) {
      return prestador.coverageZone.toLowerCase().contains(filtro);
    }).toList();
  }

  List<Provider> buscarPrestadores({
    String query = '',
    String? categoria,
    String? zona,
    double? ratingMin,
    double? maxDistanceKm,
  }) {
    final consulta = query.trim().toLowerCase();
    final categoriaFiltro = categoria?.trim().toLowerCase();
    final zonaFiltro = zona?.trim().toLowerCase();

    return obtenerPrestadores().where((prestador) {
      final matchesQuery = consulta.isEmpty ||
          prestador.name.toLowerCase().contains(consulta) ||
          prestador.specialty.toLowerCase().contains(consulta) ||
          prestador.categoria.toLowerCase().contains(consulta);

      final matchesCategoria = categoriaFiltro == null ||
          categoriaFiltro.isEmpty ||
          prestador.categoria.toLowerCase().contains(categoriaFiltro) ||
          prestador.specialty.toLowerCase().contains(categoriaFiltro);

      final matchesZona = zonaFiltro == null ||
          zonaFiltro.isEmpty ||
          prestador.coverageZone.toLowerCase().contains(zonaFiltro);

      final matchesRating = ratingMin == null || prestador.rating >= ratingMin;

      final matchesDistance = maxDistanceKm == null || prestador.distanceKm <= maxDistanceKm;

      return matchesQuery &&
          matchesCategoria &&
          matchesZona &&
          matchesRating &&
          matchesDistance;
    }).toList();
  }
}
