import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/repositories/mock_professional_profile_repository.dart';

void main() {
  test('loads mock professional profile data', () async {
    final repository = MockProfessionalProfileRepository();

    final profile = await repository.getProfile();

    expect(profile.name, 'Carlos Rodriguez');
    expect(profile.specialty, 'Plomería y Gasista');
    expect(profile.rating, 4.8);
    expect(profile.reviews, 45);
    expect(profile.publishedServices, 3);
  });

  test('updates professional details without changing mock ratings', () async {
    final repository = MockProfessionalProfileRepository();
    final profile = await repository.getProfile();

    await repository.updateProfile(
      profile.copyWith(
        initials: 'MG',
        name: 'María Gómez',
        specialty: 'Electricista',
        about: 'Instalaciones y reparaciones.',
      ),
    );
    final updated = await repository.getProfile();

    expect(updated.name, 'María Gómez');
    expect(updated.initials, 'MG');
    expect(updated.rating, 4.8);
    expect(updated.reviews, 45);
  });
}
