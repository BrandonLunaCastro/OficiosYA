import 'package:oficios/models/provider_review.dart';

class ProfessionalProfile {
  final String id;
  final String initials;
  final String name;
  final String specialty;
  final String location;
  final double rating;
  final int reviews;
  final String about;
  final int publishedServices;
  final ProviderReviewSummary? initialReviewSummary;

  const ProfessionalProfile({
    this.id = '',
    required this.initials,
    required this.name,
    required this.specialty,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.about,
    required this.publishedServices,
    this.initialReviewSummary,
  });

  ProfessionalProfile copyWith({
    String? id,
    String? initials,
    String? name,
    String? specialty,
    String? location,
    double? rating,
    int? reviews,
    String? about,
    int? publishedServices,
    ProviderReviewSummary? initialReviewSummary,
  }) {
    return ProfessionalProfile(
      id: id ?? this.id,
      initials: initials ?? this.initials,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      about: about ?? this.about,
      publishedServices: publishedServices ?? this.publishedServices,
      initialReviewSummary:
          initialReviewSummary ?? this.initialReviewSummary,
    );
  }
}
