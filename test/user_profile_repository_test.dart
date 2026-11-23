import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/models/user_profile.dart';
import 'package:oficios/data/repositories/in_memory_user_profile_repository.dart';

void main() {
  group('InMemoryUserProfileRepository', () {
    test(
      'devuelve el perfil inicial y persiste el perfil actualizado',
      () async {
        const initialProfile = UserProfile(name: 'Ana Pérez');
        final repository = InMemoryUserProfileRepository(
          initialProfile: initialProfile,
        );
        const updatedProfile = UserProfile(
          name: 'Ana Pérez',
          location: 'Mendoza',
        );

        expect(repository.getProfile(), initialProfile);

        await repository.saveProfile(updatedProfile);

        expect(repository.getProfile(), updatedProfile);
      },
    );

    test('restores a saved profile when switching accounts', () async {
      final repository = InMemoryUserProfileRepository();
      const maipuClient = UserProfile(
        id: 'client-maipu',
        name: 'Cliente Maipú',
        location: 'Maipú, Mendoza',
      );
      const capitalClient = UserProfile(
        id: 'client-capital',
        name: 'Cliente Capital',
        location: 'Mendoza Capital, Mendoza',
      );

      await repository.activateProfile(maipuClient);
      await repository.saveProfile(maipuClient);
      await repository.activateProfile(capitalClient);
      await repository.activateProfile(maipuClient);

      expect(repository.getProfile().location, 'Maipú, Mendoza');
    });
  });
}
