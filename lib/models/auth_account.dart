import 'package:oficios/models/professional_profile.dart';
import 'package:oficios/models/provider_contact_info.dart';
import 'package:oficios/models/user_profile.dart';

enum AccountRole { client, professional }

class AuthAccount {
  const AuthAccount({
    required this.email,
    required this.role,
    this.clientProfile,
    this.professionalProfile,
    this.providerContactInfo,
  });

  final String email;
  final AccountRole role;
  final UserProfile? clientProfile;
  final ProfessionalProfile? professionalProfile;
  final ProviderContactInfo? providerContactInfo;
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
