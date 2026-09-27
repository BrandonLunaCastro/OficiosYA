class Provider {
  final String initials;
  final String name;
  final String specialty;
  final double rating;
  final int reviews;
  final double distanceKm;
  final int jobsCount;
  final String aboutMe;
  final String phone;
  final String email;

  const Provider({
    required this.initials,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviews,
    required this.distanceKm,
    required this.jobsCount,
    this.aboutMe = '',
    this.phone = '',
    this.email = '',
  });
}