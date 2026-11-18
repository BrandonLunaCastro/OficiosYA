class ProfessionalProfile {
  final String initials;
  final String name;
  final String specialty;
  final String location;
  final double rating;
  final int reviews;
  final String about;
  final int publishedServices;

  const ProfessionalProfile({
    required this.initials,
    required this.name,
    required this.specialty,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.about,
    required this.publishedServices,
  });

  ProfessionalProfile copyWith({
    String? initials,
    String? name,
    String? specialty,
    String? location,
    double? rating,
    int? reviews,
    String? about,
    int? publishedServices,
  }) {
    return ProfessionalProfile(
      initials: initials ?? this.initials,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      about: about ?? this.about,
      publishedServices: publishedServices ?? this.publishedServices,
    );
  }
}
