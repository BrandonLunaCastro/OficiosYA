import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/models/user_profile.dart';

void main() {
  group('UserProfile', () {
    test('construye un perfil con los datos proporcionados', () {
      final profile = UserProfile(
        id: 'user-1',
        name: 'Ana Pérez',
        email: 'ana@example.com',
        phone: '+54 261 123456',
        location: 'Mendoza',
      );

      expect(profile.id, 'user-1');
      expect(profile.name, 'Ana Pérez');
      expect(profile.email, 'ana@example.com');
      expect(profile.phone, '+54 261 123456');
      expect(profile.location, 'Mendoza');
    });

    test('convierte el perfil a mapa y lo reconstruye', () {
      final profile = UserProfile(
        id: 'user-1',
        name: 'Ana Pérez',
        email: 'ana@example.com',
        phone: '+54 261 123456',
        location: 'Mendoza',
      );

      expect(UserProfile.fromMap(profile.toMap()).toMap(), profile.toMap());
    });

    test('calcula iniciales sin fallar con espacios repetidos', () {
      final profile = UserProfile(name: '  Ana   Pérez  ');

      expect(profile.initials, 'AP');
      expect(UserProfile().initials, '?');
    });

    test('copyWith crea un perfil actualizado sin cambiar el original', () {
      const profile = UserProfile(name: 'Ana Pérez', email: 'ana@example.com');

      final updatedProfile = profile.copyWith(phone: '+54 261 123456');

      expect(profile.phone, isEmpty);
      expect(updatedProfile.name, profile.name);
      expect(updatedProfile.email, profile.email);
      expect(updatedProfile.phone, '+54 261 123456');
    });
  });
}
