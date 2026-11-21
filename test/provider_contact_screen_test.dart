import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/repositories/mock_provider_contact_repository.dart';
import 'package:oficios/data/repositories/mock_provider_service_repository.dart';
import 'package:oficios/data/repositories/mock_professional_profile_repository.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/ui/screens/professional_profile_screen.dart';
import 'package:oficios/ui/screens/provider_contact_screen.dart';
import 'package:oficios/ui/screens/provider_services_screen.dart';

void main() {
  testWidgets('edits contact details and shows location on provider profile', (
    tester,
  ) async {
    final profileRepository = MockProfessionalProfileRepository();
    final contactRepository = MockProviderContactRepository();
    final serviceRepository = MockProviderServiceRepository();
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          AppRoutes.professionalProfile: (_) => ProfessionalProfileScreen(
            profileRepository: profileRepository,
            serviceRepository: serviceRepository,
            contactRepository: contactRepository,
          ),
          AppRoutes.providerServices: (_) =>
              ProviderServicesScreen(serviceRepository: serviceRepository),
        },
        home: ProviderContactScreen(contactRepository: contactRepository),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mendoza Capital, Mendoza'), findsOneWidget);
    expect(find.text('+54 9 261 444-5678'), findsOneWidget);
    expect(find.text('carlos.rod@outlook.com'), findsOneWidget);

    await tester.tap(find.text('Editar ubicación y cobertura'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Godoy Cruz');
    await tester.tap(find.text('Guardar cambios'));
    await tester.pumpAndSettle();

    expect(find.text('Godoy Cruz, Mendoza'), findsOneWidget);

    await tester.tap(find.text('Editar medios de contacto'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).at(0),
      '+54 9 261 555-1234',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'prestador@correo.com',
    );
    await tester.tap(find.text('Guardar cambios'));
    await tester.pumpAndSettle();

    expect(find.text('prestador@correo.com'), findsOneWidget);

    await tester.tap(find.text('Mi perfil'));
    await tester.pumpAndSettle();
    expect(find.text('Godoy Cruz'), findsOneWidget);
    expect(find.text('Godoy Cruz · Capital y alrededores'), findsOneWidget);
  });
}
