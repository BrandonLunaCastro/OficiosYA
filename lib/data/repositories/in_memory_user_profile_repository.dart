import 'package:oficios/data/repositories/user_profile_repository.dart';
import 'package:oficios/models/user_profile.dart';

class InMemoryUserProfileRepository implements UserProfileRepository {
  InMemoryUserProfileRepository({
    UserProfile initialProfile = const UserProfile(),
  }) : _profile = initialProfile;

  static final instance = InMemoryUserProfileRepository();

  UserProfile _profile;
  final Map<String, UserProfile> _profilesById = {};

  @override
  UserProfile getProfile() => _profile;

  @override
  Future<UserProfile> activateProfile(UserProfile fallback) async {
    _profile = _profilesById[fallback.id] ?? fallback;
    return _profile;
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    _profile = profile;
    if (profile.id.isNotEmpty) {
      _profilesById[profile.id] = profile;
    }
  }
}
