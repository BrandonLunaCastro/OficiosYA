import 'package:oficios/data/repositories/user_profile_repository.dart';
import 'package:oficios/models/user_profile.dart';

class InMemoryUserProfileRepository implements UserProfileRepository {
  InMemoryUserProfileRepository({
    UserProfile initialProfile = const UserProfile(),
  }) : _profile = initialProfile;

  static final instance = InMemoryUserProfileRepository();

  UserProfile _profile;

  @override
  UserProfile getProfile() => _profile;

  @override
  void saveProfile(UserProfile profile) {
    _profile = profile;
  }
}
