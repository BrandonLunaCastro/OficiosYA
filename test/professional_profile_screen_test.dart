import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/repositories/mock_provider_contact_repository.dart';
import 'package:oficios/data/repositories/mock_provider_service_repository.dart';
import 'package:oficios/data/repositories/mock_professional_profile_repository.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/ui/screens/edit_profile_professional_screen.dart';
import 'package:oficios/ui/screens/professional_profile_screen.dart';

void main() {
  testWidgets('shows the provider profile and opens profile editing', (
    tester,
  ) async {
    final profileRepository = MockProfessionalProfileRepository();
    final serviceRepository = MockProviderServiceRepository();
    final contactRepository = MockProviderContactRepository();
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          AppRoutes.editProfileProfessional: (_) =>
              EditProfileProfessionalScreen(
                profileRepository: profileRepository,
                contactRepository: contactRepository,
              ),
          AppRoutes.professionalProfile: (_) => ProfessionalProfileScreen(
            profileRepository: profileRepository,
            serviceRepository: serviceRepository,
            contactRepository: contactRepository,
          ),
        },
        home: ProfessionalProfileScreen(
          profileRepository: profileRepository,
          serviceRepository: serviceRepository,
          contactRepository: contactRepository,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mi perfil'), findsNWidgets(2));
    expect(find.text('Carlos Rodriguez'), findsOneWidget);
    expect(find.text('3 servicios publicados'), findsOneWidget);
    expect(
      find.text('Mendoza Capital · Capital y alrededores'),
      findsOneWidget,
    );
    expect(find.text('Reseñas'), findsOneWidget);

    await tester.tap(find.text('Editar perfil profesional'));
    await tester.pumpAndSettle();

    expect(find.text('Editar perfil profesional'), findsOneWidget);
    await tester.ensureVisible(find.text('Guardar perfil profesional'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar perfil profesional'));
    await tester.pumpAndSettle();

    expect(find.text('Editar perfil profesional'), findsOneWidget);
  });
}
