import 'package:oficios/models/professional_profile.dart';

abstract interface class ProfessionalProfileRepository {
  Future<ProfessionalProfile> getProfile();

  Future<void> updateProfile(ProfessionalProfile profile);
}
