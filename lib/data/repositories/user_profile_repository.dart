import 'package:oficios/models/user_profile.dart';

abstract interface class UserProfileRepository {
  UserProfile getProfile();

  Future<UserProfile> activateProfile(UserProfile fallback);

  Future<void> saveProfile(UserProfile profile);
}
