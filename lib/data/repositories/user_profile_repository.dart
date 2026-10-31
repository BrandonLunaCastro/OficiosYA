import 'package:oficios/models/user_profile.dart';

abstract interface class UserProfileRepository {
  UserProfile getProfile();

  void saveProfile(UserProfile profile);
}
