class UserProfile {
  UserProfile._();
  static final UserProfile instance = UserProfile._();

  String name = '';
  String email = '';
  String phone = '';
  String location = '';

  String get initials {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}