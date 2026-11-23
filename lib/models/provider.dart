import 'package:oficios/models/provider_review.dart';

class Provider {
  final String id;
  final String initials;
  final String name;
  final String specialty;
  final String categoria;
  final double rating;
  final int reviews;
  final double distanceKm;
  final int jobsCount;
  final String aboutMe;
  final String phone;
  final String email;
  final String location;
  final String coverageZone;
  final String availabilityStatus;
  final ProviderReviewSummary? initialReviewSummary;

  const Provider({
    this.id = '',
    required this.initials,
    required this.name,
    required this.specialty,
    this.categoria = '',
    required this.rating,
    required this.reviews,
    required this.distanceKm,
    required this.jobsCount,
    this.aboutMe = '',
    this.phone = '',
    this.email = '',
    this.location = '',
    this.coverageZone = 'Mendoza Capital',
    this.availabilityStatus = 'Disponible esta semana',
    this.initialReviewSummary,
  });
}
