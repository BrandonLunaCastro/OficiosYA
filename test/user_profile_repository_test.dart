import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/models/user_profile.dart';
import 'package:oficios/data/repositories/in_memory_user_profile_repository.dart';

void main() {
  group('InMemoryUserProfileRepository', () {
    test('devuelve el perfil inicial y persiste el perfil actualizado', () {
      const initialProfile = UserProfile(name: 'Ana Pérez');
      final repository = InMemoryUserProfileRepository(
        initialProfile: initialProfile,
      );
      const updatedProfile = UserProfile(
        name: 'Ana Pérez',
        location: 'Mendoza',
      );

      expect(repository.getProfile(), initialProfile);

      repository.saveProfile(updatedProfile);

      expect(repository.getProfile(), updatedProfile);
    });
  });
}
