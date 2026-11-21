import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/repositories/mock_provider_contact_repository.dart';
import 'package:oficios/data/repositories/mock_provider_service_repository.dart';
import 'package:oficios/data/repositories/mock_professional_profile_repository.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/ui/screens/edit_profile_professional_screen.dart';
import 'package:oficios/ui/screens/professional_profile_screen.dart';
import 'package:oficios/ui/screens/provider_contact_screen.dart';

void main() {
  testWidgets('creates a professional profile and shares saved contact data', (
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
          AppRoutes.providerContact: (_) =>
              ProviderContactScreen(contactRepository: contactRepository),
        },
        home: EditProfileProfessionalScreen(
          profileRepository: profileRepository,
          contactRepository: contactRepository,
          isInitialSetup: true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Crear perfil profesional'), findsNWidgets(2));
    await _enterField(tester, 'professional-name', 'María Gómez');
    await _enterField(tester, 'professional-specialty', 'Electricista');
    await _enterField(
      tester,
      'professional-description',
      'Instalaciones y reparaciones del hogar.',
    );
    await _enterField(tester, 'professional-location', 'Godoy Cruz, Mendoza');
    await _enterField(tester, 'professional-coverage', 'Gran Mendoza');
    await _enterField(tester, 'professional-phone', '+54 9 261 555-1234');
    await _enterField(tester, 'professional-email', 'maria@correo.com');

    await tester.ensureVisible(find.text('Crear perfil profesional').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Crear perfil profesional').last);
    await tester.pumpAndSettle();

    expect(find.text('María Gómez'), findsOneWidget);
    expect(find.text('Electricista'), findsOneWidget);
    expect(find.text('Godoy Cruz · Gran Mendoza'), findsOneWidget);

    await tester.tap(find.text('Contacto'));
    await tester.pumpAndSettle();

    expect(find.text('+54 9 261 555-1234'), findsOneWidget);
    expect(find.text('maria@correo.com'), findsOneWidget);
  });
}

Future<void> _enterField(WidgetTester tester, String key, String value) async {
  final field = find.byKey(ValueKey(key));
  await tester.ensureVisible(field);
  await tester.enterText(field, value);
  await tester.pumpAndSettle();
}
