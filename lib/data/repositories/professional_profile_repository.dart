import 'package:oficios/models/professional_profile.dart';

abstract interface class ProfessionalProfileRepository {
  Future<ProfessionalProfile> getProfile();

  Future<ProfessionalProfile> activateProfile(ProfessionalProfile fallback);

  Future<void> updateProfile(ProfessionalProfile profile);
}
