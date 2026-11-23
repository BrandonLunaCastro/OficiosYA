import 'package:oficios/data/mocks/mock_provider.dart';
import 'package:oficios/data/database/app_database.dart';
import 'package:oficios/models/provider.dart';
import 'package:oficios/data/repositories/provider_repository.dart';
import 'package:oficios/data/repositories/professional_profile_repository.dart';
import 'package:oficios/data/repositories/provider_contact_repository.dart';

class MockProviderRepository implements ProviderRepository {
  const MockProviderRepository({
    this.professionalProfileRepository,
    this.providerContactRepository,
    this.database,
  });

  final ProfessionalProfileRepository? professionalProfileRepository;
  final ProviderContactRepository? providerContactRepository;
  final AppDatabase? database;

  @override
  Future<List<Provider>> getProviders({String? location}) async {
    final providers = await _combinedProviders();
    final filtered = _filterByLocation(providers, location);
    return List.unmodifiable(filtered);
  }

  @override
  Future<List<Provider>> searchProviders({
    String query = '',
    String? category,
    double? ratingMin,
    double? maxDistanceKm,
    String? location,
  }) async {
    final normalizedQuery = query.trim().toLowerCase();
    final normalizedCategory = category?.trim().toLowerCase();
    final providers = await _combinedProviders();
    return _filterByLocation(providers, location).where((provider) {
      final matchesQuery =
          normalizedQuery.isEmpty ||
          provider.name.toLowerCase().contains(normalizedQuery) ||
          provider.specialty.toLowerCase().contains(normalizedQuery) ||
          provider.categoria.toLowerCase().contains(normalizedQuery);
      final matchesCategory =
          normalizedCategory == null ||
          normalizedCategory.isEmpty ||
          provider.categoria.toLowerCase().contains(normalizedCategory) ||
          provider.specialty.toLowerCase().contains(normalizedCategory);
      final matchesRating = ratingMin == null || provider.rating >= ratingMin;
      final matchesDistance =
          maxDistanceKm == null || provider.distanceKm <= maxDistanceKm;
      return matchesQuery &&
          matchesCategory &&
          matchesRating &&
          matchesDistance;
    }).toList();
  }

  Future<List<Provider>> _combinedProviders() async {
    final combined = List<Provider>.of(mockProviders);
    final database = this.database;
    if (database != null) {
      final databaseProviders = await _databaseProviders(database);
      for (final provider in databaseProviders) {
        _replaceProvider(combined, provider);
      }
    }

    final profileRepository = professionalProfileRepository;
    final contactRepository = providerContactRepository;
    if (profileRepository == null || contactRepository == null) {
      return combined;
    }

    final profile = await profileRepository.getProfile();
    final contact = await contactRepository.getContactInfo();
    _replaceProvider(
      combined,
      Provider(
        id: profile.id.isNotEmpty ? profile.id : 'prestador-${profile.name}',
        initials: profile.initials,
        name: profile.name,
        specialty: profile.specialty,
        categoria: profile.specialty,
        rating: profile.rating,
        reviews: profile.reviews,
        distanceKm: 0,
        jobsCount: profile.publishedServices,
        aboutMe: profile.about,
        phone: contact.phone,
        email: contact.email,
        location: '${contact.city}, ${contact.province}',
        coverageZone: contact.coverageZone,
        availabilityStatus: 'Disponible',
      ),
    );

    return combined;
  }

  Future<List<Provider>> _databaseProviders(AppDatabase database) async {
    final sql = await database.database;
    final profileRows = await sql.query('professional_profiles');
    final contactRows = await sql.query('professional_contacts');
    final contactsById = {
      for (final row in contactRows) row['profile_id'] as String: row,
    };

    return profileRows
        .where((row) => contactsById.containsKey(row['profile_id']))
        .map((row) {
          final contact = contactsById[row['profile_id']]!;
          return Provider(
            id: row['profile_id'] as String,
            initials: row['initials'] as String,
            name: row['name'] as String,
            specialty: row['specialty'] as String,
            categoria: row['specialty'] as String,
            rating: (row['rating'] as num).toDouble(),
            reviews: row['reviews'] as int,
            distanceKm: 0,
            jobsCount: row['published_services'] as int,
            aboutMe: row['about'] as String,
            phone: contact['phone'] as String,
            email: contact['email'] as String,
            location: '${contact['city']}, ${contact['province']}',
            coverageZone: contact['coverage_zone'] as String,
            availabilityStatus: 'Disponible',
          );
        })
        .toList();
  }

  void _replaceProvider(List<Provider> providers, Provider provider) {
    final index = providers.indexWhere((item) => item.id == provider.id);
    if (index == -1) {
      providers.insert(0, provider);
    } else {
      providers[index] = provider;
    }
  }

  List<Provider> _filterByLocation(List<Provider> providers, String? location) {
    final locality = _locality(location);
    if (locality == null) return providers;

    return providers.where((provider) {
      final coverage = _normalize(provider.coverageZone);
      final providerLocality = _locality(provider.location);
      return providerLocality == locality || coverage.contains(locality);
    }).toList();
  }

  String? _locality(String? location) {
    if (location == null || location.trim().isEmpty) return null;
    final firstPart = location.split(',').first.trim();
    final normalized = _normalize(firstPart);
    if (normalized.isEmpty) return null;
    if (normalized == 'mendoza capital' ||
        normalized == 'capital' ||
        normalized == 'mendoza') {
      return 'capital';
    }
    if (normalized == 'lujan de cuyo') return 'lujan';
    return normalized;
  }

  String _normalize(String value) {
    final normalized = value
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[áàä]'), 'a')
        .replaceAll(RegExp(r'[éèë]'), 'e')
        .replaceAll(RegExp(r'[íìï]'), 'i')
        .replaceAll(RegExp(r'[óòö]'), 'o')
        .replaceAll(RegExp(r'[úùü]'), 'u')
        .replaceAll(RegExp(r'ñ'), 'n');
    return normalized.replaceAll(RegExp(r'\s+'), ' ');
  }
}
