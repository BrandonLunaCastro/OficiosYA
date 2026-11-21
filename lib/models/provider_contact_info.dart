class ProviderContactInfo {
  final String city;
  final String province;
  final String coverageZone;
  final String phone;
  final String email;

  const ProviderContactInfo({
    required this.city,
    required this.province,
    required this.coverageZone,
    required this.phone,
    required this.email,
  });

  ProviderContactInfo copyWith({
    String? city,
    String? province,
    String? coverageZone,
    String? phone,
    String? email,
  }) {
    return ProviderContactInfo(
      city: city ?? this.city,
      province: province ?? this.province,
      coverageZone: coverageZone ?? this.coverageZone,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }
}
