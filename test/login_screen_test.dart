import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/repositories/in_memory_user_profile_repository.dart';
import 'package:oficios/data/repositories/mock_auth_repository.dart';
import 'package:oficios/data/repositories/mock_professional_profile_repository.dart';
import 'package:oficios/data/repositories/mock_provider_contact_repository.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/ui/screens/login_screen.dart';

void main() {
  testWidgets('routes the demo client directly to client home', (tester) async {
    final clientProfiles = InMemoryUserProfileRepository();
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          AppRoutes.clientHome: (_) =>
              const Scaffold(body: Text('Inicio del cliente')),
          AppRoutes.professionalProfile: (_) =>
              const Scaffold(body: Text('Perfil profesional')),
        },
        home: Login(
          authRepository: const MockAuthRepository(),
          clientProfileRepository: clientProfiles,
          professionalProfileRepository: MockProfessionalProfileRepository(),
          providerContactRepository: MockProviderContactRepository(),
        ),
      ),
    );

    await tester.enterText(
      find.byType(TextField).at(0),
      'cliente@oficiosya.com',
    );
    await tester.enterText(find.byType(TextField).at(1), 'Cliente123');
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();

    expect(find.text('Inicio del cliente'), findsOneWidget);
    expect(clientProfiles.getProfile().name, 'Lucas Gómez');
  });

  testWidgets('routes the demo professional directly to their profile', (
    tester,
  ) async {
    final professionalProfiles = MockProfessionalProfileRepository();
    final contactRepository = MockProviderContactRepository();
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          AppRoutes.clientHome: (_) =>
              const Scaffold(body: Text('Inicio del cliente')),
          AppRoutes.professionalProfile: (_) =>
              const Scaffold(body: Text('Perfil profesional')),
        },
        home: Login(
          authRepository: const MockAuthRepository(),
          clientProfileRepository: InMemoryUserProfileRepository(),
          professionalProfileRepository: professionalProfiles,
          providerContactRepository: contactRepository,
        ),
      ),
    );

    await tester.enterText(
      find.byType(TextField).at(0),
      'prestador@oficiosya.com',
    );
    await tester.enterText(find.byType(TextField).at(1), 'Prestador123');
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();

    expect(find.text('Perfil profesional'), findsOneWidget);
    expect((await professionalProfiles.getProfile()).name, 'Carlos Rodriguez');
    expect(
      (await contactRepository.getContactInfo()).email,
      'carlos.rod@outlook.com',
    );
  });
}
