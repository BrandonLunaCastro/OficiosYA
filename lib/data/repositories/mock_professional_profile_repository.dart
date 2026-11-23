import 'package:oficios/data/mocks/mock_professional_profile.dart';
import 'package:oficios/data/repositories/professional_profile_repository.dart';
import 'package:oficios/models/professional_profile.dart';

class MockProfessionalProfileRepository
    implements ProfessionalProfileRepository {
  MockProfessionalProfileRepository() : _profile = mockProfessionalProfile;

  ProfessionalProfile _profile;

  @override
  Future<ProfessionalProfile> getProfile() async => _profile;

  @override
  Future<ProfessionalProfile> activateProfile(
    ProfessionalProfile fallback,
  ) async {
    _profile = fallback;
    return _profile;
  }

  @override
  Future<void> updateProfile(ProfessionalProfile profile) async {
    if (profile.name.trim().isEmpty ||
        profile.specialty.trim().isEmpty ||
        profile.about.trim().isEmpty) {
      throw ArgumentError(
        'El nombre, el oficio y la descripción son obligatorios.',
      );
    }

    _profile = profile.copyWith(
      initials: profile.initials.trim(),
      name: profile.name.trim(),
      specialty: profile.specialty.trim(),
      location: profile.location.trim(),
      about: profile.about.trim(),
    );
  }
}
