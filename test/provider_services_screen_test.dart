import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/repositories/mock_provider_contact_repository.dart';
import 'package:oficios/data/repositories/mock_provider_service_repository.dart';
import 'package:oficios/data/repositories/mock_professional_profile_repository.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/ui/screens/professional_profile_screen.dart';
import 'package:oficios/ui/screens/provider_services_screen.dart';

void main() {
  testWidgets('adds a service and displays the shared profile count', (
    tester,
  ) async {
    final profileRepository = MockProfessionalProfileRepository();
    final serviceRepository = MockProviderServiceRepository();
    final contactRepository = MockProviderContactRepository();
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          AppRoutes.providerServices: (_) =>
              ProviderServicesScreen(serviceRepository: serviceRepository),
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

    await tester.tap(find.text('Servicios'));
    await tester.pumpAndSettle();

    expect(find.text('Servicios publicados · 3'), findsOneWidget);
    expect(find.text('Gasista matriculado'), findsOneWidget);

    await tester.tap(find.text('Agregar servicio'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Instalación de termotanques',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Instalación y mantenimiento.',
    );
    await tester.tap(find.text('Agregar'));
    await tester.pumpAndSettle();

    expect(find.text('Servicios publicados · 4'), findsOneWidget);
    expect(find.text('Instalación de termotanques'), findsOneWidget);

    await tester.ensureVisible(find.text('Editar servicio').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar servicio').first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Plomería residencial',
    );
    await tester.tap(find.text('Guardar cambios'));
    await tester.pumpAndSettle();

    expect(find.text('Plomería residencial'), findsOneWidget);

    await tester.tap(find.text('Mi perfil'));
    await tester.pumpAndSettle();

    expect(find.text('4 servicios publicados'), findsOneWidget);
  });
}
